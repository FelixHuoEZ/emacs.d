(require 'init-const)
(require 'init-funcs)

;; Directory operations
(use-package dired
  :ensure nil
  :bind (:map dired-mode-map
              ("C-c C-p" . wdired-change-to-wdired-mode)
              ([mouse-2] . dired-find-file)
              ("M-o" . dired-open-file)
              )
  :config
  ;; Always delete and copy recursively
  (setq dired-recursive-deletes 'always
        dired-recursive-copies 'always)

  ;; 用 xdg-open 打开文件
  ;; on Windows wsl2, 用下面这一行来让 xdg-open 指向 wslview
  ;; ln -s /usr/bin/wslview /usr/local/bin/xdg-open
  (defun dired-open-file ()
    "In dired, open the file named on this line."
    (interactive)
    (let* ((file (dired-get-filename nil t)))
      (message "Opening %s..." file)
      (call-process "xdg-open" nil 0 nil file)
      (message "Opening %s done" file)))

  (when sys/macp
    ;; Suppress the warning: `ls does not support --dired'.
    (setq dired-use-ls-dired nil)

    (when (executable-find "gls")
      ;; Use GNU ls as `gls' from `coreutils' if available.
      (setq insert-directory-program "gls")))

  (when (or (and sys/macp (executable-find "gls"))
            (and (not sys/macp) (executable-find "ls")))
    ;; Using `insert-directory-program'
    (setq ls-lisp-use-insert-directory-program t)

    ;; Show directory first
    (setq dired-listing-switches "-alh --group-directories-first")

    ;; Quick sort dired buffers via hydra
    (use-package dired-quick-sort
      :bind (:map dired-mode-map
                  ("S" . hydra-dired-quick-sort/body))))

  ;; Show git info in dired
  (use-package dired-git-info
    :bind (:map dired-mode-map
                (")" . dired-git-info-mode)))

  ;; Allow rsync from dired buffers
  (use-package dired-rsync
    :bind (:map dired-mode-map
                ("C-c C-r" . dired-rsync)))

  ;; Colourful dired
  (use-package diredfl
    :init (diredfl-global-mode 1))

  ;; Shows icons
  (use-package all-the-icons-dired
    :diminish
    :hook (dired-mode . (lambda ()
                          (when (icon-displayable-p)
                            (all-the-icons-dired-mode))))
    :init (setq all-the-icons-dired-monochrome nil)
    :config
    (with-no-warnings
      (defun my-all-the-icons-dired--refresh ()
        "Display the icons of files in a dired buffer."
        (all-the-icons-dired--remove-all-overlays)
        ;; NOTE: don't display icons it too many items
        (if (<= (count-lines (point-min) (point-max)) 1000)
            (save-excursion
              (goto-char (point-min))
              (while (not (eobp))
                (when (dired-move-to-filename nil)
                  (let ((case-fold-search t))
                    (when-let* ((file (dired-get-filename 'relative 'noerror))
                                (icon (if (file-directory-p file)
                                          (all-the-icons-icon-for-dir
                                           file
                                           :face 'all-the-icons-dired-dir-face
                                           :height 0.9
                                           :v-adjust all-the-icons-dired-v-adjust)
                                        (apply #'all-the-icons-icon-for-file
                                               file
                                               (append
                                                '(:height 0.9)
                                                `(:v-adjust ,all-the-icons-dired-v-adjust)
                                                (when all-the-icons-dired-monochrome
                                                  `(:face ,(face-at-point))))))))
                      (if (member file '("." ".."))
                          (all-the-icons-dired--add-overlay (dired-move-to-filename) "   \t")
                        (all-the-icons-dired--add-overlay (dired-move-to-filename) (concat " " icon "\t"))))))
                (forward-line 1)))
          (message "Not display icons because of too many items.")))
      (advice-add #'all-the-icons-dired--refresh :override #'my-all-the-icons-dired--refresh)))

  ;; Extra Dired functionality
  (use-package dired-aux :ensure nil)
  (use-package dired-x
    :ensure nil
    :demand t
    :config
    (let ((cmd (cond (sys/mac-x-p "open")
                     (sys/linux-x-p "xdg-open")
                     (sys/win32p "start")
                     (t ""))))
      (setq dired-guess-shell-alist-user
            `(("\\.pdf\\'" ,cmd)
              ("\\.docx\\'" ,cmd)
              ("\\.\\(?:djvu\\|eps\\)\\'" ,cmd)
              ("\\.\\(?:jpg\\|jpeg\\|png\\|gif\\|xpm\\)\\'" ,cmd)
              ("\\.\\(?:xcf\\)\\'" ,cmd)
              ("\\.csv\\'" ,cmd)
              ("\\.tex\\'" ,cmd)
              ("\\.\\(?:mp4\\|mkv\\|avi\\|flv\\|rm\\|rmvb\\|ogv\\)\\(?:\\.part\\)?\\'" ,cmd)
              ("\\.\\(?:mp3\\|flac\\)\\'" ,cmd)
              ("\\.html?\\'" ,cmd)
              ("\\.md\\'" ,cmd))))

    (setq dired-omit-files
          (concat dired-omit-files
                  "\\|^.DS_Store$\\|^.projectile$\\|^.git*\\|^.svn$\\|^.vscode$\\|\\.js\\.meta$\\|\\.meta$\\|\\.elc$\\|^.emacs.*"))))

;; `find-dired' alternative using `fd'
(when (executable-find "fd")
  (use-package fd-dired))



;; (require-package 'dired-sort)


;; (setq-default dired-dwim-target t)



(when (maybe-require-package 'diff-hl)
  (after-load 'dired
              (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

;; (add-hook 'dired-mode-hook
;;           (lambda ()
;;             (highlight-lines-matching-regexp "\.\(org\)\|\(tex\)$" 'hi-yellow)))

(add-hook 'dired-mode-hook
          (lambda ()
            (highlight-lines-matching-regexp "\.org$" 'hi-yellow)))

(add-hook 'dired-mode-hook
          (lambda ()
            (highlight-lines-matching-regexp "\.tex$" 'hi-green)))




;;; 以下为子龙山人的部分配置

(put 'dired-find-alternate-file 'disabled nil)

;; 主动加载 Dired Mode
;; (require 'dired)
;; (defined-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)

;; 延迟加载
(with-eval-after-load 'dired
                      (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))

;; 使当一个窗口（frame）中存在两个分屏（window）时，将另一个分屏自动设置成拷贝地址的目标
(setq dired-dwin-target t)

(provide 'init-dired)
