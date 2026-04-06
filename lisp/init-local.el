;;------------------User Defined-----------------------------------------------
;;-----------------------------------------------------------------------------
;;-----------------------------------------------------------------------------
(require 'cl-lib)

(add-hook 'org-mode-hook
          (lambda ()
            (set (make-local-variable 'system-time-locale) "C")))
(set-locale-environment "ENU")


;;; some tips
;; C-x [ and C-x ] to forward-page or backward-page


;;; pieces of useful settings

(setq debug-on-error t)
;;Turn on abbrev mode
(load (expand-file-name "lisp/emacs_abbrev.el" user-emacs-directory))
;;(load "~/.emacs.d/my_emacs_abbrev")
(global-set-key (kbd "C-h C-f") 'find-function)
(setq desktop-restore-frames t)
(unless noninteractive
  (desktop-save-mode nil))
(setq-default cursor-type '(bar . 4))
;; (set-cursor-color "#ffffff")
;; (delete-selection-mode t)
(global-hl-line-mode t)
;; (setq next-line-add-newlines t)
;; (set-fill-column 80)
(scroll-bar-mode t)
(add-hook 'org-mode-hook 'visual-line-mode)
(global-auto-revert-mode t)
(setq auto-save-default nil)
;; 每一次当 Emacs 需要与你确认某个命令时需要输入 (yes or no) 比较麻烦，所有我们可以使用下面的代码，设置一个别名将其简化为只输入 (y or n)
(fset 'yes-or-no-p 'y-or-n-p)
(with-eval-after-load 'org
  (setf org-file-apps
        (remove '("\\.pdf\\'" . default) org-file-apps))
  (add-to-list 'org-file-apps '("\\.pdf\\'" . "xdg-open \"%s\""))
  (add-to-list 'org-file-apps '("\.pdf::\(\d+\)\'" . "xdg-open \"-page %1 %s\""))
  (add-to-list 'org-file-apps '("\\.html\\'" . "xdg-open \"%s\""))
  (add-to-list 'org-file-apps '("\\.htm\\'" . "xdg-open \"%s\"")))
;; (add-to-list 'org-file-apps '("\\.pdf\\'" . "sumatrapdf %s"))
;; (add-to-list 'org-file-apps '("\.pdf::\(\d+\)\'" . "sumatrapdf -page %1 %s"))

;;; Chinese fonts setup

;; (add-to-list 'load-path "~/.emacs.d/elpa/chinese-fonts-setup-20160419.2159/")
;; (add-to-list 'load-path "~/.emacs.d/elpa/chinese-fonts-setup/")

;; (require-package 'chinese-fonts-setup)
;; (require 'chinese-fonts-setup)
;;(use-package chinese-fonts-setup
;; :demand t
;; :init
;; (setq cfs-verbose nil)
;;
;; :config
;; ;; (cl-prettyprint (font-family-list))
;; ;; (print (font-family-list))
;;
;; ;; (cl-remove-if #'(lambda (font)
;; ;; (not (string-match-p "\\cc" font)))
;; ;; (font-family-list))
;;
;; (setq cfs-personal-fontnames
;; '(
;; ()
;; ("方正书宋简体" "方正字迹-典雅楷体简体" "方正宋刻本秀楷简体" "方正正纤黑简体" "方正清刻本悦宋简体" "方正苏新诗柳楷简体" "冬青黑体简体中文 W3" "冬青黑体简体中文 W6" "文泉驿微米黑" "思源黑体 Regular" "思源黑体 Normal" "思源黑体 Medium" "思源黑体 Light" "思源黑体 Heavy" "思源黑体 ExtraLight" "思源黑体 Bold" "冬青黑体" "思源黑体" "方正兰亭准黑_GBK" "方正兰亭黑_GBK" "方正兰亭纤黑_GBK" "Microsoft YaHei UI")
;; ()
;; ))
;;
;; (setq cfs-profiles
;; '("program" "org-mode" "read-book"))
;; (chinese-fonts-setup-enable)
;; :bind
;; (("C--" . cfs-decrease-fontsize)
;; ("C-=" . cfs-increase-fontsize)
;; ("C-+" . cfs-next-profile)))

(use-package cnfonts
  :demand t
  :init
  (setq cnfonts-verbose nil)
  :config
  ;; (cl-prettyprint (font-family-list))
  ;; (print (font-family-list))

  ;; (cl-remove-if #'(lambda (font)
  ;; (not (string-match-p "\\cc" font)))
  ;; (font-family-list))

  (setq cnfonts-use-system-type t)
  (setq cnfonts-personal-fontnames
        '(
          ()
          ("方正书宋简体" "方正字迹-典雅楷体简体" "方正宋刻本秀楷简体" "方正正纤黑简体" "方正清刻本悦宋简体" "方正苏新诗柳楷简体" "冬青黑体简体中文 W3" "冬青黑体简体中文 W6" "文泉驿微米黑" "思源黑体 Regular" "思源黑体 Normal" "思源黑体 Medium" "思源黑体 Light" "思源黑体 Heavy" "思源黑体 ExtraLight" "思源黑体 Bold" "冬青黑体" "思源黑体" "方正兰亭准黑_GBK" "方正兰亭黑_GBK" "方正兰亭纤黑_GBK" "Microsoft YaHei UI")
          ()
          ))

  (setq cnfonts-profiles
        '("default" "program" "org-mode" "read-book"))
  (cnfonts-enable)

  ;; (setq cnfonts-use-face-font-rescale t) ;cannot be used in Windows

  (defun my-set-symbol-fonts (fontsizes-list)
    (let* ((fontname "NotoColorEmoji")
           (fontsize (nth 0 fontsizes-list))
           (fontspec (font-spec :name fontname
                                :size fontsize
                                :weight 'normal
                                :slant 'normal)))
      (if (cnfonts--fontspec-valid-p fontspec)
          (set-fontset-font "fontset-default" 'symbol fontspec nil 'append)
        (message "字体 %S 不存在！" fontname))))


  (defun my-set-exta-fonts (fontsizes-list)
    (let* ((fontname "Microsoft YaHei UI")
           (fontsize (nth 1 fontsizes-list))
           (fontspec (font-spec :name fontname
                                :size fontsize
                                :weight 'normal
                                :slant 'normal)))
      (if (cnfonts--fontspec-valid-p fontspec)
          (set-fontset-font "fontset-default" '(#x3400 . #x4DFF) fontspec nil 'append)
        (message "字体 %S 不存在！" fontname))))

  (add-hook 'cnfonts-set-font-finish-hook 'my-set-symbol-fonts)
  (add-hook 'cnfonts-set-font-finish-hook 'my-set-exta-fonts)


  (defvar my-line-spacing-alist
    '((9 . 0.1) (10 . 0.9) (11.5 . 0.2)
      (12.5 . 0.2) (14 . 0.2) (16 . 0.2)
      (18 . 0.2) (20 . 1.0) (22 . 0.2)
      (24 . 0.2) (26 . 0.2) (28 . 0.2)
      (30 . 0.2) (32 . 0.2)))

  (defun my-line-spacing-setup (fontsizes-list)
    (let ((fontsize (car fontsizes-list))
          (line-spacing-alist (copy-list my-line-spacing-alist)))
      (dolist (list line-spacing-alist)
        (when (= fontsize (car list))
          (setq line-spacing-alist nil)
          (setq-default line-spacing (cdr list))))))

  (add-hook 'cnfonts-set-font-finish-hook #'my-line-spacing-setup)

  :bind
  (("C--" . cnfonts-decrease-fontsize)
   ("C-=" . cnfonts-increase-fontsize)
   ("C-+" . cnfonts-next-profile))
  )


(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

  (defun my-web-mode-hook ()
    "Hooks for Web mode."
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    )
  (add-hook 'web-mode-hook 'my-web-mode-hook)
  )


;;; fix youdao-dictionary invalid date error

(defun url-cookie-expired-p (cookie)
  "Return non-nil if COOKIE is expired."
  (let ((exp (url-cookie-expires cookie)))
    (and (> (length exp) 0)
         (condition-case ()
             (> (float-time) (float-time (date-to-time exp)))
           (error nil)))))
;; https://github.com/xuchunyang/youdao-dictionary.el/issues/1#issuecomment-71359418


;;; extended indent-buffer

(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indent selected region."))
      (progn
        (indent-buffer)
        (message "Indent buffer.")))))

(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)


;; try
(use-package try)


;; smartparens-mode
(use-package smartparens
  :config
  (smartparens-global-mode t)
  )


;;; lispy(abo-abo)
;; lispy 的 comment 在第一次加载时不起作用，其他命令正常
;; lispy 的 M-j 与 chinese-pyim 的函数冲突，已经将 lispy 的 lispy-split 命令绑定为 U
(use-package lispy
  :commands (lispy-comment)
  :config
  ;; (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
  ;; enbale lispy-mode in minibuffer
  (defun conditionally-enable-lispy ()
    (when (eq this-command 'eval-expression)
      (lispy-mode 1)
      (local-set-key "β" 'helm-lisp-completion-at-point)))
  (add-hook 'minibuffer-setup-hook 'conditionally-enable-lispy)
  (define-key lispy-mode-map (kbd "M-j") nil)
  (lispy-define-key lispy-mode-map "U" 'lispy-split)
  ;; (lispy-define-key lispy-mode-map ";" 'lispy-comment)

;;;; change keybindings
  ;; (eval-after-load "lispy"
  ;; `(progn
  ;; ;; replace a global binding with own function
  ;; (define-key lispy-mode-map (kbd "C-e") 'my-custom-eol)
  ;; ;; replace a global binding with major-mode's default
  ;; (define-key lispy-mode-map (kbd "C-j") nil)
  ;; ;; replace a local binding
  ;; (lispy-define-key lispy-mode-map "s" 'lispy-down)))

  ;; http://oremacs.com/lispy/
  ;; https://github.com/abo-abo/lispy
  )
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))

;; org-insert-dir
(defun hsk/org-insert-dir-from-top-level-id-logseq ()
  (interactive)
  (setq m1_temp (make-marker))
  (set-marker m1_temp 0)
  (org-set-property "DIR" (concat logseq-assets-directory-prefix "/" (org-id-get-create m1_temp)))
  (set-marker m1_temp nil))
(defun hsk/org-insert-dir-from-id-logseq ()
  (interactive)
  (org-set-property "DIR" (concat logseq-assets-directory-prefix "/" (org-id-get-create))))

;;; org-download(abo-abo)
(use-package org-download
  :bind
  (:prefix "C-c y"
           :prefix-map yank-image-map
           ("y" . yank-image-from-win-clipboard-through-powershell)
           ("u" . yank-image-from-win-clipboard-only-link))
  :config
  ;; (setq org-download-backend 'wget)
  (setq org-download-backend "wget")
  (setq org-download-annotate-function 'ignore)
  ;; Drag-and-drop to `dired`
  (add-hook 'dired-mode-hook 'org-download-enable)
  ;;image cut settings
  (define-prefix-command 'yank-image-map)
  (defun yank-image-from-win-clipboard-through-powershell()
    "to simplify the logic, use c:/Users/Public as temporary directoy, and move it into current directoy,
     save image to file-dir, copy path of image, insert link with yasnippet"
    (interactive)
    (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
           (file-dir (concat "./" (org-attach-dir-get-create) "/") )
           ;; (file-dir "./images/")
           (file-name (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))
           ;; (file-path-powershell (concat "c:/Users/\$env:USERNAME/" file-name))
           (file-path-wsl (concat file-dir file-name))
           )
      (unless (file-exists-p file-dir)
        (make-directory file-dir))
      ;; (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/\\$env:USERNAME/" file-name "\\\")\""))
      (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/Public/Pictures/" file-name "\\\")\""))
      (rename-file (concat "/mnt/c/Users/Public/Pictures/" file-name) file-path-wsl)
      (yas/insert-by-name "newfigure")
      ;; (insert (concat "#+ATTR_LATEX: :width 0.5\\textwidth\n"))
      ;; (org-indent-line)
      ;; (insert (concat "[[file:" file-path-wsl "]] "))
      (insert file-path-wsl)
      ))
  (defun yank-image-from-win-clipboard-only-link ()
    "save image to file-dir, copy path of image, insert raw link"
    (interactive)
    (let* ((powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
           (file-dir (concat "./" (org-attach-dir-get-create) "/") )
           ;; (file-dir "./images/")
           (file-name (format-time-string "screenshot_%Y%m%d_%H%M%S.png"))
           ;; (file-path-powershell (concat "c:/Users/\$env:USERNAME/" file-name))
           (file-path-wsl (concat file-dir file-name))
           )
      (unless (file-exists-p file-dir)
        (make-directory file-dir))
      ;; (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/\\$env:USERNAME/" file-name "\\\")\""))
      (shell-command (concat powershell " -command \"(Get-Clipboard -Format Image).Save(\\\"C:/Users/Public/Pictures/" file-name "\\\")\""))
      (rename-file (concat "/mnt/c/Users/Public/Pictures/" file-name) file-path-wsl)
      ;; (yas/insert-by-name "newfigure")
      ;; (insert (concat "#+ATTR_LATEX: :width 0.5\\textwidth\n"))
      ;; (org-indent-line)
      ;; (insert (concat "[[file:" file-path-wsl "]] "))
      (insert file-path-wsl)
      )
    ))


(use-package org-attach-screenshot
  :commands (org-attach-screenshot)
  :init
  ;; (setq org-attach-screenshot-command-line "mycommand -x -y -z %f")
  (setq org-attach-screenshot-dirfunction
        (lambda ()
          (progn (cl-assert (buffer-file-name))
                 (concat (file-name-sans-extension (buffer-file-name))
                         "_att"))))
  (setq org-attach-screenshot-relative-links t))


(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (buffer-file-name))
                  "_imgs/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
                                        ; take screenshot
  (if (eq system-type 'darwin)
      (progn
        (call-process-shell-command "screencapture" nil nil nil nil " -s " (concat
                                                                            "\"" filename "\"" ))
        (call-process-shell-command "convert" nil nil nil nil (concat "\"" filename "\" -resize \"50%\"" ) (concat "\"" filename "\"" ))
        ))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
  (if (file-exists-p filename)
      (insert (concat "[[file:" filename "]]")))
  (org-display-inline-images)
  )

(global-set-key (kbd "C-c s c") 'my-org-screenshot)


;;; ace-link(abo-abo)
(use-package ace-link
  :config
  (ace-link-setup-default)
  (with-eval-after-load 'org
    (define-key org-mode-map (kbd "M-o") 'ace-link-org))
  ;; (define-key gnus-summary-mode-map (kbd "M-o") 'ace-link-gnus)
  ;; (define-key gnus-article-mode-map (kbd "M-o") 'ace-link-gnus)
  ;; (global-set-key (kbd "M-o") 'ace-link-addr)
  )


(use-package habitica
  :config
  (setq habitica-uid "REDACTED-HABITICA-UID")
  (setq habitica-token "REDACTED-HABITICA-TOKEN")
  ;; If you want to try highlighting tasks based on their value, This is very experimental.
  ;; (setq habitica-turn-on-highlighting t)
  ;; If you want the streak count to appear as a tag for your daily tasks
  (setq habitica-show-streak t)
  )


;; (use-package ox-anki
;; :config
;; )


;;; tiny(abo-abo)
(use-package tiny
  :config
  (tiny-setup-default))


;;; popwin

(use-package popwin
  :config
  (popwin-mode t)
  )



;;; ag

(use-package ag
  :if (executable-find "ag")
  :bind (("M-?" . ag-project))
  :init
  (setq-default grep-highlight-matches t
                grep-scroll-output t)

  (when *is-a-mac*
    (setq-default locate-command "mdfind"))
  :config
  (require 'wgrep-ag nil t))


;;; hungry-delete

(use-package hungry-delete
  :config
  (global-hungry-delete-mode)
  )



;;Set nodejs-repl
(use-package nodejs-repl
  :defer t)


;;; swiper

(use-package swiper
  ;; :disabled t
  :config
  (use-package counsel)
  (use-package counsel-projectile
    :config
    (counsel-projectile-mode))
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)

  ;; 让`ivy-read'支持拼音
  ;; [[https://emacs-china.org/t/ivy-read/2432][使ivy-read支持拼音搜索 - Emacs-general - Emacs China]]
  (use-package pinyinlib)

  (defun re-builder-pinyin (str)
    (or (pinyin-to-utf8 str)
        (ivy--regex-plus str)
        (ivy--regex-ignore-order)
        ))

  (setq ivy-re-builders-alist
        '(
          (t . re-builder-pinyin)
          ))

  (defun my-pinyinlib-build-regexp-string (str)
    (progn
      (cond ((equal str ".*")
             ".*")
            (t
             (pinyinlib-build-regexp-string str t))))
    )
  (defun my-pinyin-regexp-helper (str)
    (cond ((equal str " ")
           ".*")
          ((equal str "")
           nil)
          (t
           str)))

  (defun pinyin-to-utf8 (str)
    (cond ((equal 0 (length str))
           nil)
          ((equal (substring str 0 1) "!")
           (mapconcat 'my-pinyinlib-build-regexp-string
                      (remove nil (mapcar 'my-pinyin-regexp-helper (split-string
                                                                    (replace-in-string str "!" "") "")))
                      ""))
          nil))

  ;; ;; ;;; 这样就可以去掉`pinyin'区配
  ;; (defun pinyin-to-utf8 (str)
  ;; nil)
  ;; 以上部分用来让`ivy-read'支持拼音
  :bind
  (("C-s" . swiper)
   ("C-c C-r" . ivy-resume)
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("C-c g h" . counsel-git)
   ("C-c j" . counsel-git-grep)
   ("C-c k" . counsel-ag)
   ("C-c l" . counsel-locate)
   ("C-S-o" . counsel-rhythmbox)
   ;; (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
   )
  )


(use-package helm
  :bind ("M-y" . helm-show-kill-ring))


;; (setq url-proxy-services '(("http" . "localhost:1080")
;; ("https" . "localhost:1080")))



;;; server mode(Allow access from emacsclient)

;; (use-package server
;; ;; :config
;; (unless (server-running-p)
;; ;; (setq server-auth-dir "d:\\emacs\\.emacs.d\\server\\")
;; (cond
;; ((eq system-type 'windows-nt)
;; (setq server-auth-dir "~\\.emacs.d\\server\\"))
;; ((eq system-type 'gnu/linux)
;; (setq server-auth-dir "~/.emacs.d/server/")))
;; (setq server-name "emacs-server-file")
;; (server-start)))


;;; edit-server: start edit server for chromebrowser(port:9292)

;; (use-package edit-server
;; :config
;; (setq edit-server-new-frame nil)
;; (edit-server-start)
;; )


;;; Set coding system for Chinese fonts
(require 'init-coding)
;; (set-language-environment "UTF-8")
;; (set-buffer-file-coding-system 'utf-8-unix)
;; (set-clipboard-coding-system 'utf-8-unix)
;; (set-file-name-coding-system 'utf-8-unix)
;; (set-keyboard-coding-system 'utf-8-unix)
;; (set-next-selection-coding-system 'utf-8-unix)
;; (set-selection-coding-system 'utf-8-unix)
;; (set-terminal-coding-system 'utf-8-unix)

;; (when (eq system-type 'windows-nt)
;; (set-selection-coding-system 'gbk-dos)
;; (set-next-selection-coding-system 'gbk-dos)
;; (set-clipboard-coding-system 'gbk-dos))


;;-----------------------------------------------
;;ido-mode
;;-----------------------------------------------
(ido-mode t)
(setq gc-cons-threshold 20000000)


;;; flx-ido
(use-package flx-ido
  :config
  (ido-mode 1)
  (ido-everywhere 1)
  (flx-ido-mode 1)
  ;; disable ido faces to see flx highlights.
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil)
  )

;;; tabbar-ruler

;;(require 'init-tabbar)
(use-package tabbar
  :config
  (tab-bar-mode t)
  ;;Speed up by not using images
  ;;(setq tabbar-use-images nil)
  :bind
  (
   ;;Tab navigation key binding
   ("C-S-<tab>" . tabbar-backward-tab)
   ("C-<tab>" . tabbar-forward-tab)
   ;;Tab group navigation key bindings
   ("C-M-j" . tabbar-backward-group)
   ("C-M-k" . tabbar-forward-group)))

(use-package tabbar-ruler
  :disabled t
  :config
  (setq tabbar-ruler-global-tabbar t) ; If you want tabbar
  ;; (setq tabbar-ruler-global-ruler nil) ; if you want a global ruler
  ;; (setq tabbar-ruler-popup-menu nil) ; If you want a popup menu.
  ;; (setq tabbar-ruler-popup-toolbar nil) ; If you want a popup toolbar
  ;; (setq tabbar-ruler-popup-scrollbar t) ;show scroll-bar on mouse-move
  ;; (tabbar-ruler-group-by-projectile-project)
  (tabbar-ruler-group-buffer-groups)
  ;; (tabbar-mode)
  ;; (global-set-key (kbd "C-c t") 'tabbar-ruler-move)
  )


;;------------------------------------------------
;; Load config files of user installed package
;;------------------------------------------------
(require 'init-auctex)
;; (require 'init-helm)
;; (require 'ahk-mode)
;; (require 'init-tabbar)
;; (require 'init-fontsset)
;; (require 'unicad)




;;------------------------------------------------
;;Switch window(sign number for each window)(unistalled at 2015-11-22)
;;------------------------------------------------
;;(require 'switch-window)
;;(global-set-key (kbd "C-x o") 'switch-window)



;;------------------------------------------------
;;Modify the set mark key from C-@/C-Space to M-Space
;;------------------------------------------------
(global-unset-key (kbd "C-SPC"))
(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-unset-key (kbd "C-z"))
;; (global-set-key (kbd "C-z") 'undo-tree-undo)
;; (global-set-key (kbd "C-S-z") 'undo-tree-redo)


;;------------------------------------------------
;;Enable line numbers in left sidebar
;;------------------------------------------------
;; (require-package 'linum)
;; (autoload
;; 'linum
;; "linum-mode"
;; "Emacs linum minor mode"
;; t)
;; (autoload
;; 'linum
;; "global-linum-mode"
;; "Emacs linum minor mode"
;; t)
;; (global-linum-mode -1)

;;------------------------------------------------
;;Go to char(Use hot key to move last or next certain letter)
;;------------------------------------------------
;; (defun my-go-to-char (n char)
;; "Move forward to Nth occurence of CHAR.
;; Typing `my-go-to-char-key' again will move forwad to the next Nth
;; occurence of CHAR."
;; (interactive "p\ncGo to char: ")
;; (let ((case-fold-search nil))
;; (if (eq n 1)
;; (progn ; forward
;; (search-forward (string char) nil nil n)
;; (backward-char)
;; (while (equal (read-key)
;; char)
;; (forward-char)
;; (search-forward (string char) nil nil n)
;; (backward-char)))
;; (progn ; backward
;; (search-backward (string char) nil nil )
;; (while (equal (read-key)
;; char)
;; (search-backward (string char) nil nil )))))
;; (setq unread-command-events (list last-input-event)))
;; (global-set-key (kbd "C-t") 'my-go-to-char)


;;; Window numbering(Numbered window shortcuts for Emacs)
(use-package window-numbering
  :config
  (window-numbering-mode t)
  ;; (setq window-numbering-assign-func
  ;; (lambda () (when (equal (buffer-name) "*Calculator*") 9))
  )



;;; expand-region
(use-package expand-region
  :config
  ;; Don't use expand-region fast keys
  (setq expand-region-fast-keys-enabled nil)
  ;; Show expand-region command used
  (setq er--show-expansion-message t)
  (global-set-key (kbd "M-m") 'er/expand-region)
  ;;Also enable mark-paragraph and mark-page
  (defun er/add-text-mode-expansions ()
    (make-variable-buffer-local 'er/try-expand-list)
    (setq er/try-expand-list (append
                              er/try-expand-list
                              '(mark-paragraph
                                mark-page))))
  (add-hook 'text-mode-hook 'er/add-text-mode-expansions)
  )


;;; magit
(use-package magit
  :config
  (setenv "SSH_ASKPASS" "git-gui--askpass")
  ;; (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
  :bind (
         ("C-x g" . magit-status))
  )



;; screenshot
;; 使用 irfanview 的命令行截图，并保存到指定文件夹，再使用 picpick 或 faststone 修改
;; 若使用全局参数 C-u 截图之后会调用 picpick 编辑图片
;; TODO: 截图之前交互式地选择一个 buffer 来作为 current org file，那样就不限于在 org 文件的当前 buffer 截图了
;; TODO: 带参数来决定 irfanview 的 option，可以使用带参数的C-u 来实现，但是与已实现的带参数来调用 picpick 的功能冲突
(defun org-img-capture (arg)
  "Take a screenshot into a unique-named file in the current buffer file
directory and insert a link to this file.
[[http://www.jianshu.com/p/77841e0aba46][emacs的工作环境设置 - 简书]]
[[https://emacs-china.org/t/org-mode-windows-7/2161/9][Org-mode截图与显示图片（Windows 7） - Org-mode - Emacs China]]
"
  (interactive "P")
  (let ((file-directory (file-name-directory buffer-file-name)))
    (make-directory (concat file-directory "img/") t)
    (let* ((file-fullname
            (concat file-directory "img/img_" (format-time-string "%Y%m%d_%H%M%S") ".png")) ;; (concat file-directory (make-temp-name (concat file-directory "img/img-")) ".png")
           (file-name (file-name-nondirectory file-fullname)))
      ;; irfanview cature options
      ;; 0 = whole screen
      ;; 1 = current monitor, where mouse is located
      ;; 2 = foreground window
      ;; 3 = foreground window - client area
      ;; 4 = rectangle selection
      ;; 5 = object selected with the mouse
      ;; 6 = start in capture mode (can't be combined with other commandline options)
      ;; 7 = fixed rectangle (using capture dialog values or direct input)
      (shell-command (concat "i_view64 /capture=4 /convert=" (format "\"%s\"" file-fullname)))
      (insert (concat "[[./img/" file-name "]]"))
      (if arg (shell-command (format "picpick \"%s\"" file-fullname))))))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c r") 'org-img-capture))


;; merriam-webster dictionary
;; 使用 eww 直接打开网页，不够人性化
;; 希望可以做成有道那样，不知道 wesbter 有没有提供 API
;; todo
(defvar webster-url "http://www.m-w.com/cgi-bin/dictionary?book=Dictionary&va=")

(defun merriam (word)
  (interactive "slook up a word in merriam-webster: ")
  (let (start (point))
    ;;
    (cond ((string= (format "%s" (current-buffer)) "*eww*")
           (eww-browse-url (concat webster-url word)))
          ;;
          ((bufferp (get-buffer "*eww*"))
           (progn (view-buffer-other-window (get-buffer "*eww*"))
                  (eww-browse-url (concat webster-url word))))
          ;;
          (t
           (progn (view-buffer-other-window (get-buffer "*scratch*"))
                  (eww-browse-url (concat webster-url word)))))))

(global-set-key (kbd "<f5>") 'merriam)


;;; define-word (E2E dictionary, abo-abo)
(use-package define-word
  ;; :disabled t
  :bind (
         ;; ("C-c C-y" . define-word-at-point)
         ("C-c C-y" . define-word))
  )


;;; youdao-dictionary
(use-package youdao-dictionary
  :config
  ;; Enable Cache
  (setq url-automatic-caching t)

  ;; Integrate with popwin-el (https://github.com/m2ym/popwin-el)
  ;; (push "*Youdao Dictionary*" popwin:special-display-config)

  ;; Set file path for saving search history
  ;; (setq youdao-dictionary-search-history-file "~/.emacs.d/.youdao")

  ;; Enable Chinese word segmentation support
  ;; (setq youdao-dictionary-use-chinese-word-segmentation t)

  :bind (
         ;; Example Key binding
         ("C-c u" . youdao-dictionary-search-at-point))
  )



;;; chinese-pyim
(use-package pyim
  ;; :load-path "elpa-24.5/chinese-pyim"
  ;; :defer nil
  ;; :demand t ; if set demand, pyim will not automatically switched sometimes especially in org-mode,
                                        ; if not set, when first use pyim, there will be a delay to load the package
  ;; :disabled t
  ;; :init
  ;; (add-hook 'after-init-hook
  ;; #'(lambda () (pyim-restart-1 t)))
  :config
  ;; 基本快捷键列表
  ;; C-n/M-n/+ 向下翻页， C-p/M-p/- 向上翻页， C-f 选择下一个备选词，C-b 选择上一个备选词
  ;; SPC 确定输入，RET/C-m 字母上屏， C-c 取消输入， C-g 取消输入并保留已输入的中文， TAB 模糊音调整
  (setq default-input-method "pyim")
  ;; (setq default-input-method nil)
  (setq pyim-default-scheme 'quanpin)
  (global-set-key (kbd "C-\\") 'toggle-input-method)

  ;; (setq pyim-enable-words-predict '(dabbrev pinyin-similar pinyin-znabc))
  ;; (setq pyim-enable-words-predict nil)
  (require 'pyim-dregcache)
  (require 'pyim-cregexp-utils)
  (require 'pyim-cstring-utils)

  (setq pyim-backends '(dcache-personal dcache-common pinyin-chars pinyin-shortcode pinyin-znabc))
  ;; (setq pyim-backends '(dcache-personal dcache-common pinyin-chars))
  ;; (setq pyim-backends '(dcache-common))

  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  (use-package pyim-basedict
    ;; :disabled t
    :config
    (pyim-basedict-enable))

  (setq pyim-dicts
        '(
          ;; (:name "bigdict" :file "~/.emacs.d/pyim/dicts/pyim-bigdict.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ;; (:name "guessdict" :file "~/.emacs.d/pyim/dicts/pyim-guessdict.gpyim" :coding utf-8-unix :dict-type guess-dict)
          ;; (:name "sogou-dic-utf8" :file "~/.emacs.d/pyim/dicts/sogou-dic-utf8.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ;; (:name "sogoucell" :file "~/.emacs.d/pyim/dicts/SogouCellWordLib.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ;; (:name "millions" :file "~/.emacs.d/pyim/dicts/millions.pyim" :coding utf-8-unix :dict-type pinyin-dict)

          (:name "Useful" :file "~/.emacs.d/pyim/dicts/Useful.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "words" :file "~/.emacs.d/pyim/dicts/words.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "Daily" :file "~/.emacs.d/pyim/dicts/Daily.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "Electronics" :file "~/.emacs.d/pyim/dicts/Electronics.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "CS" :file "~/.emacs.d/pyim/dicts/CS.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "Math-Physics" :file "~/.emacs.d/pyim/dicts/Math-Physics.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ))

  ;; Enable searching with pinyin
  (setq pyim-isearch-enable-pinyin-search t)
  ;; (setq pyim-guidance-format-function 'pyim-guidance-format-function-one-line)
  (setq pyim-page-length 9)
  ;; (setq pyim-page-style 'one-line)
  (setq pyim-page-tooltip nil)
  ;; (setq pyim-page-tooltip 'pos-tip)
  ;; (setq pyim-page-tooltip 'popup)
  ;; (print pyim-dicts)
  ;; (add-hook 'emacs-startup-hook
  ;; #'(lambda () (pyim-restart-1 t)))
  ;; (pyim-restart-1 t)
  ;; (pyim-restart-1)

  ;; 词库导出，后续更新版本需要注释掉
  ;; (defun pyim-personal-dcache-export ()
  ;; "将 pyim-dcache-icode2word 导出为 pyim 词库文件。"
  ;; (interactive)
  ;; (let ((file (read-file-name "将个人缓存中的词条导出到文件：")))
  ;; (with-temp-buffer
  ;; (insert ";;; -*- coding: utf-8-unix -*-\n")
  ;; (maphash
  ;; #'(lambda (key value)
  ;; (insert (concat key " " (mapconcat #'identity value " ") "\n")))
  ;; pyim-dcache-icode2word)
  ;; (write-file file))))

  (use-package pyim-company
    :disabled t
    :ensure nil
    :config
    (setq pyim-company-max-length 6))

  :bind
  (("C-\\" . toggle-input-method)
   ("M-j" . pyim-convert-string-at-point)
   ;; ("C-;" . pyim-delete-word-from-personal-buffer)
   ("C-c h" . pyim-punctuation-translate-at-point)
   ("C-c C-h" . pyim-punctuation-toggle)
   ("M-f" . pyim-forward-word)
   ("M-b" . pyim-backward-word)
   ))


;;;pinyin-search
(use-package pinyin-search
  :bind
  (("C-r" . pinyin-search)))


;; (use-package easy-lentic
;; ;; :config
;; (use-package ox-gfm)
;; (easy-lentic-mode-setup) ; Enable `easy-lentic-mode' for `emacs-lisp-mode' and `org-mode'
;; )


(use-package find-by-pinyin-dired)


;;; Don't delete *scratch* buffer

(defun eh-unkillable-scratch-buffer ()
  (if (string= (buffer-name (current-buffer)) "*scratch*")
      (progn
        (delete-region (point-min) (point-max))
        (insert initial-scratch-message)
        nil)
    t))

(add-hook'kill-buffer-query-functions 'eh-unkillable-scratch-buffer)


;;; eshell

(use-package eshell
  :bind (("C-x c" . eshell))
  :config

  (use-package em-term
    :ensure nil)
  (use-package em-unix
    :ensure nil)

  (setq eshell-visual-commands
        (append '("aptitude" "mutt" "nano" "crontab" "vim" "less")
                eshell-visual-commands))
  (setq eshell-visual-subcommands
        (list (append '("sudo") eshell-visual-commands)
              '("git" "log" "diff" "show")))
  (setq eshell-visual-options
        '(("git" "--help")))

  (defun eh-eshell (&optional arg)
    (interactive)
    ;; 使用 eshell-exec-visual 第一次打开 term 时，
    ;; 不能使用 multi-term 的键盘绑定，原因不知，
    ;; 首先运行一下 less, 从而让 multi-term 的键盘绑定生效。
    (eshell-command "less")
    (eshell arg)))


;;;ahk-mode

(use-package ahk-mode)



;;------------------------------------------------
;;ace-jump-mode(unistalled at 20160408, replaced with avy)
;;------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode-20140616.115/")
;; (autoload
;; 'ace-jump-mode
;; "ace-jump-mode"
;; "Emacs quick move minor mode"
;; t)
;; ;; you can select the key you prefer to
;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;; ;;(global-set-key (kbd "C-c SPC") 'ace-jump-mode)
;; ;; When org-mode starts it (org-mode-map) overrides the ace-jump-mode.
;; (add-hook 'org-mode-hook
;; (lambda ()
;; (local-set-key (kbd "\C-c SPC") 'ace-jump-mode)))
;; ;; enable a more powerful jump back function from ace jump mode
;; (autoload
;; 'ace-jump-mode-pop-mark
;; "ace-jump-mode"
;; "Ace jump back:-)"
;; t)
;; (eval-after-load "ace-jump-mode"
;; '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;;If you use viper mode :
;;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;;If you use evil
;;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)



;;; avy

(use-package avy
  ;; :disabled t
  :config
  (avy-setup-default)
  :bind (
         ("C-:" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g g" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)
         ("M-g e" . avy-goto-word-0)
         )
  )

;; (require-package 'ace-pinyin)
(use-package ace-pinyin
  :config
  ;; (setq ace-pinyin-use-avy nil) ;; uncomment if you want to use `ace-jump-mode'
  (ace-pinyin-global-mode +1))


;;; multiple-cursors
(use-package multiple-cursors
  :config
  ;; ;; [[https://www.zhihu.com/question/27478438/answer/59796810][Emacs 有什么奇技淫巧? - 知乎]]
  ;; Multiple cursors does not do well when you invoke its commands with M-x. It needs to be bound to keys to work properly. Pull request to fix this is welcome.
  ;; (defun cua-or-multicursor ()
  ;; (interactive)
  ;; (if (use-region-p)
  ;; (mc/edit-lines)
  ;; (cua-rectangle-mark-mode)))
  ;; ;; http://emacs.stackexchange.com/a/9916/514
  ;; (eval-after-load "multiple-cursors-core"
  ;; (lambda ()
  ;; (add-to-list 'mc--default-cmds-to-run-once 'cua-or-multicursor)))

  :bind (
         ("C-M-," . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         )
  )


;;; fcitx

;; (if (string-equal system-type "gnu/linux")
;; (progn
;; (require-package 'fcitx)
;; (fcitx-default-setup)
;; (fcitx-isearch-turn-on)
;; ;; The next line should be comment when use OS X
;; (setq fcitx-use-dbus t)) nil)


;;; add gitman

(defun hsk/info-follow-gitman (orig &rest args)
  "Follow `gitman' references with a platform-appropriate man viewer."
  (let ((node (Info-get-token
               (point) "\\*note[ \n\t]+"
               "\\*note[ \n\t]+\\([^:]*\\):\\(:\\|[ \n\t]*(\\)?"))))
    (if (and node (string-match "^(gitman)\\(.+\\)" node))
        (let ((manual (match-string 1 node)))
          (cond
           ((eq system-type 'windows-nt)
            (require 'woman)
            (woman manual))
           ((eq system-type 'gnu/linux)
            (require 'man)
            (man manual))
           (t
            (apply orig args))))
      (apply orig args)))

(with-eval-after-load 'info
  (advice-add 'Info-follow-nearest-node :around #'hsk/info-follow-gitman))


;; TODO: twittering-mode
;; [[https://github.com/hayamiz/twittering-mode][hayamiz/twittering-mode: An Emacs major mode for Twitter]]


;; TODO: org-ioslide
;; Export your Org document to Google I/O HTML5 slide
;; [[https://github.com/coldnew/org-ioslide][coldnew/org-ioslide: Export org-mode to Google I/O HTML5 slide.]]

;; tldr.el
(use-package tldr
  :config
  ;; (tldr-update-docs)
  )


;; kaomoji 颜文字
(use-package kaomoji
  :config
  ;; (setq kaomoji-table
  ;; (append '((("angry" "furious") . "(／‵Д′)／~ ╧╧ ")
  ;; (("angry" "punch") . "#???）?彡☆))?Д?)?∵"))
  ;; kaomoji-table))
  )



;; hexo.el
(use-package hexo
  :commands (hexo)
  :preface
  (defun hexo-hsk-blog ()
    (interactive)
    (hexo "~/blog/")))

;;; blog-admin
(use-package blog-admin
  :defer t
  :init
  (setq blog-admin-backend-path "~/blog")
  (setq blog-admin-backend-type 'hexo)
  (setq blog-admin-backend-new-post-in-drafts t) ;; create new post in drafts by default
  (setq blog-admin-backend-new-post-with-same-name-dir t)) ;; create same-name directory with new post
;; (add-to-list 'load-path "~/.emacs.d/elpa/blog-admin")
;; (require 'blog-admin)
;; When change home directory, use the following line to make soft link which point to the blog directory in the Dropbox sync directory
;; Mklink /j "C:\emacs\blog" "E:\Dropbox\myblog"

;;; org2issue
(use-package org2issue
  :defer t
  :init
  (setq org2issue-user "private-github-user")
  (setq org2issue-blog-repo "org2issue-test")
  (setq org2issue-browse-issue t)
  (setq org2issue-update-file "~/org2issue-test/README.org"))




;;; esup
;;; startup time statistics
(use-package esup
  :defer t)

;;; helm-github-stars
;;; go to github starred project
(use-package helm-github-stars
  :config
  (setq helm-github-stars-username "private-github-user")
  ;; (setq helm-github-stars-cache-file "/cache/path")
;;;; refresh cache: M-x helm-github-stars-fetch
  (setq helm-github-stars-refetch-time 0.5)
  ;; (setq helm-github-stars-name-length nil)
  :bind (("C-c g s" . helm-github-stars))
  )


;;; helm-chrome
(use-package helm-chrome
  :defer t)

;; (use-package helm-google
;;   :config
;;   :bind
;;   (("C-h j" . helm-google)))


;;; vim-empty-mode
;;; add tilde at the empty line below the end of file
(use-package vim-empty-lines-mode
  :disabled t
  :config
  (global-vim-empty-lines-mode -1)
  ;; (add-hook 'after-init-hook 'vim-empty-lines-mode)
  ;; (setq vim-empty-lines-indicator "**********************")
  )


;;; org-zotxt-mode
;;; zotero connection
;;; zotxt is a Zotero extension for supporting utilities that deal with plain text files (e.g., markdown, reStructuredText, latex, etc.)
(defun hsk/enable-org-zotxt-mode ()
  "Enable `org-zotxt-mode' when the package is available."
  (when (require 'org-zotxt nil t)
    (org-zotxt-mode 1)))

(use-package zotxt
  :defer t
  :hook (org-mode . hsk/enable-org-zotxt-mode)
  :init
  (setq zotxt-default-bibliography-style "mkbehr-short")
  (with-eval-after-load 'org
    ;; Bind something to replace the awkward C-u C-c " i.
    (define-key org-mode-map
      (kbd "C-c \" \"")
      (lambda ()
        (interactive)
        (org-zotxt-insert-reference-link '(4)))))
  :config
  ;; Bind something to replace the awkward C-u C-c " i
  )




(use-package zotelo
  :hook ((TeX-mode . zotelo-minor-mode)
         (org-mode . zotelo-minor-mode)))


;;; yasnippet
;;; yet another snippet
(use-package yasnippet
  :config
  (yas-global-mode 1)
  ;; Develop in ~/emacs.d/mysnippets, but also
  ;; try out snippets in ~/Downloads/interesting-snippets
  (setq yas-snippet-dirs '("~/.emacs.d/snippets/"
                           "~/yasnippet-snippets/"))
  (defun yas/insert-by-name (name)
    (cl-flet ((dummy-prompt
               (prompt choices &optional display-fn)
               (declare (ignore prompt))
               (or (cl-find name choices :key display-fn :test #'string=)
                   (throw 'notfound nil))))
      (let ((yas/prompt-functions '(dummy-prompt)))
        (catch 'notfound
          (yas/insert-snippet t)))))

  ;; OR, keeping YASnippet defaults try out ~/Downloads/interesting-snippets
  ;; (setq yas-snippet-dirs (append yas-snippet-dirs
  ;; '("~/Downloads/interesting-snippets")))

  ;; (define-key yas-minor-mode-map (kbd "<tab>") nil)
  ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
  ;; (define-key yas-minor-mode-map (kbd "<the new key>") 'yas-expand)
  )


;; ox-latex-subfigure
(use-package ox-latex-subfigure
  :ensure nil
  :disabled t
  :load-path "~/.emacs.d/site-lisp/ox-latex-subfigure/"
  :config
  (require 'ox-latex-subfigure)
  (setq org-latex-caption-above nil
        org-latex-prefer-user-labels t))

(use-package org2ctex
  :if (locate-library "org2ctex")
  :ensure nil
  ;; :load-path "elpa-24.5/ox-latex-chinese/"
  ;; :disabled t
  :defer t
  :commands (org2ctex-toggle)
  :config
  ;; (setq org-latex-create-formula-image-program 'dvipng) ;速度很快，但 *默认* 不支持中文
  (setq org-latex-create-formula-image-program 'imagemagick) ;速度较慢，但支持中文
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 2.0)) ;调整 LaTeX 预览图片的大小
  (setq org-format-latex-options
        (plist-put org-format-latex-options :html-scale 2.5)) ;调整 HTML 文件中 LaTeX 图像的大小

  (org2ctex-toggle t)
  ;; (setq oxlc/org-latex-commands '("latexmk -xelatex -g -pdf %f"))
  ;; 升级 texlive 的 latexmk 之后， -xelatex 改变导致下面这一行命令不能用了
  ;; (setq oxlc/org-latex-commands '("latexmk -xelatex -gg -pdf %b.tex"))
  (setq org2ctex-latex-commands '("latexmk -xelatex -g %f"))
  ;; (setq oxlc/org-latex-commands '("latexmk -xelatex -gg %f"))
  ;; (setq oxlc/org-latex-commands '("latexmk -xelatex -gg %b.tex"))
  ;; %O 会被自动转义，现在也没办法，先去掉吧
  ;; (setq oxlc/org-latex-commands '("latexmk -pdflatex=\"xelatex %O %S\" -pdf -dvi- -ps- -gg -pdf %b.tex"))
  ;; (setq oxlc/org-latex-commands '("latexmk -pdflatex=\"xelatex\" -pdf -dvi- -ps- -gg -pdf %b.tex"))
  ;; (setq oxlc/org-latex-commands '("latexmk -pdflatex=\"xelatex %S\" -pdf -dvi- -ps- -gg -pdf %b.tex"))

  (defun org2ctex-export-to-pdf-quick ()
    (interactive)
    (let ((org2ctex-latex-commands '("latexmk -xelatex -g -pdf %f")))
      (org-latex-export-to-pdf)))

  ;; latex
  ;; (setq org-latex-coding-system 'utf-8) ; I do not know what the sentence do
  (setq org-export-allow-bind-keywords t)

  ;; booktabs usage, table centering and removal of every horizontal rule but the first one (in a "table.el" table only)
  (setq org-latex-tables-booktabs t)
  (setq org-latex-tables-centered t)

  ;; Export backends
  (setq org-export-backends (quote (ascii beamer html icalendar latex odt)))

  ;; cdlatex configuration
  (require-package 'cdlatex)
  (require 'cdlatex)
  (add-hook 'org-mode-hook 'turn-on-org-cdlatex)

  ;; my own settings by hsk
  ;; 不要在latex输出文件中插入\maketitle
  ;; (setq org-latex-title-command "")
  (setq org-latex-title-command "\\maketitle")
  (setq org-latex-toc-command "\\tableofcontents")
  ;; (setq org-latex-date-format "%Y-%m-%d") ; I do not know what the sentence do

  ;; 不导出 oxlc 中设置的默认字体
  (setq org2ctex-latex-fonts nil)

  ;; latex class redefinition in org
  ;; ctex for Chinese
  (setq org2ctex-latex-classes
        '(("ctexart"
           "\\documentclass[fontset=windowsnew,UTF8,a4paper,zihao=-4]{ctexart}
[DEFAULT-PACKAGES]
[PACKAGES]
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}
\\setCJKmainfont[BoldFont={SimHei}]{SimSun}
\\setCJKsansfont[BoldFont={SimHei}]{KaiTi}
\\setCJKmonofont{SimHei}
\\setmainfont{Times New Roman} % 英文衬线字体
\\setmonofont{Consolas} % 英文等宽字体
\\setsansfont{Arial} % 英文无衬线字体
[EXTRA]
"
;;; 下面这部分是上面字体设置部分的注释
;;; 最好使用文件名设置字体，而不是字体族名
;;; 最好在字体名（含粗体和斜体）写清楚，包括 Regular、Bold、Italic、BoldItalic 四个 series
;;; [[https://www.zhihu.com/question/20563044/answer/85151064][对于不了解字体的人，在使用LaTeX排版时如何通过fontspec包选择字体？ - 知乎]]
;;; \\setCJKmainfont[BoldFont={SimHei},ItalicFont={SimHei}]{SimSun}
;;; \\setCJKmonofont{Microsoft YaHei UI}
;;; \\setCJKsansfont{WenQuanYi Micro Hei}
;;; \\setCJKmonofont{WenQuanYi Micro Hei}
;;; 声明新的 CJK 字体族 <family> 并指定字体
;;; \setCJKfamilyfont {<family>} [<font features>] {<font name>}
;;; \\setmonofont{Monaco} % 英文等宽字体
;;; \\setmonofont{Courier New} % 英文等宽字体
;;; \\setsansfont{Trebuchet MS} % 英文无衬线字体
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ("ctexrep"
           "\\documentclass[fontset=none,UTF8,a4paper,zihao=-4]{ctexrep}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
          ("ctexbook"
           "\\documentclass[fontset=none,UTF8,a4paper,zihao=-4]{ctexbook}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
           ("\\part{%s}" . "\\part*{%s}")
           ("\\chapter{%s}" . "\\chapter*{%s}")
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
          ("beamer"
           "\\documentclass[presentation]{beamer}
\\usepackage[UTF8,space]{ctex}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           )
          ("article"
           "\\documentclass{article}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))


  ;; org不建议自定义org-latex-default-package-alist变量，但"inputenc" and "fontenc"两个宏包似乎和xelatex有冲突，调整默认值！
  ;; 如果直接设置该变量，可以直接去除这三个 cell，不需要下面这三段代码
  ;; (setf org-latex-default-packages-alist
  ;; (remove '("AUTO" "inputenc" t) org-latex-default-packages-alist))
  ;; (setf org-latex-default-packages-alist
  ;; (remove '("T1" "fontenc" t) org-latex-default-packages-alist))
  ;; (setf org-latex-default-packages-alist
  ;; (remove '("normalem" "ulem" t) org-latex-default-packages-alist))
  ;; (setf org-latex-default-packages-alist
  ;; (remove '("" "textcomp" t) org-latex-default-packages-alist))


  ;; customize default packages alist
  (setf org2ctex-latex-default-packages-alist
        (remove '("" "textcomp" t) org2ctex-latex-default-packages-alist))
  ;; (setf org2ctex-latex-default-packages-alist
  ;; (remove '("T1" "fontenc" t ("pdflatex")) org2ctex-latex-default-packages-alist))
  (setf org2ctex-latex-default-packages-alist
        (remove '("" "hyperref" nil) org2ctex-latex-default-packages-alist))
  (setf org2ctex-latex-default-packages-alist
        (remove '("" "capt-of" nil) org2ctex-latex-default-packages-alist))
  (add-to-list 'org2ctex-latex-default-packages-alist '("normalem" "ulem" t))
  (add-to-list 'org2ctex-latex-default-packages-alist '("colorlinks=true,linkcolor=blue,citecolor=blue" "hyperref" nil))
  (add-to-list 'org2ctex-latex-default-packages-alist '("" "float" nil))
  (add-to-list 'org2ctex-latex-default-packages-alist '("" "titletoc" nil))
  (add-to-list 'org2ctex-latex-default-packages-alist '("" "titling" nil))
  (add-to-list 'org2ctex-latex-default-packages-alist '("" "array" nil))

  (setq org2ctex-latex-packages-alist
        '(("" "tikz" nil)
          ;; ctex will automatically load xeCJKfntef, which will load CJKulem
          ;; ("" "CJKulem" nil)
          ;; use pifont only if use ding
          ;; ("" "pifont" nil)
          ;; xltxtra loads fontspec, metalogo, realscripts. Many features are incorporated into fontspec
          ("" "xltxtra" t)
          ("" "fontspec" nil)
          ("" "xunicode" nil)
          ;; ("" "newtxmath" t)
          ;; ("" "newtxtext" nil)
          ;; ("" "esint" nil)
          ;; ("" "mathpazo" nil) ; required by siunitx, but actually no matter
          ;; ("" "graphicx" nil)
          ;; ("top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm" "geometry" nil)
          ("" "caption" nil)
          ("" "multicol" nil)
          ("" "multirow" nil)
          ("" "booktabs" nil)
          ("" "cancel" nil)
          ("" "cleveref" nil)
          ("" "colortbl" nil)
          ("" "csquotes" nil)
          ("" "helvet" nil)
          ("" "pgfplots" nil)
          ("" "xcolor" t)
          ("" "siunitx" t)
          ;; ("" "upgreek" nil)
          ("" "physics" nil)
          ("" "bm" t)
          ("" "lscape" nil)
          ("" "fancyhdr" nil)
          ;; ("" "titlesec" nil) titlesec conflict with titling for the command thetitle
          ;; ("" "cite" nil)
          ("numbers,square,super,sort&compress" "natbib" nil)
          ("" "listings" nil)
          ("" "zhspacing" nil)
          ("" "tabularx" nil)
          ("" "pdflscape" nil)
          "
% early generated document maybe need the following sentences
% \\newcommand{\\circlenum}[1]{\\ding{\\numexpr171+#1}}
% \\DeclareSymbolFont{matha}{OML}{txmi}{m}{it}% txfonts
% \\DeclareMathSymbol{\\varv}{\\mathord}{matha}{118}
\\makeatletter
\\newcommand*{\\fullcite}[2][]{%
\\begingroup
\\let\\NAT@mbox=\\mbox
\\let\\@cite\\NAT@citenum
\\let\\NAT@space\\NAT@spacechar
\\let\\NAT@super@kern\\relax
\\renewcommand\\NAT@open{[}%
\\renewcommand\\NAT@close{]}%
\\cite[#1]{#2}%
\\endgroup
}
\\makeatother
"))

  (setq org-latex-packages-alist 'org2ctex-latex-packages-alist)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.3))

  (setq org-pretty-entities nil))


(use-package evil-tutor)


;;; cheatsheet

(use-package cheatsheet
  :config
  (cheatsheet-add :group 'Common
                  :key "C-x C-c"
                  :description "leave Emacs.")
  )


(use-package helm-descbinds
  :config
  (helm-descbinds-mode))

;; (use-package which-key
;;   :config
;;   (which-key-mode)
;;   (which-key-setup-side-window-right-bottom)
;;   (setq which-key-idle-delay 0.6))


;;; uimage - darksun - lujun9972

(use-package uimage
  :defer t
  :init
  ;; (push `(,(concat "\\(`\\|\\[\\[\\|<\\)?"
  ;; "\\(\\(file:http://\\)" uimage-mode-image-filename-regex "\\)"
  ;; "\\(\\]\\]\\|>\\|'\\)?") . 2)
  ;; uimage-mode-image-regex-alist )
  (add-hook 'after-init-hook
            (lambda ()
              (run-with-idle-timer 2 nil #'uimage-mode))))


;;; mode-icons
(use-package mode-icons
  :disabled t
  :config
  (mode-icons-mode)
  ;;(setq mode-icons-change-mode-name nil)
  )


;;; vdiff

(use-package vdiff
  :disabled t
  :config
  (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map)
  )


;;; symon
(use-package symon
  :defer t)


;;; figlet
(use-package figlet
  :defer t
  :init
  ;; (setq figlet-font-directory "c:/emacs/.emacs.d/win-apps/figlet/fonts")
  (setq figlet-font-directory (expand-file-name "~/.emacs.d/win-apps/figlet/fonts") )
  (setq figlet-options `("-d" ,figlet-font-directory)))


;;; hyperbole

(use-package hyperbole
  :disabled t
  )

;;; sublimity, a substitute of minimap
(use-package sublimity
  :disabled t
  :config
  (require 'sublimity-scroll)
  (require 'sublimity-map)
  ;; (require 'sublimity-attractive)

  (setq sublimity-scroll-weight 10
        sublimity-scroll-drift-length 5)
  (setq sublimity-map-size 20)
  (setq sublimity-map-fraction 0.3)
  (setq sublimity-map-text-scale -7)
  ;; (add-hook 'sublimity-map-setup-hook
  ;; (lambda ()
  ;; (setq buffer-face-mode-face '(:family "Monospace"))
  ;; (buffer-face-mode)))

  (sublimity-mode 1)
  )


;;; beacon-mode
(use-package beacon
  :config
  (beacon-mode 1))


;;; command-log-mode
(use-package command-log-mode
  :hook ((LaTeX-mode . command-log-mode)
         (emacs-lisp-mode . command-log-mode)))

;;; zhihu-daily
(use-package helm-zhihu-daily
  :defer t)



;;; neotree
(use-package neotree
  :config
  ;; (use-package all-the-icons)
  ;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :bind (("<f8>" . neotree-toggle)))


(use-package verify-url
  :defer t)

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/")
;; (use-package semantic-tag-folding
;; :config
;; (defun do-after-decorate () (semantic-tag-folding-mode t) )
;; (add-hook 'semantic-decoration-mode-hook 'do-after-decorate)
;; )


(use-package hydra
  :disabled t
  :config
  (defhydra hydra-buffer-menu (:color pink
                                      :hint nil)
    "
^Mark^ ^Unmark^ ^Actions^ ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark _u_: unmark _x_: execute _R_: re-isearch
_s_: save _U_: unmark up _b_: bury _I_: isearch
_d_: delete ^ ^ _g_: refresh _O_: multi-occur
_D_: delete up ^ ^ _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
    ("m" Buffer-menu-mark)
    ("u" Buffer-menu-unmark)
    ("U" Buffer-menu-backup-unmark)
    ("d" Buffer-menu-delete)
    ("D" Buffer-menu-delete-backwards)
    ("s" Buffer-menu-save)
    ("~" Buffer-menu-not-modified)
    ("x" Buffer-menu-execute)
    ("b" Buffer-menu-bury)
    ("g" revert-buffer)
    ("T" Buffer-menu-toggle-files-only)
    ("O" Buffer-menu-multi-occur :color blue)
    ("I" Buffer-menu-isearch-buffers :color blue)
    ("R" Buffer-menu-isearch-buffers-regexp :color blue)
    ("c" nil "cancel")
    ("v" Buffer-menu-select "select" :color blue)
    ("o" Buffer-menu-other-window "other-window" :color blue)
    ("q" quit-window "quit" :color blue))

  (define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)
  )


;;;persp-mode
(use-package persp-mode
  :disabled t
  :config
  (with-eval-after-load "persp-mode-autoloads"
    (setq wg-morph-on nil) ;; switch off animation
    (setq persp-autokill-buffer-on-remove 'kill-weak)
    (add-hook 'after-init-hook #'(lambda () (persp-mode 1))))

  (with-eval-after-load "persp-mode"
    (global-set-key (kbd "C-x b") #'persp-switch-to-buffer)
    (global-set-key (kbd "C-x k") #'persp-kill-buffer))
  )



;; symbol-overlay
(use-package symbol-overlay
  :disabled t
  :bind
  (("M-i" . symbol-overlay-put)
   ("M-u" . symbol-overlay-switch-backward)
   ("M-o" . symbol-overlay-switch-forward)))



;; langtool
(use-package langtool
  :config
  (setq langtool-language-tool-jar (expand-file-name "win-apps/langtool/languagetool-commandline.jar" user-emacs-directory))
  (setq langtool-default-language "en-US")
  ;; (setq langtool-mother-tongue "en")
  :bind
  (("C-x 4 w" . langtool-check)
   ("C-x 4 W" . langtool-check-done)
   ("C-x 4 l" . langtool-switch-default-language)
   ("C-x 4 4" . langtool-show-message-at-point)
   ("C-x 4 c" . langtool-correct-buffer)
   ))


;; centered-window-mode
;; works not well
(use-package centered-window-mode
  :disabled t
  :config
  (centered-window-mode t)
  )


;; helpful
(use-package helpful
  :commands (helpful-at-point
             helpful-callable
             helpful-command
             helpful-key
             helpful-variable))


(require 'init-window-settings)



;; Customized function

;; chinese-gbk 编码的 shell 终端
(defun gshell()
  (interactive)
  (let ((coding-system-for-read 'chinese-gbk)
        (coding-system-for-write 'chinese-gbk)
        (file-name-coding-system 'gbk))
    (shell)))
;; utf-8-unix 编码的 shell 终端
(defun ushell()
  (interactive)
  (let ((coding-system-for-read 'utf-8)
        (coding-system-for-write 'utf-8))
    (shell)))

(defun gtd ()
  (interactive)
  (find-file "~/GTD/newgtd.org"))

(defun my-customize-org ()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-org.el"))

(defun my-customize-local ()
  (interactive)
  (find-file "~/.emacs.d/lisp/init-local.el"))

(defun open-my-init-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))


(global-set-key (kbd "C-c v") 'view-mode)
(global-set-key (kbd "C-c g i") 'open-my-init-file)
(global-set-key (kbd "C-c g g") 'gtd)
(global-set-key (kbd "C-c g o") 'my-customize-org)
(global-set-key (kbd "<f2>") 'my-customize-local)
;; (define-key matlab-mode-map (kbd "M-j") nil)



;; broswe-url

;; [[https://emacs.stackexchange.com/questions/7328/how-to-make-eww-default-browser-in-emacs][org mode - How to make eww default browser in Emacs? - Emacs Stack Exchange]]
;; [[http://ergoemacs.org/emacs/elisp_browse_url.html][Emacs Lisp: View URL in Web Browser: browse-url]]
;; [[http://ergoemacs.org/emacs/emacs_set_default_browser.html][Emacs: Set Default Browser]]
(defun hsk/browse-url-with-chrome (url &optional _new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (setq url (browse-url-encode-url url))
  (cond
   ((string-equal system-type "windows-nt") ; Windows
    (shell-command (concat "chrome " url)))
   ((string-equal system-type "gnu/linux")
    (shell-command (concat "chrome " url)))
   ((string-equal system-type "darwin") ; Mac
    (shell-command (concat "open -a Chrome.app " url)))))

;; set env var named “path” by appending a new path
(setenv "PATH"
        (concat
         "C:/Program Files (x86)/Google/Chrome/Application/"
         ";"
         (getenv "PATH")))

;; (setq browse-url-browser-function 'hsk/browse-url-with-chrome)
;; (setq browse-url-browser-function 'eww-browse-url)
(setq browse-url-browser-function 'browse-url-default-browser)
;; (setq browse-url-browser-function 'browse-url-chromium)
;; (setq browse-url-browser-function 'browse-url-generic
;; browse-url-generic-program "chrome")

;; (defun hsk/browse-url-of-buffer-with-firefox ()
;; "Same as `browse-url-of-buffer' but using Firefox.
;; You need Firefox's path in the path environment variable within emacs.
;; e.g.
;; (setenv \"PATH\" (concat \"C:/Program Files (x86)/Mozilla Firefox/\" \";\" (getenv \"PATH\") ) )
;; On Mac OS X, you don't need to. This command makes this shell call:
;; 「open -a Firefox.app http://example.com/」"
;; (interactive)
;; (cond
;; ((string-equal system-type "windows-nt") ; Windows
;; (shell-command (concat "firefox file://" buffer-file-name)))
;; ((string-equal system-type "gnu/linux")
;; (shell-command (concat "firefox file://" buffer-file-name)))
;; ((string-equal system-type "darwin") ; Mac
;; (shell-command (concat "open -a Firefox.app file://" buffer-file-name)))))


;; Wiznote Customization
(defun wiznote-format-timestamp ()
  (interactive)
  (let ((wiznote-formated-timestamp (replace-regexp-in-string "\/" "-" (w32-get-clipboard-data))))
    (if wiznote-formated-timestamp
        (insert wiznote-formated-timestamp))))
(global-set-key (kbd "C-c g y") 'wiznote-format-timestamp)



;; (replace-regexp-in-string "\/" "-" (w32-get-clipboard-data))

;;(insert (replace-regexp-in-string "\/" "-" (w32-get-clipboard-data)))

;; (let ((wiznote-formated-timestamp (replace-regexp-in-string "\/" "-" (w32-get-clipboard-data))))
;; (if wiznote-formated-timestamp
;; (insert wiznote-formated-timestamp)))


;; geeknote
(use-package geeknote
  :init
  ;; (setq geeknote-command "geeknote")
  ;; :config
  :bind (
         ("C-c n c" . geeknote-create)
         ("C-c n e" . geeknote-edit)
         ("C-c n f" . geeknote-find)
         ("C-c n s" . geeknote-show)
         ("C-c n r" . geeknote-remove)
         ("C-c n m" . geeknote-move)
         )
  )

;; (use-package keycast
;;   :config
;;   (keycast-mode))

;; (use-package minions
;;   :config
;;   (minions-mode 1))

(use-package powershell
  :config
  (use-package ob-powershell
    :config
    (cl-pushnew '(powershell . t) load-language-alist)))

;; zsh
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode))
(add-hook 'sh-mode-hook
          (lambda ()
            (if (string-match "\\.zsh$" buffer-file-name)
                (sh-set-shell "zsh"))))

;; org-logseq
;; (use-package org-logseq
;;   :quelpa (org-logseq :fetcher github :repo "llcc/org-logseq" :files ("*"))
;;   :custom (org-logseq-dir org-roam-directory))



;; remove the prompt for killing emacsclient buffers 需要放在最后加载
;; http://stackoverflow.com/questions/268088/how-to-remove-the-prompt-for-killing-emacsclient-buffers
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)


;; 高亮括号内的代码
(unless (package-installed-p 'highlight-blocks)
  (package-install 'highlight-blocks))

(require 'highlight-blocks)

(setq highlight-blocks--rainbow-colors
      '("#BAFFFF" "#FFCACA" "#FFFFBA" "#CACAFF" "#CAFFCA" "#FFBAFF"))

(setq highlight-blocks-max-face-count
      (length highlight-blocks--rainbow-colors))

(defun highlight-blocks--define-rainbow-colors (colors)
  (dotimes (i (length colors))
    (face-spec-set
     (intern (format "highlight-blocks-depth-%d-face" (1+ i)))
     `((((class color) (background dark))  :background ,(nth i colors))
       (((class color) (background light)) :background ,(nth i colors)))
     'face-defface-spec)))

(highlight-blocks--define-rainbow-colors highlight-blocks--rainbow-colors)

;; Put the mode hooks where you want it, for example
;;
(add-hook 'emacs-lisp-mode-hook       'highlight-blocks-mode)
(add-hook 'lisp-interaction-mode-hook 'highlight-blocks-mode)
(add-hook 'lisp-mode-hook             'highlight-blocks-mode)

;; (defun highlight-blocks--get-bounds ()
;;   "Get the bounds of the nested blocks the point is in.
;; The returned value is a list of conses, where car is the start of a
;; block and cdr is the end of a block, starting from the outermost
;; block."
;;   (let ((result '())
;;         (parse-sexp-ignore-comments t))
;;     (condition-case nil
;;         (let* ((parse-state (syntax-ppss))
;;                (starting-pos (if (or (nth 3 parse-state)
;;                                      (nth 4 parse-state))
;;                                  (nth 8 parse-state)
;;                                (point)))
;;                (begins (nreverse (nth 9 parse-state)))
;;                (end starting-pos)
;;                (i 0))
;;           (while (or (eq highlight-blocks-max-innermost-block-count t)
;;                      (< i highlight-blocks-max-innermost-block-count))
;;             (setq end (scan-lists end 1 1))
;;             (push (cons (pop begins) end) result)
;;             (setq i (1+ i))))
;;       (scan-error))
;;     ;; 修改下这个函数函数的返回值，可以只高亮当前所在的块
;;     (last result)))



;;; beancount-mode
(let ((beancount-mode-dir
       (expand-file-name "straight/build/beancount-mode" user-emacs-directory)))
  (when (file-directory-p beancount-mode-dir)
    (add-to-list 'load-path beancount-mode-dir)))
(use-package beancount-mode
  :if (or (locate-library "beancount")
          (locate-library "beancount-mode"))
  :ensure nil
  :defer t
  :mode ("\\.beancount\\'" . beancount-mode)
  :config
  (add-hook 'beancount-mode-hook
            (lambda () (setq-local electric-indent-chars nil)))
  (add-hook 'beancount-mode-hook #'outline-minor-mode)
  (define-key beancount-mode-map (kbd "C-c C-n") #'outline-next-visible-heading)
  (define-key beancount-mode-map (kbd "C-c C-p") #'outline-previous-visible-heading))



;;; maximize-window: three ways do not work maybe because of the value of initial-frame-alist at the end of configuration
;;; way 1 not work
;; (custom-set-variables
;; '(initial-frame-alist (quote ((fullscreen . maximized)))))
;; (w32-send-sys-command 61488)
;; (run-with-idle-timer 0.5 nil 'w32-send-sys-command 61488)
;; (toggle-frame-maximized)

;; way 2 not work
;; (defun w32-maximize-frame ()
;; "Maximize the current frame (windows only)"
;; (interactive)
;; (w32-send-sys-command 61488))

;; (if (eq system-type 'windows-nt)
;; (progn
;; (add-hook 'window-setup-hook 'w32-maximize-frame t))
;; (set-frame-parameter nil 'fullscreen 'maximized))

;;;way 3 works: from Emacs 随想 http://everet.org/thinking-of-emacs.html
;; ;; 实现全屏效果，快捷键为f11
;; (global-set-key [(control f11)] 'my-fullscreen)
;; (defun my-fullscreen ()
;; (interactive)
;; (x-send-client-message
;; nil 0 nil "_NET_WM_STATE" 32
;; '(2 "_NET_WM_STATE_FULLSCREEN" 0))
;; )
;; ;; 最大化
;; (defun my-maximized ()
;; (interactive)
;; (if (fboundp 'x-send-client-message)
;; (progn
;; (x-send-client-message
;; nil 0 nil "_NET_WM_STATE" 32
;; '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
;; (x-send-client-message
;; nil 0 nil "_NET_WM_STATE" 32
;; '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
;; ))
;; )
;; ;; 启动emacs时窗口最大化
;; (when window-system
;; (my-maximized))



(defun restart-tabbar-mode ()
  (interactive)
  (tabbar-mode 0)
  (tabbar-mode 1)
  )

(restart-tabbar-mode)
;; (pyim-restart-1 t)
;; (pyim-restart-1)

;;; Maximize window: this line must be put at the end of configuration
(setq-default initial-frame-alist (quote ((fullscreen . maximized))))

(provide 'init-local)
