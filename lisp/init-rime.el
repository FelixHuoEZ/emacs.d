;; init-rime.el --- Rime input method support -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Use a dedicated user data directory for emacs-rime while reusing the
;; macOS Squirrel shared data directory and the same sync target.

;;; Code:

(defconst hsk/rime-source-data-dir
  (expand-file-name "~/Library/Rime")
  "Rime data directory managed by Squirrel on macOS.")

(defconst hsk/rime-user-data-dir
  (expand-file-name "rime" user-emacs-directory)
  "Dedicated Rime user data directory for emacs-rime.")

(defconst hsk/rime-share-data-dir
  (let ((dir "/Library/Input Methods/Squirrel.app/Contents/SharedSupport"))
    (when (file-directory-p dir)
      dir))
  "Rime shared data directory provided by Squirrel on macOS.")

(defun hsk/rime--find-librime-root ()
  "Return the Homebrew prefix that provides librime, or nil."
  (catch 'root
    (dolist (root '("/opt/homebrew" "/usr/local"))
      (when (and (file-exists-p (expand-file-name "include/rime_api.h" root))
                 (file-exists-p (expand-file-name "lib/librime.dylib" root)))
        (throw 'root root)))))

(defconst hsk/rime-librime-root
  (hsk/rime--find-librime-root)
  "Detected Homebrew prefix for librime.")

(defconst hsk/rime-emacs-module-header-root
  (let ((dir (expand-file-name "../include" data-directory)))
    (when (file-exists-p (expand-file-name "emacs-module.h" dir))
      dir))
  "Detected directory that contains `emacs-module.h'.")

(defun hsk/rime--read-installation-value (dir key)
  "Read KEY from DIR/installation.yaml, or nil."
  (let ((file (expand-file-name "installation.yaml" dir)))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (when (re-search-forward
               (format "^%s:[[:space:]]*['\"]?\\([^'\n\"]+\\)['\"]?$" key)
               nil t)
          (match-string 1))))))

(defconst hsk/rime-installation-id
  (let ((source-id (hsk/rime--read-installation-value
                    hsk/rime-source-data-dir "installation_id")))
    (if (and source-id (not (string-suffix-p "-emacs" source-id)))
        (concat source-id "-emacs")
      "emacs-rime"))
  "Dedicated installation ID for emacs-rime sync snapshots.")

(defconst hsk/rime-sync-dir
  (or (hsk/rime--read-installation-value hsk/rime-source-data-dir "sync_dir")
      (hsk/rime--read-installation-value hsk/rime-user-data-dir "sync_dir"))
  "Shared Rime sync directory used by emacs-rime.")

(defconst hsk/rime-sync-excludes
  '("installation.yaml"
    "build/"
    "*.userdb/"
    "*.userdb.txt"
    "*.userdb.kct"
    ".DS_Store")
  "Files and directories excluded from config sync.")

(defvar hsk/rime--config-diff-check-scheduled nil
  "Non-nil once the config drift reminder has been scheduled in this session.")

(defconst hsk/rime-config-diff-idle-seconds (* 10 60)
  "Seconds of Emacs idle time before checking Rime config drift once.")

(defvar hsk/rime--exit-finalized nil
  "Non-nil once librime has been explicitly finalized during shutdown.")

(defun hsk/rime--rsync-args (source-dir target-dir &optional dry-run)
  "Build rsync args from SOURCE-DIR to TARGET-DIR.
When DRY-RUN is non-nil, include diff-style preview flags."
  (append
   (when dry-run
     '("--dry-run" "--itemize-changes" "--checksum" "--omit-dir-times"))
   '("-a" "--delete")
   (apply #'append
          (mapcar (lambda (entry)
                    (list "--exclude" entry))
                  hsk/rime-sync-excludes))
   (list (file-name-as-directory source-dir)
         (file-name-as-directory target-dir))))

(defun hsk/rime--run-rsync (source-dir target-dir &optional dry-run)
  "Run rsync from SOURCE-DIR to TARGET-DIR.
Return a cons cell of the process status and rsync output.  When DRY-RUN is
non-nil, include diff-style preview flags."
  (make-directory target-dir t)
  (with-temp-buffer
    (let ((status (apply #'call-process "rsync" nil t nil
                         (hsk/rime--rsync-args source-dir target-dir dry-run))))
      (cons status (buffer-string)))))

(defun hsk/rime--normalize-diff-output (output)
  "Strip timestamp-only noise from rsync OUTPUT."
  (let (lines)
    (dolist (line (split-string output "\n" t))
      (unless (or (string-prefix-p ".d..t.... " line)
                  (string-prefix-p ".f..t.... " line))
        (push line lines)))
    (string-join (nreverse lines) "\n")))

(defun hsk/rime--patch-search-lua (&optional dir)
  "Patch the copied `search.lua' for Lua 5.4 compatibility in DIR."
  (let ((file (expand-file-name "lua/search.lua"
                                (or dir hsk/rime-user-data-dir))))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (when (search-forward "            i = i + 1\n" nil t)
          (replace-match "" t t)
          (write-region nil nil file nil 'silent))))))

(defun hsk/rime--patch-cn-en-spacer (&optional dir)
  "Patch the copied `cn_en_spacer.lua' for Lua 5.4 compatibility in DIR."
  (let ((file (expand-file-name "lua/cn_en_spacer.lua"
                                (or dir hsk/rime-user-data-dir))))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (when (search-forward "        if is_mixed_cn_en_num(cand.text) then\n            cand = cand:to_shadow_candidate(cand.type, add_spaces(cand.text), cand.comment)\n        end\n        yield(cand)\n" nil t)
          (replace-match "        if is_mixed_cn_en_num(cand.text) then\n            yield(cand:to_shadow_candidate(cand.type, add_spaces(cand.text), cand.comment))\n        else\n            yield(cand)\n        end\n" t t)
          (write-region nil nil file nil 'silent))))))

(defun hsk/rime--patch-en-spacer (&optional dir)
  "Patch the copied `en_spacer.lua' for Lua 5.4 compatibility in DIR."
  (let ((file (expand-file-name "lua/en_spacer.lua"
                                (or dir hsk/rime-user-data-dir))))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (when (search-forward "        if cand.text:match( '^[%a\\']+[%a\\']*$' ) and latest_text and #latest_text > 0 and\n            latest_text:find( '^ ?[%a\\']+[%a\\']*$' ) then\n            cand = cand:to_shadow_candidate( 'en_spacer', cand.text:gsub( '(%a+\\'?%a*)', ' %1' ), cand.comment )\n        end\n        yield( cand )\n" nil t)
          (replace-match "        if cand.text:match( '^[%a\\']+[%a\\']*$' ) and latest_text and #latest_text > 0 and\n            latest_text:find( '^ ?[%a\\']+[%a\\']*$' ) then\n            yield(cand:to_shadow_candidate( 'en_spacer', cand.text:gsub( '(%a+\\'?%a*)', ' %1' ), cand.comment ))\n        else\n            yield( cand )\n        end\n" t t)
          (write-region nil nil file nil 'silent))))))

(defun hsk/rime--patch-rime-lua (&optional dir)
  "Patch the copied `rime.lua' for emacs-rime compatibility in DIR."
  (let ((file (expand-file-name "rime.lua"
                                (or dir hsk/rime-user-data-dir))))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (when (search-forward "function force_gc()\n    -- collectgarbage()\n    collectgarbage(\"step\")\nend\n" nil t)
          (replace-match "force_gc = {\n    func = function(input, seg, env)\n        collectgarbage(\"step\")\n    end\n}\n" t t)
          (write-region nil nil file nil 'silent))))))

(defun hsk/rime--patch-rime-ice-schema (&optional dir)
  "Remove incompatible translator entries from `rime_ice.schema.yaml' in DIR."
  (let ((file (expand-file-name "rime_ice.schema.yaml"
                                (or dir hsk/rime-user-data-dir))))
    (when (file-exists-p file)
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (when (search-forward "    - lua_translator@force_gc           # 暴力 GC\n" nil t)
          (replace-match "" t t)
          (write-region nil nil file nil 'silent))))))

(defun hsk/rime--apply-compat-patches (&optional dir)
  "Apply emacs-rime compatibility patches in DIR."
  (hsk/rime--patch-search-lua dir)
  (hsk/rime--patch-cn-en-spacer dir)
  (hsk/rime--patch-en-spacer dir)
  (hsk/rime--patch-rime-lua dir)
  (hsk/rime--patch-rime-ice-schema dir))

(defun hsk/rime--ensure-installation-yaml ()
  "Keep emacs-rime metadata distinct while reusing the shared sync target."
  (let ((file (expand-file-name "installation.yaml" hsk/rime-user-data-dir)))
    (when (file-directory-p hsk/rime-user-data-dir)
      (with-temp-buffer
        (when (file-exists-p file)
          (insert-file-contents file))
        (let ((original (buffer-string)))
          (goto-char (point-min))
          (if (re-search-forward "^installation_id:[[:space:]]*['\"]?\\([^'\n\"]+\\)['\"]?$" nil t)
              (replace-match (format "installation_id: %s" hsk/rime-installation-id) t t)
            (goto-char (point-max))
            (unless (bolp)
              (insert "\n"))
            (insert (format "installation_id: %s\n" hsk/rime-installation-id)))
          (when hsk/rime-sync-dir
            (goto-char (point-min))
            (if (re-search-forward "^sync_dir:[[:space:]]*['\"]?\\([^'\n\"]+\\)['\"]?$" nil t)
                (replace-match (format "sync_dir: \"%s\"" hsk/rime-sync-dir) t t)
              (goto-char (point-max))
              (unless (bolp)
                (insert "\n"))
              (insert (format "sync_dir: \"%s\"\n" hsk/rime-sync-dir))))
          (unless (string-equal original (buffer-string))
            (write-region nil nil file nil 'silent)))))))

(defun hsk/rime--config-diff-output ()
  "Return current config diff output as a string, or nil on failure."
  (when (and (file-directory-p hsk/rime-source-data-dir)
             (file-directory-p hsk/rime-user-data-dir)
             (executable-find "rsync"))
    (let* ((temp-root (make-temp-file "rime-config-diff-" t))
           (prepared-source (expand-file-name "source" temp-root)))
      (unwind-protect
          (let* ((sync-result (hsk/rime--run-rsync hsk/rime-source-data-dir
                                                   prepared-source))
                 (sync-status (car sync-result)))
            (when (zerop sync-status)
              (hsk/rime--apply-compat-patches prepared-source)
              (let* ((diff-result (hsk/rime--run-rsync prepared-source
                                                       hsk/rime-user-data-dir t))
                     (diff-status (car diff-result))
                     (diff-output (cdr diff-result)))
                (when (zerop diff-status)
                  (string-trim-right
                   (hsk/rime--normalize-diff-output diff-output))))))
        (delete-directory temp-root t)))))

(defun hsk/rime-sync-config ()
  "Sync config assets from `hsk/rime-source-data-dir' into `hsk/rime-user-data-dir'.

This keeps schemas, Lua files and dictionaries aligned with the primary
macOS Rime config while preserving emacs-rime's own `installation.yaml',
generated `build/' outputs and local `*.userdb/' data."
  (interactive)
  (when (and (file-directory-p hsk/rime-source-data-dir)
             (executable-find "rsync"))
    (let* ((result (hsk/rime--run-rsync hsk/rime-source-data-dir
                                        hsk/rime-user-data-dir))
           (status (car result))
           (output (cdr result)))
      (if (zerop status)
          (progn
            (hsk/rime--apply-compat-patches)
            (hsk/rime--ensure-installation-yaml))
        (message "Failed to sync Rime config for emacs-rime: %s" output)))))

(defalias 'hsk/rime-bootstrap-user-data #'hsk/rime-sync-config)

(defun hsk/rime-show-config-diff ()
  "Show pending config differences between Squirrel and emacs-rime."
  (interactive)
  (let ((buffer (get-buffer-create "*rime-config-diff*"))
        (output (hsk/rime--config-diff-output)))
    (with-current-buffer buffer
      (erase-buffer)
      (insert (if (and output (not (string-empty-p output)))
                  output
                "No config differences.\n"))
      (goto-char (point-min)))
    (display-buffer buffer)))

(defun hsk/rime-notify-config-drift ()
  "Remind the user when emacs-rime config differs from Squirrel config."
  (let ((output (hsk/rime--config-diff-output)))
    (when (and output
               (not (string-empty-p output)))
      (message "Rime config differs from ~/Library/Rime. Run M-x hsk/rime-sync-config to apply or M-x hsk/rime-show-config-diff to inspect."))))

(defun hsk/rime-schedule-config-drift-check ()
  "Schedule a one-shot idle check for config drift."
  (when (and (not noninteractive)
             (not hsk/rime--config-diff-check-scheduled)
             (file-directory-p hsk/rime-source-data-dir)
             (file-directory-p hsk/rime-user-data-dir)
             (executable-find "rsync"))
    (setq hsk/rime--config-diff-check-scheduled t)
    (run-with-idle-timer hsk/rime-config-diff-idle-seconds
                         nil
                         #'hsk/rime-notify-config-drift)))

(defun hsk/rime-finalize-before-exit ()
  "Finalize librime before Emacs exits.

This works around crashes in librime's shutdown path by cleaning up while
Emacs is still fully alive."
  (when (and (not hsk/rime--exit-finalized)
             (featurep 'rime)
             (bound-and-true-p rime--lib-loaded)
             (fboundp 'rime-lib-finalize))
    (setq hsk/rime--exit-finalized t)
    (ignore-errors
      (rime-lib-finalize))))

(defun hsk/rime--ascii-token-before-point ()
  "Return the ASCII token before point as (START END TEXT), or nil."
  (save-excursion
    (let ((end (point)))
      (skip-chars-backward "A-Za-z'-")
      (when (< (point) end)
        (list (point)
              end
              (buffer-substring-no-properties (point) end))))))

(defun hsk/rime-force-enable-or-convert ()
  "Force-enable Rime, or convert the ASCII token before point into Rime input.

If point is after an ASCII token, remove it and feed it back through
Rime so it becomes the current preedit string. Otherwise, fall back to
`rime-force-enable'."
  (interactive)
  (unless (equal current-input-method "rime")
    (activate-input-method "rime"))
  (pcase (hsk/rime--ascii-token-before-point)
    (`(,start ,end ,text)
     (delete-region start end)
     (rime-force-enable)
     (setq unread-command-events
           (append (string-to-list text) unread-command-events)))
    (_
     (rime-force-enable))))

(defun hsk/rime-toggle-input-method ()
  "Toggle input method, always preferring Rime when enabling."
  (interactive)
  (setq default-input-method "rime")
  (setq input-method-history
        (cons "rime" (delete "rime" input-method-history)))
  (toggle-input-method))

(defun hsk/rime-ready-p ()
  "Return non-nil when the local machine is ready to load emacs-rime."
  (and (eq system-type 'darwin)
       hsk/rime-librime-root
       hsk/rime-emacs-module-header-root
       hsk/rime-share-data-dir
       (file-directory-p hsk/rime-user-data-dir)))

(when (file-directory-p hsk/rime-user-data-dir)
  (hsk/rime--ensure-installation-yaml))

(hsk/rime-schedule-config-drift-check)

(when (and (eq system-type 'darwin)
           (not (hsk/rime-ready-p)))
  (message "Rime is not ready. Install librime and sync config with M-x hsk/rime-sync-config."))

(when (hsk/rime-ready-p)
  (setq default-input-method "rime")
  (setq input-method-history
        (cons "rime" (delete "rime" input-method-history))))

(use-package rime
  :if (hsk/rime-ready-p)
  :custom
  (rime-librime-root hsk/rime-librime-root)
  (rime-emacs-module-header-root hsk/rime-emacs-module-header-root)
  (rime-share-data-dir hsk/rime-share-data-dir)
  (rime-user-data-dir hsk/rime-user-data-dir)
  (rime-show-candidate 'posframe)
  (rime-show-preedit 'inline)
  (rime-posframe-style 'vertical)
  (rime-disable-predicates
   '(rime-predicate-ace-window-p
     rime-predicate-after-alphabet-char-p
     rime-predicate-current-uppercase-letter-p
     rime-predicate-hydra-p
     rime-predicate-prog-in-code-p))
  (rime-inline-predicates
   '(rime-predicate-space-after-cc-p))
  :config
  (add-hook 'kill-emacs-hook #'hsk/rime-finalize-before-exit)
  :bind
  (("C-\\" . hsk/rime-toggle-input-method)
   ("C-c ;" . hsk/rime-toggle-input-method)
   ("M-j" . hsk/rime-force-enable-or-convert)))

(provide 'init-rime)

;;; init-rime.el ends here
