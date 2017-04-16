(require-package 'org-fstree)
(when *is-a-mac*
  (maybe-require-package 'grab-mac-link)
  (require-package 'org-mac-iCal))

(maybe-require-package 'org-cliplink)

(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

;; Various preferences
(setq
 ;; org-log-done t
 ;; org-log-done 'time
 org-log-done 'note
 org-startup-indented t
 visual-line-mode t
 org-edit-timestamp-down-means-later t
 org-archive-mark-done nil
 org-hide-emphasis-markers t
 org-catch-invisible-edits 'show
 org-export-coding-system 'utf-8
 org-fast-tag-selection-single-key 'expert
 org-html-validation-link nil
 org-export-kill-product-buffer-when-displayed t
 org-tags-column 80)


;;; Sacco General Settings

(define-key global-map (kbd "C-c g l") 'org-toggle-link-display)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

;; (global-set-key (kbd "C-c l") 'org-store-link)
;; (global-set-key (kbd "C-c a") 'org-agenda)
;; (global-set-key (kbd "C-c b") 'org-iswitchb)

;; (define-key global-map (kbd "C-c l") 'org-store-link)
;; (define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c b") 'org-iswitchb)
;; (define-key global-map (kbd "C-c b") 'org-table-blank-field)

;; (setq-default  org-log-done 'note)

;; solve the impossible problem of escape double quote and single quote
(after-load 'org
  ;; (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n\r")
  ;; (custom-set-variables `(org-emphasis-alist ',org-emphasis-alist))
  ;; (org-element-set-regexps)

  ;; (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,\"'")

  (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n")
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

  ;; [[http://emacs.stackexchange.com/questions/13820/inline-verbatim-and-code-with-quotes-in-org-mode/13828#13828][Inline verbatim and code with quotes in Org-mode - Emacs Stack Exchange]]
  )


;; set folded headline with inverted triangle
(setq org-ellipsis "▼")

(after-load 'org
  ;;----------------- 设置各级标题样式 ----------------------
  (set-face-attribute 'org-level-1 nil :height 1.1 :bold t :foreground "yellow4")
  (set-face-attribute 'org-level-2 nil :height 1.1 :bold t)
  (set-face-attribute 'org-level-3 nil :height 1.0 :bold t)
  )

;;org-bullets
(require-package 'org-bullets)
(require 'org-bullets)
(setq org-bullets-bullet-list  '("✸" "●" "○" "◆" "◇" "▹"))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;enable rainbow-delimiters-mode in several major mode, I donot exactly undertant this currently
(add-hook 'org-mode-hook #'rainbow-delimiters-mode)
(add-hook 'ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'inferior-ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; ;;How do I make Org-mode open PDF files
;; (eval-after-load "org"
;;   '(progn
;;      ;; .txt files aren't in the list initially, but in case that changes
;;      ;; in a future version of org, use if to avoid errors
;;      (if (assoc "\\.txt\\'" org-file-apps)
;;          (setcdr (assoc "\\.txt\\'" org-file-apps) "notepad.exe %s")
;;        (add-to-list 'org-file-apps '("\\.txt\\'" . "notepad.exe %s") t))
;;      ;; Change .pdf association directly within the alist
;;      (setcdr (assoc "\\.pdf\\'" org-file-apps) "sumatrapdf %s")
;;      (add-to-list 'org-file-apps '("\\.png\\'" . default))))


;; 下面这部分应该已经被 truncate 取代了吧？
;;----------------- 设置 auto fill width -----------------
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (set-fill-column 80)))

;;; mobile-org
;; Set to the location of your Org files on your local system
(setq org-directory "~/orgfile")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/orgfile/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "E:/Dropbox/Apps/MobileOrg")


;;; Sacco General Settings Ends



;;; ditta

;; Lots of stuff from http://doc.norang.ca/org-mode.html

(defun sanityinc/grab-ditaa (url jar-name)
  "Download URL and extract JAR-NAME as `org-ditaa-jar-path'."
  ;; TODO: handle errors
  (message "Grabbing " jar-name " for org.")
  (let ((zip-temp (make-temp-name "emacs-ditaa")))
    (unwind-protect
        (progn
          (when (executable-find "unzip")
            (url-copy-file url zip-temp)
            (shell-command (concat "unzip -p " (shell-quote-argument zip-temp)
                                   " " (shell-quote-argument jar-name) " > "
                                   (shell-quote-argument org-ditaa-jar-path)))))
      (when (file-exists-p zip-temp)
        (delete-file zip-temp)))))

(after-load 'ob-ditaa
  (unless (and (boundp 'org-ditaa-jar-path)
               (file-exists-p org-ditaa-jar-path))
    (let ((jar-name "ditaa0_9.jar")
          (url "http://jaist.dl.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip"))
      (setq org-ditaa-jar-path (expand-file-name jar-name user-emacs-directory))
      (unless (file-exists-p org-ditaa-jar-path)
        (sanityinc/grab-ditaa url jar-name)))))



(define-minor-mode prose-mode
  "Set up a buffer for prose editing.
This enables or modifies a number of settings so that the
experience of editing prose is a little more like that of a
typical word processor."
  nil " Prose" nil
  (if prose-mode
      (progn
        (setq truncate-lines nil)
        (setq word-wrap t)
        (setq cursor-type 'bar)
        (when (eq major-mode 'org)
          (kill-local-variable 'buffer-face-mode-face))
        (buffer-face-mode 1)
        ;;(delete-selection-mode 1)
        (set (make-local-variable 'blink-cursor-interval) 0.6)
        (set (make-local-variable 'show-trailing-whitespace) nil)
        (flyspell-mode 1)
        (visual-line-mode 1))
    (kill-local-variable 'truncate-lines)
    (kill-local-variable 'word-wrap)
    (kill-local-variable 'cursor-type)
    (kill-local-variable 'show-trailing-whitespace)
    (buffer-face-mode -1)
    ;; (delete-selection-mode -1)
    (flyspell-mode -1)
    (visual-line-mode -1)))

;;(add-hook 'org-mode-hook 'buffer-face-mode)


(setq org-support-shift-select t)

;;; Capturing

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      `(("t" "todo" entry (file "~/orgfile/GTD/newgtd.org")  ; "newgtd.org" => org-default-gtd-file
         "* NEXT %?\n%U\n" :clock-resume t)
        ("n" "note" entry (file "~/orgfile/GTD/journal.org") ; "journal.org" => org-default-note-file
         "* %? :NOTE:\n%U\n%a\n" :clock-resume t)
        ))
(setq org-agenda-files (quote ("~/orgfile/GTD/newgtd.org"
                               "~/orgfile/GTD/journal.org"
                               "~/orgfile/GTD/someday.org"
                               "~/orgfile/GTD/birthday.org")))

;;; Refiling

(setq org-refile-use-cache nil)

                                        ; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))

(after-load 'org-agenda
  (add-to-list 'org-agenda-after-show-hook 'org-show-entry))

(defadvice org-refile (after sanityinc/save-all-after-refile activate)
  "Save all org buffers after each refile operation."
  (org-save-all-org-buffers))

;; Exclude DONE state tasks from refile targets
(defun sanityinc/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets."
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'sanityinc/verify-refile-target)

(defun sanityinc/org-refile-anywhere (&optional goto default-buffer rfloc msg)
  "A version of `org-refile' which allows refiling to any subtree."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-refile goto default-buffer rfloc msg)))

(defun sanityinc/org-agenda-refile-anywhere (&optional goto rfloc no-update)
  "A version of `org-agenda-refile' which allows refiling to any subtree."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-agenda-refile goto rfloc no-update)))

;; Targets start with the file name - allows creating level 1 tasks
;;(setq org-refile-use-outline-path (quote file))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)


;;; To-do settings

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d@/!)")
              (sequence "PROJECT(p)" "|" "DONE(d@/!)" "CANCELLED(c@/!)")
              (sequence "WAITING(w@/!)" "DELEGATED(e!)" "HOLD(h)" "|" "CANCELLED(c@/!)")))
      org-todo-repeat-to-state "NEXT")

(setq org-todo-keyword-faces
      (quote (("NEXT" :inherit warning)
              ("PROJECT" :inherit font-lock-string-face))))



;;; Agenda views

(setq-default org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3))


(let ((active-project-match "-INBOX/PROJECT"))

  (setq org-stuck-projects
        `(,active-project-match ("NEXT")))

  (setq org-agenda-compact-blocks t
        org-agenda-sticky t
        org-agenda-start-on-weekday nil
        org-agenda-span 'day
        org-agenda-include-diary nil
        org-agenda-sorting-strategy
        '((agenda habit-down time-up user-defined-up effort-up category-keep)
          (todo category-up effort-up)
          (tags category-up effort-up)
          (search category-up))
        org-agenda-window-setup 'current-window
        org-agenda-custom-commands
        `(("N" "Notes" tags "NOTE"
           ((org-agenda-overriding-header "Notes")
            (org-tags-match-list-sublevels t)))
          ("g" "GTD"
           ((agenda "" nil)
            (tags "INBOX"
                  ((org-agenda-overriding-header "Inbox")
                   (org-tags-match-list-sublevels nil)))
            (stuck ""
                   ((org-agenda-overriding-header "Stuck Projects")
                    (org-agenda-tags-todo-honor-ignore-options t)
                    (org-tags-match-list-sublevels t)
                    (org-agenda-todo-ignore-scheduled 'future)))
            (tags-todo "-INBOX/NEXT"
                       ((org-agenda-overriding-header "Next Actions")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        ;; TODO: skip if a parent is WAITING or HOLD
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(todo-state-down effort-up category-keep))))
            (tags-todo ,active-project-match
                       ((org-agenda-overriding-header "Projects")
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX/-NEXT"
                       ((org-agenda-overriding-header "Orphaned Tasks")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        ;; TODO: skip if a parent is a project
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("PROJECT" "HOLD" "WAITING" "DELEGATED"))
                                (org-agenda-skip-subtree-if 'nottododo '("TODO")))))
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/WAITING"
                       ((org-agenda-overriding-header "Waiting")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/DELEGATED"
                       ((org-agenda-overriding-header "Delegated")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX/HOLD"
                       ((org-agenda-overriding-header "On Hold")
                        ;; TODO: skip if a parent is WAITING or HOLD
                        (org-tags-match-list-sublevels nil)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            ;; (tags-todo "-NEXT"
            ;;            ((org-agenda-overriding-header "All other TODOs")
            ;;             (org-match-list-sublevels t)))
            )))))


(add-hook 'org-agenda-mode-hook 'hl-line-mode)


;;; Org clock

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(after-load 'org
  (org-clock-persistence-insinuate))
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Save state changes in the LOGBOOK drawer
(setq org-log-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show clock sums as hours and minutes, not "n days" etc.
(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))



;;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(after-load 'org-clock
  (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
  (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu))



(when (and *is-a-mac* (file-directory-p "/Applications/org-clock-statusbar.app"))
  (add-hook 'org-clock-in-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                (concat "tell application \"org-clock-statusbar\" to clock in \"" org-clock-current-task "\""))))
  (add-hook 'org-clock-out-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                "tell application \"org-clock-statusbar\" to clock out"))))



;; Remove empty LOGBOOK drawers on clock out
(defun sanityinc/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(after-load 'org-clock
  (add-hook 'org-clock-out-hook 'sanityinc/remove-empty-drawer-on-clock-out 'append))



;; TODO: warn about inconsistent items, e.g. TODO inside non-PROJECT
;; TODO: nested projects!



;;; Archiving

(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archive")





(require-package 'org-pomodoro)
(setq org-pomodoro-keep-killed-pomodoro-time t)
(after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro))


;; ;; Show iCal calendars in the org agenda
;; (when (and *is-a-mac* (require 'org-mac-iCal nil t))
;;   (setq org-agenda-include-diary t
;;         org-agenda-custom-commands
;;         '(("I" "Import diary from iCal" agenda ""
;;            ((org-agenda-mode-hook #'org-mac-iCal)))))

;;   (add-hook 'org-agenda-cleanup-fancy-diary-hook
;;             (lambda ()
;;               (goto-char (point-min))
;;               (save-excursion
;;                 (while (re-search-forward "^[a-z]" nil t)
;;                   (goto-char (match-beginning 0))
;;                   (insert "0:00-24:00 ")))
;;               (while (re-search-forward "^ [a-z]" nil t)
;;                 (goto-char (match-beginning 0))
;;                 (save-excursion
;;                   (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
;;                 (insert (match-string 0))))))


(after-load 'org
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (define-key org-mode-map (kbd "M-h") nil)
    (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link)))


;;; org-babel
(after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   `(
     ;; (R  . t)
     (ditaa . t)
     ;; (asymptote . t)
     (dot . t)
     (emacs-lisp . t)
     (gnuplot . t)
     (haskell . nil)
     (latex . t)
     (ledger . t)
     (ocaml . nil)
     (octave . t)
     (python . t)
     (ruby . t)
     (screen . nil)
     (,(if (locate-library "ob-sh") 'sh 'shell) . t)
     (sql . nil)
     (sqlite . t))))



;;; Private User Misc Settings

;;; Do not ask if to avaluate the code blocks
(defun my-org-confirm-babel-evaluate (lang body)
  (and
   (not (string= lang "latex"))         ;don't ask for latex
   (not (string= lang "emacs-lisp"))    ;don't ask for elisp
   (not (string= lang "sh"))            ;don't ask for shell
   (not (string= lang "python"))))      ;don't ask for python

(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;; org-edit-latex
(use-package org-edit-latex)


;;; increasingly renumber the equation in fragment
(defun org-renumber-environment (orig-func &rest args)
  (let ((results '())
        (counter -1)
        (numberp))

    (setq results (loop for (begin .  env) in
                        (org-element-map (org-element-parse-buffer) 'latex-environment
                          (lambda (env)
                            (cons
                             (org-element-property :begin env)
                             (org-element-property :value env))))
                        collect
                        (cond
                         ((and (string-match "\\\\begin{equation}" env)
                               (not (string-match "\\\\tag{" env)))
                          (incf counter)
                          (cons begin counter))
                         ((string-match "\\\\begin{align}" env)
                          (prog2
                              (incf counter)
                              (cons begin counter)
                            (with-temp-buffer
                              (insert env)
                              (goto-char (point-min))
                              ;; \\ is used for a new line. Each one leads to a number
                              (incf counter (count-matches "\\\\$"))
                              ;; unless there are nonumbers.
                              (goto-char (point-min))
                              (decf counter (count-matches "\\nonumber")))))
                         (t
                          (cons begin nil)))))

    (when (setq numberp (cdr (assoc (point) results)))
      (setf (car args)
            (concat
             (format "\\setcounter{equation}{%s}\n" numberp)
             (car args)))))

  (apply orig-func args))

(advice-add 'org-create-formula-image :around #'org-renumber-environment)
;; (advice-remove 'org-create-formula-image #'org-renumber-environment)

;;; org-ref and bibtex

(use-package org-ref
  :config
  (use-package ivy-bibtex)
  (require 'doi-utils)
  ;; doi-utils-add-bibtex-entry-from-doi and doi-utils-add-entry-from-crossref-query
  (require 'org-ref-wos)
  (require 'org-ref-scopus)
  (require 'org-ref-isbn)
  (require 'org-ref-pubmed)
  (require 'org-ref-arxiv)
  (require 'org-ref-sci-id)
  (require 'x2bib)

  (setq org-ref-completion-library 'org-ref-ivy-cite)
  ;; on Linux or macOS, just use ln command to make a symbol link or hard link
  ;; on Windows, you should make a symbol link from your zotero export bib file to ~/.emacs.d/zoterobib.bib
  ;; mklink "<path-to-home>/.emacs.d/zoterobib.bib" "<path-and-filename-to-zotero-export-bib>"
  (setq reftex-default-bibliography '(expand-file-name "zoterobib.bib" user-emacs-directory))
  (setq bibtex-completion-pdf-symbol "⌘")
  (setq bibtex-completion-notes-symbol "✎")

  ;; see org-ref for use of these variables
  (setq org-ref-bibliography-notes "D:/MyDocuments/My Knowledge/Data/private-email@example.invalid/Academic/Projects/S 波段双圆极化天线/S波段双圆极化天线文档/双圆极化天线论文笔记.org_Attachments/note-of-dual-circular-polarized-antenna-papers.org"
        org-ref-default-bibliography '("E:/Zotero/autobib/zoteroexport.bib")
        org-ref-pdf-directory "E:/Zotero/storage/")
  (setq bibtex-completion-bibliography "E:/Zotero/autobib/zoteroexport.bib"
        bibtex-completion-library-path "E:/Zotero/storage"
        bibtex-completion-notes-path "E:/Zotero/storage")

  ;; open pdf with system pdf viewer (works on mac)
  ;; (setq bibtex-completion-pdf-open-function
  ;;       (lambda (fpath)
  ;;         (start-process "open" "*open*" "open" fpath)))

  ;; alternative
  ;; (setq bibtex-completion-pdf-open-function 'org-open-file)

  (setq bibtex-completion-pdf-field "File")
  (defun hsk/org-ref-open-pdf-at-point ()
    "Open the pdf for bibtex key under point if it exists."
    (interactive)
    (let* ((results (org-ref-get-bibtex-key-and-file))
           (key (car results))
           (pdf-file (car (bibtex-completion-find-pdf key))))
      (if (file-exists-p pdf-file)
          (org-open-file pdf-file)
        (message "No PDF found for %s" key))))

  (setq org-ref-open-pdf-function 'hsk/org-ref-open-pdf-at-point)
  )




;;highlight code in src code block
(setq org-src-fontify-natively t)
(after-load 'org
  (define-key org-mode-map (kbd "C-<tab>") nil)
  (define-key org-mode-map (kbd "C-S-<tab>") nil)
  )

;;; Private User Misc Settings Ends

(provide 'init-org)
