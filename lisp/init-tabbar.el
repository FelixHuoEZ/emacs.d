;;-----------init-tabbar.el------set tabbar and tabbar group-----------
;;https://github.com/cedricporter/vim-emacs-setting/blob/master/emacs/.emacs.d/configs/my-tabbar.el
;;http://www.emacswiki.org/emacs/TabBarMode
;;------------------------------------------------------------------

;;For the author, this only works if tabbar-mode is set on tob of this block and the when stuff is removed:
;;(require 'tabbar)

(use-package tabbar
  :ensure t
  :config
  (tabbar-mode t)
  ;;Speed up by not using images
  ;;(setq tabbar-use-images nil)
  ;;set group strategy
  (defun tabbar-buffer-groups ()
    "tabbar group"
    (list
     (cond
      ((memq major-mode'(shell-mode sh-mode))
       "shell"
       )
      ((memq major-mode'(c-mode c++-mode))
       "cc"
       )
      ((memq major-mode'(dired-mode ibuffer-mode))
       "files"
       )
      ((eq major-mode 'python-mode)
       "python"
       )
      ((eq major-mode 'ruby-mode)
       "ruby"
       )
      ((memq major-mode
             '(php-mode nxml-mode nxhtml-mode))
       "WebDev"
       )
      ((eq major-mode 'emacs-lisp-mode)
       "Emacs-lisp"
       )
      ((memq major-mode
             '(tex-mode latex-mode text-mode snippet-mode org-mode moinmoin-mode markdown-mode))
       "Text"
       )
      ((string-equal "*" (substring (buffer-name) 0 1))
       "emacs"
       )
      (t
       "other"
       )
      )))
  (setq tabbar-buffer-groups-function 'tabbar-buffer-groups)

  ;; ;;Set group by major mode
  ;; (defun tabbar-buffer-groups ()
  ;;   "Return the list of group names the current buffer belongs to.
  ;;    Return a list of one element based on major mode."
  ;;   (list
  ;;    (cond
  ;;     ((or (get-buffer-process (current-buffer))
  ;;          ;; Check if the major mode derives from `comint-mode' or
  ;;          ;; `compilation-mode'.
  ;;          (tabbar-buffer-mode-derived-p
  ;;           major-mode '(comint-mode compilation-mode)))
  ;;      "Process"
  ;;      )
  ;;     ;; ((member (buffer-name)
  ;;     ;;          '("*scratch*" "*Messages*" "*Help*"))
  ;;     ;;  "Common"
  ;;     ;;  )
  ;;     ((string-equal "*" (substring (buffer-name) 0 1))
  ;;      "Common"
  ;;      )
  ;;     ((member (buffer-name)
  ;;              '("xyz" "day" "m3" "abi" "for" "nws" "eng" "f_g" "tim" "tmp"))
  ;;      "Main"
  ;;      )
  ;;     ((eq major-mode 'dired-mode)
  ;;      "Dired"
  ;;      )
  ;;     ((memq major-mode
  ;;            '(help-mode apropos-mode Info-mode Man-mode))
  ;;      "Common"
  ;;      )
  ;;     ((memq major-mode
  ;;            '(rmail-mode
  ;;              rmail-edit-mode vm-summary-mode vm-mode mail-mode
  ;;              mh-letter-mode mh-show-mode mh-folder-mode
  ;;              gnus-summary-mode message-mode gnus-group-mode
  ;;              gnus-article-mode score-mode gnus-browse-killed-mode))
  ;;      "Mail"
  ;;      )
  ;;     (t
  ;;      ;; Return `mode-name' if not blank, `major-mode' otherwise.
  ;;      (if (and (stringp mode-name)
  ;;               ;; Take care of preserving the match-data because this
  ;;               ;; function is called when updating the header line.
  ;;               (save-match-data (string-match "[^ ]" mode-name)))
  ;;          mode-name
  ;;        (symbol-name major-mode))
  ;;      ))))
  ;; (setq tabbar-buffer-groups-function 'tabbar-buffer-groups)


  ;; Add a buffer modification state indicator in the tab label, and place a
  ;; space around the label to make it looks less crowd.
  (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
    (setq ad-return-value
          (if (and (buffer-modified-p (tabbar-tab-value tab))
                   (buffer-file-name (tabbar-tab-value tab)))
              (concat " + " (concat ad-return-value " "))
            (concat " " (concat ad-return-value " ")))))

  ;; Called each time the modification state of the buffer changed.
  (defun ztl-modification-state-change ()
    (tabbar-set-template tabbar-current-tabset nil)
    (tabbar-display-update))

  ;; First-change-hook is called BEFORE the change is made.
  (defun ztl-on-buffer-modification ()
    (set-buffer-modified-p t)
    (ztl-modification-state-change))
  ;;(add-hook 'after-save-hook 'ztl-modification-state-change)

  ;; This doesn't work for revert, I don't know.
  ;; (add-hook 'after-revert-hook 'ztl-modification-state-change)
  (add-hook 'first-change-hook 'ztl-on-buffer-modification)


  ;; ;;-----------设置tabbar外观---------------------
  ;; ;; 设置默认主题: 字体, 背景和前景颜色，大小
  ;; (set-face-attribute 'tabbar-default nil
  ;;                     :family "Comic Sans MS" ;"Vera Sans YuanTi Mono"
  ;;                     :background "gray30"
  ;;                     :foreground "#dcdccc"
  ;;                     :height 1.0
  ;;                     )

  ;; ;; 设置左边按钮外观：外框框边大小和颜色
  ;; (set-face-attribute 'tabbar-button nil
  ;;                     :inherit 'tabbar-default
  ;;                     :box '(:line-width 2 :color "gray30")
  ;;                     )
  ;; (set-face-attribute 'tabbar-separator nil
  ;;                     :inherit 'tabbar-default
  ;;                     :foreground "blue"
  ;;                     :background "dark gray"
  ;;                     :box '(:line-width 2 :color "dark gray" :style 'released-button)
  ;;                     )
  ;; ;(setq tabbar-separator-value "§")
  ;; (setq tabbar-separator (list 0.5))
  ;; ;; 设置当前tab外观：颜色，字体，外框大小和颜色
  ;; (set-face-attribute 'tabbar-selected nil
  ;;                     :inherit 'tabbar-default
  ;;                     :foreground "orange" ;"DarkGreen"
  ;;                     :background "dark magenta" ;"LightGoldenrod"
  ;;                     :box '(:line-width 2
  ;;                                        :color "DarkGoldenrod"
  ;;                                        :style 'pressed-button)
  ;;                     :weight 'bold
  ;;                     )
  ;; ;; 设置非当前tab外观：外框大小和颜色
  ;; (set-face-attribute 'tabbar-unselected nil
  ;;                     :inherit 'tabbar-default
  ;;                     :box '(:line-width 2 :color "dark gray" :style 'released-button))


  :bind
  (
   ;;Tab navigation key binding
   ("C-S-<tab>" . tabbar-backward-tab)
   ("C-<tab>" . tabbar-forward-tab)
   ;;Tab group navigation key bindings
   ("C-M-j" . tabbar-backward-group)
   ("C-M-k" . tabbar-forward-group)
   )
  )



(provide 'init-tabbar)

;;; init-tabbar.el ends here

