;;------------------User Defined-----------------------------------------------
;;-----------------------------------------------------------------------------
;;-----------------------------------------------------------------------------
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
(desktop-save-mode nil)
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
(setf org-file-apps
      (remove '("\\.pdf\\'" . default) org-file-apps))
(add-to-list 'org-file-apps '("\\.pdf\\'" . "sumatrapdf %s"))
(add-to-list 'org-file-apps '("\.pdf::\(\d+\)\'" . "sumatrapdf -page %1 %s"))

;;; Chinese fonts setup

;; (add-to-list 'load-path "~/.emacs.d/elpa/chinese-fonts-setup-20160419.2159/")
;; (add-to-list 'load-path "~/.emacs.d/elpa/chinese-fonts-setup/")

;; (require-package 'chinese-fonts-setup)
;; (require 'chinese-fonts-setup)
(use-package chinese-fonts-setup
  :ensure t
  :demand t
  :init
  (setq cfs-verbose nil)

  :config
  ;; (cl-prettyprint (font-family-list))
  ;; (print (font-family-list))

  ;; (cl-remove-if #'(lambda (font)
  ;;                   (not (string-match-p "\\cc" font)))
  ;;               (font-family-list))

  (setq cfs-personal-fontnames
        '(
          ()
          ("方正书宋简体" "方正字迹-典雅楷体简体" "方正宋刻本秀楷简体" "方正正纤黑简体" "方正清刻本悦宋简体" "方正苏新诗柳楷简体" "冬青黑体简体中文 W3" "冬青黑体简体中文 W6" "文泉驿微米黑" "思源黑体 Regular" "思源黑体 Normal" "思源黑体 Medium" "思源黑体 Light" "思源黑体 Heavy" "思源黑体 ExtraLight" "思源黑体 Bold" "冬青黑体" "思源黑体" "方正兰亭准黑_GBK" "方正兰亭黑_GBK" "方正兰亭纤黑_GBK" "Microsoft YaHei UI")
          ()
          ))

  (setq cfs-profiles
        '("program" "org-mode" "read-book"))
  (chinese-fonts-setup-enable)
  :bind
  (("C--" . cfs-decrease-fontsize)
   ("C-=" . cfs-increase-fontsize)
   ("C-+" . cfs-next-profile)))


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
  :ensure t
  :config
  (smartparens-global-mode t)
  )


;;; lispy(abo-abo)
;; lispy 的 comment 在第一次加载时不起作用，其他命令正常
;; lispy 的 M-j 与 chinese-pyim 的函数冲突，已经将 lispy 的 lispy-split 命令绑定为 U
(use-package lispy
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
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
  ;;   `(progn
  ;;      ;; replace a global binding with own function
  ;;      (define-key lispy-mode-map (kbd "C-e") 'my-custom-eol)
  ;;      ;; replace a global binding with major-mode's default
  ;;      (define-key lispy-mode-map (kbd "C-j") nil)
  ;;      ;; replace a local binding
  ;;      (lispy-define-key lispy-mode-map "s" 'lispy-down)))

  ;; http://oremacs.com/lispy/
  ;; https://github.com/abo-abo/lispy
  )


;;; org-download(abo-abo)
(use-package org-download
  :ensure t
  :config
  ;; (setq org-download-backend 'wget)
  (setq org-download-backend "wget")
  (setq org-download-annotate-function 'ignore)
  )


(use-package org-attach-screenshot
  :config
  ;; (setq org-attach-screenshot-command-line "mycommand -x -y -z %f")
  (setq org-attach-screenshot-dirfunction
        (lambda ()
          (progn (assert (buffer-file-name))
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
        (call-process-shell-command "convert" nil nil nil nil (concat "\"" filename "\" -resize  \"50%\"" ) (concat "\"" filename "\"" ))
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
  :ensure t
  :config
  (ace-link-setup-default)
  (define-key org-mode-map (kbd "M-o") 'ace-link-org)
  ;; (define-key gnus-summary-mode-map (kbd "M-o") 'ace-link-gnus)
  ;; (define-key gnus-article-mode-map (kbd "M-o") 'ace-link-gnus)
  ;; (global-set-key (kbd "M-o") 'ace-link-addr)
  )


(use-package habitica
  :ensure t
  :config
  (setq habitica-uid "REDACTED-HABITICA-UID")
  (setq habitica-token "REDACTED-HABITICA-TOKEN")
  ;; If you want to try highlighting tasks based on their value, This is very experimental.
  ;; (setq habitica-turn-on-highlighting t)
  ;; If you want the streak count to appear as a tag for your daily tasks
  (setq habitica-show-streak t)
  )


;; (use-package ox-anki
;;   :ensure t
;;   :config
;;   )


;;; tiny(abo-abo)
(use-package tiny
  :ensure t
  :config
  (tiny-setup-default))


;;; popwin

(use-package popwin
  :ensure t
  :config
  (popwin-mode t)
  )



;;; ag

(use-package ag
  :ensure t
  :config
  (setq-default grep-highlight-matches t
                grep-scroll-output t)

  (when *is-a-mac*
    (setq-default locate-command "mdfind"))

  (when (executable-find "ag")
    (require-package 'ag)
    (require-package 'wgrep-ag)
    ;; (setq-default ag-highlight-search t)
    (global-set-key (kbd "M-?") 'ag-project))
  )


;;; hungry-delete

(use-package hungry-delete
  :ensure t
  :config
  (global-hungry-delete-mode)
  )



;;Set nodejs-repl
(require-package 'nodejs-repl)
(require 'nodejs-repl)


;;; swiper

(use-package swiper
  :ensure t
  ;; :disabled t
  :config
  (use-package counsel
    :ensure t)
  (use-package counsel-projectile
    :ensure t
    :config
    (counsel-projectile-on))
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)

  ;; 让`ivy-read'支持拼音
  ;; [[https://emacs-china.org/t/ivy-read/2432][使ivy-read支持拼音搜索 - Emacs-general - Emacs China]]
  (use-package pinyinlib
    :ensure t)

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
  :ensure t
  :bind ("M-y" . helm-show-kill-ring))


;; (setq url-proxy-services '(("http"  . "localhost:1080")
;;                            ("https" . "localhost:1080")))



;;; server mode(Allow access from emacsclient)

;; (use-package server
;;   :ensure t
;;   :config
;;   (unless (server-running-p)
;;     ;; (setq server-auth-dir "d:\\emacs\\.emacs.d\\server\\")
;;     (cond
;;      ((eq system-type 'windows-nt)
;;       (setq server-auth-dir "~\\.emacs.d\\server\\"))
;;      ((eq system-type 'gnu/linux)
;;       (setq server-auth-dir "~/.emacs.d/server/")))
;;     (setq server-name "emacs-server-file")
;;     (server-start)))


;;; edit-server: start edit server for chromebrowser(port:9292)

(use-package edit-server
  :ensure t
  :config
  (setq edit-server-new-frame nil)
  (edit-server-start)
  )


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
;;   (set-selection-coding-system 'gbk-dos)
;;   (set-next-selection-coding-system 'gbk-dos)
;;   (set-clipboard-coding-system 'gbk-dos))


;;-----------------------------------------------
;;ido-mode
;;-----------------------------------------------
(ido-mode t)
(setq gc-cons-threshold 20000000)


;;; flx-ido
(use-package flx-ido
  :ensure t
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
  :ensure t
  :config
  (tabbar-mode t)
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
  :ensure t
  :disabled t
  :config
  (setq tabbar-ruler-global-tabbar t)   ; If you want tabbar
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
;;   'linum
;;   "linum-mode"
;;   "Emacs linum minor mode"
;;   t)
;; (autoload
;;   'linum
;;   "global-linum-mode"
;;   "Emacs linum minor mode"
;;   t)
;; (global-linum-mode -1)

;;------------------------------------------------
;;Go to char(Use hot key to move last or next certain letter)
;;------------------------------------------------
;; (defun my-go-to-char (n char)
;;   "Move forward to Nth occurence of CHAR.
;; Typing `my-go-to-char-key' again will move forwad to the next Nth
;; occurence of CHAR."
;;   (interactive "p\ncGo to char: ")
;;   (let ((case-fold-search nil))
;;     (if (eq n 1)
;;         (progn                            ; forward
;;           (search-forward (string char) nil nil n)
;;           (backward-char)
;;           (while (equal (read-key)
;;                         char)
;;             (forward-char)
;;             (search-forward (string char) nil nil n)
;;             (backward-char)))
;;       (progn                              ; backward
;;         (search-backward (string char) nil nil )
;;         (while (equal (read-key)
;;                       char)
;;           (search-backward (string char) nil nil )))))
;;   (setq unread-command-events (list last-input-event)))
;; (global-set-key (kbd "C-t") 'my-go-to-char)


;;; Window numbering(Numbered window shortcuts for Emacs)
(use-package window-numbering
  :ensure t
  :config
  (window-numbering-mode t)
  ;; (setq window-numbering-assign-func
  ;;      (lambda () (when (equal (buffer-name) "*Calculator*") 9))
  )



;;; expand-region
(use-package expand-region
  :ensure t
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
  :ensure t
  :config
  (setenv "SSH_ASKPASS" "git-gui--askpass")
  ;; (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
  :bind (
         ("C-x g" . magit-status))
  )



;; screenshot
;; 使用 irfanview 的命令行截图，并保存到指定文件夹
;; 再使用 picpick 或 faststone 修改
(defun cut ()
  "Take a screenshot into a unique-named file in the current buffer file
   directory and insert a link to this file.
[[http://www.jianshu.com/p/77841e0aba46][emacs的工作环境设置 - 简书]]
[[https://emacs-china.org/t/org-mode-windows-7/2161/9][Org-mode截图与显示图片（Windows 7） - Org-mode - Emacs China]]
"
  (interactive)
  (setq filename
        (concat (make-temp-name "img-") ".png"))
  ;; (shell-command (format "boxcutter f:/cy/home/thinkT420/Notiz/img/\"%s\"" filename))
  (shell-command (concat "i_view64 /capture=4 /convert=" "\"g:\\testimg" (format "\\%s\"" filename)))
  (insert (concat "[[./img/" filename "]]"))
  (shell-command (format "picpick f:/cy/home/thinkT420/Notiz/img/\"%s\"" filename))
  )

(define-key org-mode-map (kbd "C-c r") 'cut)

;; merriam-webster dictionary
;; 使用 eww 直接打开网页，不够人性化
;; 希望可以做成有道那样，不知道 wesbter 有没有提供 API
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
  :ensure t
  :bind (
         ;; ("C-c C-y" . define-word-at-point)
         ("C-c C-y" . define-word))
  )


;;; youdao-dictionary
(use-package youdao-dictionary
  :ensure t
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
         ("C-c y" . youdao-dictionary-search-at-point))
  )


;;; chinese-pyim

;; (require 'chinese-pyim)
(use-package chinese-pyim
  :ensure t
  :demand t
  ;; :disabled t
  :config
  ;; 基本快捷键列表
  ;; C-n/M-n/+ 向下翻页， C-p/M-p/- 向上翻页， C-f 选择下一个备选词，C-b 选择上一个备选词
  ;; SPC 确定输入，RET/C-m 字母上屏， C-c 取消输入， C-g 取消输入并保留已输入的中文， TAB 模糊音调整
  (setq default-input-method "chinese-pyim")
  ;; (setq default-input-method nil)
  (setq pyim-default-scheme 'quanpin)
  (global-set-key (kbd "C-\\") 'toggle-input-method)

  ;; (setq pyim-enable-words-predict '(dabbrev pinyin-similar pinyin-znabc))
  ;; (setq pyim-enable-words-predict nil)
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

  (use-package chinese-pyim-basedict
    :ensure t
    ;; :disabled t
    :config
    (chinese-pyim-basedict-enable))

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
  (setq pyim-page-length 5)
  ;; (setq pyim-page-style 'one-line)
  (setq pyim-page-tooltip nil)
  ;; (setq pyim-page-tooltip 'pos-tip)
  ;; (setq pyim-page-tooltip 'popup)
  ;; (print pyim-dicts)
  (add-hook 'emacs-startup-hook
            #'(lambda () (pyim-restart-1 t)))
  ;; (pyim-restart-1 t)

  ;; 词库导出，后续更新版本需要注释掉
  (defun pyim-personal-dcache-export ()
    "将 pyim-dcache-icode2word 导出为 pyim 词库文件。"
    (interactive)
    (let ((file (read-file-name "将个人缓存中的词条导出到文件：")))
      (with-temp-buffer
        (insert ";;; -*- coding: utf-8-unix -*-\n")
        (maphash
         #'(lambda (key value)
             (insert (concat key " " (mapconcat #'identity value " ") "\n")))
         pyim-dcache-icode2word)
        (write-file file))))

  (use-package chinese-pyim-company
    :disabled t
    :ensure nil
    :config
    (setq pyim-company-max-length 6))

  :bind
  (("C-\\" . toggle-input-method)
   ("M-j" . pyim-convert-code-at-point)
   ;; ("C-;" . pyim-delete-word-from-personal-buffer)
   ("C-c h" . pyim-punctuation-translate-at-point)
   ("C-c C-h" . pyim-punctuation-toggle)
   ("M-f" . pyim-forward-word)
   ("M-b" . pyim-backward-word)
   ))


;;;pinyin-search
(use-package pinyin-search
  :ensure t
  :bind
  (("C-r" . pinyin-search)))


;; (use-package easy-lentic
;;   :ensure t
;;   :config
;;   (use-package ox-gfm
;;     :ensure t)
;;   (easy-lentic-mode-setup) ; Enable `easy-lentic-mode' for `emacs-lisp-mode' and `org-mode'
;;   )


(use-package find-by-pinyin-dired
  :ensure t)


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
  :ensure t
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

(use-package ahk-mode
  :ensure t)



;;------------------------------------------------
;;ace-jump-mode(unistalled at 20160408, replaced with avy)
;;------------------------------------------------
;; (add-to-list 'load-path "~/.emacs.d/elpa/ace-jump-mode-20140616.115/")
;; (autoload
;;   'ace-jump-mode
;;   "ace-jump-mode"
;;   "Emacs quick move minor mode"
;;   t)
;; ;; you can select the key you prefer to
;; (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
;; ;;(global-set-key (kbd "C-c SPC") 'ace-jump-mode)
;; ;; When org-mode starts it (org-mode-map) overrides the ace-jump-mode.
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "\C-c SPC") 'ace-jump-mode)))
;; ;; enable a more powerful jump back function from ace jump mode
;; (autoload
;;   'ace-jump-mode-pop-mark
;;   "ace-jump-mode"
;;   "Ace jump back:-)"
;;   t)
;; (eval-after-load "ace-jump-mode"
;;   '(ace-jump-mode-enable-mark-sync))
;; (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;;If you use viper mode :
;;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;;If you use evil
;;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)



;;; avy

(use-package avy
  :ensure t
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
  :ensure t
  :config
  ;; (setq ace-pinyin-use-avy nil) ;; uncomment if you want to use `ace-jump-mode'
  (ace-pinyin-global-mode +1))


;;; multiple-cursors
(use-package multiple-cursors
  :ensure t
  :bind (
         ("C-M-," . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         )
  )


;;; fcitx

;; (if (string-equal system-type "gnu/linux")
;;     (progn
;;       (require-package 'fcitx)
;;       (fcitx-default-setup)
;;       (fcitx-isearch-turn-on)
;;       ;; The next line should be comment when use OS X
;;       (setq fcitx-use-dbus t)) nil)


;;; add gitman

(cond
 ((eq system-type 'windows-nt)
  (defadvice Info-follow-nearest-node (around gitman activate)
    "When encountering a cross reference to the `gitman' info
manual, then instead of following that cross reference show
the actual manpage using the function `woman'."
    (let ((node (Info-get-token
                 (point) "\\*note[ \n\t]+"
                 "\\*note[ \n\t]+\\([^:]*\\):\\(:\\|[ \n\t]*(\\)?")))
      (if (and node (string-match "^(gitman)\\(.+\\)" node))
          (progn (require 'woman)
                 (woman (match-string 1 node)))
        ad-do-it))))

 ((eq system-type 'gnu/linux)
  (defadvice Info-follow-nearest-node (around gitman activate)
    "When encountering a cross reference to the `gitman' info
manual, then instead of following that cross reference show
the actual manpage using the function `man'."
    (let ((node (Info-get-token
                 (point) "\\*note[ \n\t]+"
                 "\\*note[ \n\t]+\\([^:]*\\):\\(:\\|[ \n\t]*(\\)?")))
      (if (and node (string-match "^(gitman)\\(.+\\)" node))
          (progn (require 'man)
                 (man (match-string 1 node)))
        ad-do-it)))))


;; TODO: twittering-mode
;; [[https://github.com/hayamiz/twittering-mode][hayamiz/twittering-mode: An Emacs major mode for Twitter]]


;; TODO: org-ioslide
;; Export your Org document to Google I/O HTML5 slide
;; [[https://github.com/coldnew/org-ioslide][coldnew/org-ioslide: Export org-mode to Google I/O HTML5 slide.]]

;; tldr.el
(use-package tldr
  :ensure t
  :config
  ;; (tldr-update-docs)
  )


;; kaomoji 颜文字
(use-package kaomoji
  :ensure t
  :config
  ;; (setq kaomoji-table
  ;;       (append '((("angry" "furious") . "(／‵Д′)／~ ╧╧ ")
  ;;                 (("angry" "punch") . "#???）?彡☆))?Д?)?∵"))
  ;;               kaomoji-table))
  )



;; hexo.el
(use-package hexo
  :ensure t
  :config
  (defun hexo-hsk-blog ()
    (interactive)
    (hexo "~/blog/")))

;;; blog-admin
(use-package blog-admin
  :ensure t
  :config
  (setq blog-admin-backend-path "~/blog")
  (setq blog-admin-backend-type 'hexo)
  (setq blog-admin-backend-new-post-in-drafts t) ;; create new post in drafts by default
  (setq blog-admin-backend-new-post-with-same-name-dir t) ;; create same-name directory with new post
  ;; (setq blog-admin-backend-hexo-config-file "my_config.yml") ;; default assumes _config.yml
  )
;; (add-to-list 'load-path "~/.emacs.d/elpa/blog-admin")
;; (require 'blog-admin)
;; When change home directory, use the following line to make soft link which point to the blog directory in the Dropbox sync directory
;; Mklink /j "C:\emacs\blog" "E:\Dropbox\myblog"

;;; org2issue
(use-package org2issue
  :ensure t
  :config
  ;;(require-package 'ox-gfm)
  ;;(require 'ox-gfm)
  (setq org2issue-user "private-github-user")
  (setq org2issue-blog-repo "org2issue-test")
  (setq org2issue-browse-issue t)
  (setq org2issue-update-file "~/org2issue-test/README.org")
  )




;;; esup
;;; startup time statistics
(use-package esup
  :ensure t)

;;; helm-github-stars
;;; go to github starred project
(use-package helm-github-stars
  :ensure t
  :config
  (setq helm-github-stars-username "private-github-user")
  ;; (setq helm-github-stars-cache-file "/cache/path")
;;;; refresh cache:  M-x helm-github-stars-fetch
  (setq helm-github-stars-refetch-time 0.5)
  ;; (setq helm-github-stars-name-length nil)
  :bind (("C-c g s" . helm-github-stars))
  )


;;; helm-chrome
(use-package helm-chrome
  :ensure t
  :config
  ;; (setq helm-chrome-use-urls t)
  ;; (helm-chrome-reload-bookmarks)
  )

(use-package helm-google
  :ensure t
  :config
  ;; (setq browse-url-browser-function 'eww-browse-url)
  ;; (setq browse-url-browser-function 'browse-url-default-browser)
  :bind
  (("C-h j" . helm-google)))


;;; vim-empty-mode
;;; add tilde at the empty line below the end of file
(use-package vim-empty-lines-mode
  :ensure t
  :disabled t
  :config
  (global-vim-empty-lines-mode -1)
  ;; (add-hook 'after-init-hook 'vim-empty-lines-mode)
  ;; (setq vim-empty-lines-indicator "**********************")
  )


;;; org-zotxt-mode
;;; zotero connection
(use-package zotxt
  :ensure t
  :config
  (require 'org-zotxt)
  ;; Activate org-zotxt-mode in org-mode buffers
  (add-hook 'org-mode-hook (lambda () (org-zotxt-mode 1)))
  ;; Bind something to replace the awkward C-u C-c " i
  (define-key org-mode-map
    (kbd "C-c \" \"") (lambda () (interactive)
                        (org-zotxt-insert-reference-link '(4))))
  ;; Change citation format to be less cumbersome in files.
  ;; You'll need to install mkbehr-short into your style manager first.
  (eval-after-load "zotxt"
    '(setq zotxt-default-bibliography-style "mkbehr-short"))
  )




(use-package zotelo
  :ensure t
  :config
  (add-hook 'TeX-mode-hook 'zotelo-minor-mode)
  (add-hook 'org-mode-hook 'zotelo-minor-mode))


;;; yasnippet
;;; yet another snippet
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  ;; Develop in ~/emacs.d/mysnippets, but also
  ;; try out snippets in ~/Downloads/interesting-snippets
  (setq yas-snippet-dirs '("~/.emacs.d/snippets/"
                           "~/yasnippet-snippets/"))

  ;; OR, keeping YASnippet defaults try out ~/Downloads/interesting-snippets
  ;; (setq yas-snippet-dirs (append yas-snippet-dirs
  ;;                                '("~/Downloads/interesting-snippets")))

  ;; (define-key yas-minor-mode-map (kbd "<tab>") nil)
  ;; (define-key yas-minor-mode-map (kbd "TAB") nil)
  ;; (define-key yas-minor-mode-map (kbd "<the new key>") 'yas-expand)
  )


(use-package ox-latex-chinese
  :ensure t
  ;; :disabled t
  :config
  ;; (setq org-latex-create-formula-image-program 'dvipng)    ;速度很快，但 *默认* 不支持中文
  (setq org-latex-create-formula-image-program 'imagemagick) ;速度较慢，但支持中文
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 2.0)) ;调整 LaTeX 预览图片的大小
  (setq org-format-latex-options
        (plist-put org-format-latex-options :html-scale 2.5)) ;调整 HTML 文件中 LaTeX 图像的大小

  (oxlc/toggle-ox-latex-chinese t)
  ;; (setq oxlc/org-latex-commands '("latexmk -xelatex -g -pdf %f"))
  ;; 升级 texlive 的 latexmk 之后， -xelatex 改变导致下面这一行命令不能用了
  ;; (setq oxlc/org-latex-commands '("latexmk -xelatex -gg -pdf %b.tex"))
  ;; %O 会被自动转义，现在也没办法，先去掉吧
  ;; (setq oxlc/org-latex-commands '("latexmk -pdflatex=\"xelatex %O %S\" -pdf -dvi- -ps- -gg -pdf %b.tex"))
  (setq oxlc/org-latex-commands '("latexmk -pdflatex=\"xelatex %S\" -pdf -dvi- -ps- -gg -pdf %b.tex"))

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
  (setq oxlc/org-latex-fonts nil)

  ;; latex class redefinition in org
  ;; ctex for Chinese
  (setq oxlc/org-latex-classes
        '(("ctexart"
           "\\documentclass[fontset=windowsnew,UTF8,a4paper,zihao=-4]{ctexart}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}
\\setCJKmainfont[BoldFont={SimHei}]{SimSun}
\\setCJKsansfont[BoldFont={SimHei}]{Kaiti}
\\setCJKmonofont{SimHei}
\\setmainfont{Times New Roman}    % 英文衬线字体
\\setmonofont{Consolas}           % 英文等宽字体
\\setsansfont{Arial}              % 英文无衬线字体
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
;;; \\setmonofont{Monaco}   % 英文等宽字体
;;; \\setmonofont{Courier New}   % 英文等宽字体
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
           "\\documentclass{arcitle}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
           ("\\section{%s}" . "\\section*{%s}")
           ("\\subsection{%s}" . "\\subsection*{%s}")
           ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
           ("\\paragraph{%s}" . "\\paragraph*{%s}")
           ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))
          ))


;; org不建议自定义org-latex-default-package-alist变量，但"inputenc" and "fontenc"两个宏包似乎和xelatex有冲突，调整默认值！
;; 如果直接设置该变量，可以直接去除这三个 cell，不需要下面这三段代码
;; (setf org-latex-default-packages-alist
;;       (remove '("AUTO" "inputenc" t) org-latex-default-packages-alist))
  (setf org-latex-default-packages-alist
        (remove '("T1" "fontenc" t) org-latex-default-packages-alist))
;; (setf org-latex-default-packages-alist
;;       (remove '("normalem" "ulem" t) org-latex-default-packages-alist))


;; modify hyperref options in default packages alist
  (setf oxlc/org-latex-default-packages-alist
        (remove '("" "hyperref" nil) oxlc/org-latex-default-packages-alist))
  (add-to-list 'oxlc/org-latex-default-packages-alist '("colorlinks=true,linkcolor=blue,citecolor=blue" "hyperref" nil))

  (add-to-list 'oxlc/org-latex-default-packages-alist '("" "float" nil))
  (add-to-list 'oxlc/org-latex-default-packages-alist '("" "titletoc" nil))
  (add-to-list 'oxlc/org-latex-default-packages-alist '("" "titling" nil))

  (setq  oxlc/org-latex-packages-alist
         '(("" "tikz" nil)
           ("" "CJKulem" nil)
           ("" "pifont" nil)
           ("" "xltxtra" t)
           ("" "fontspec" nil)
           ("" "xunicode" nil)
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
           ;; ("" "mathpazo" nil) ; required by siunitx, but actually no matter
           ("" "pgfplots" nil)
           ("" "xcolor" nil)
           ("" "siunitx" nil)
           ("" "upgreek" nil)
           ("" "physics" nil)
           ("" "bm" nil)
           ("" "esint" nil)
           ("" "lscape" nil)
           ("" "fancyhdr" nil)
         ;; ("" "titlesec" nil)  titlesec conflict with titling for the command thetitle
         ;; ("" "cite" nil)
           ("numbers,square,super,sort&compress" "natbib" nil)
           ("" "listings" nil)
           "
\\newcommand{\\circlenum}[1]{\\ding{\\numexpr171+#1}}
\\DeclareSymbolFont{matha}{OML}{txmi}{m}{it}% txfonts
\\DeclareMathSymbol{\\varv}{\\mathord}{matha}{118}
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

  (setq org-latex-packages-alist 'oxlc/org-latex-packages-alist)

  (setq org-pretty-entities nil))


(use-package evil-tutor
  :ensure t)


;;; cheatsheet

(use-package cheatsheet
  :ensure t
  :config
  (cheatsheet-add :group 'Common
                  :key "C-x C-c"
                  :description "leave Emacs.")
  )


(use-package helm-descbinds
  :ensure t
  :config
  (helm-descbinds-mode))

(use-package which-key
  :ensure t
  :config
  (which-key-mode)
  (which-key-setup-side-window-right-bottom)
  (setq which-key-idle-delay 0.6))


;;; uimage - darksun - lujun9972

(use-package uimage
  :ensure t
  :config
  ;; (push `(,(concat "\\(`\\|\\[\\[\\|<\\)?"
  ;;                  "\\(\\(file:http://\\)" uimage-mode-image-filename-regex "\\)"
  ;;                  "\\(\\]\\]\\|>\\|'\\)?") . 2)
  ;;       uimage-mode-image-regex-alist )
  (uimage-mode)
  )


;;; mode-icons
(use-package mode-icons
  :ensure t
  :disabled t
  :config
  (mode-icons-mode)
  ;;(setq mode-icons-change-mode-name nil)
  )


;;; vdiff

(use-package vdiff
  :ensure t
  :disabled t
  :config
  (define-key vdiff-mode-map (kbd "C-c") vdiff-mode-prefix-map)
  )


;;; symon
(use-package symon
  :ensure t
  :config
  ;; (symon-mode)
  )


;;; figlet
(use-package figlet
  :ensure t
  :config
  ;; (setq figlet-font-directory "c:/emacs/.emacs.d/win-apps/figlet/fonts")
  (setq figlet-font-directory (expand-file-name "~/.emacs.d/win-apps/figlet/fonts") )
  (setq figlet-options `("-d",figlet-font-directory))
  )


;;; hyperbole

(use-package hyperbole
  :ensure t
  :disabled t
  )

;;; sublimity, a substitute of minimap
(use-package sublimity
  :ensure t
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
  ;;           (lambda ()
  ;;             (setq buffer-face-mode-face '(:family "Monospace"))
  ;;             (buffer-face-mode)))

  (sublimity-mode 1)
  )


;;; beacon-mode
(use-package beacon
  :ensure t
  :config
  (beacon-mode 1))


;;; command-log-mode
(use-package command-log-mode
  :ensure t
  :config
  (add-hook 'LaTeX-mode-hook 'command-log-mode)
  (add-hook 'emacs-lisp-mode-hook 'command-log-mode)
  )

;;; zhihu-daily
(use-package helm-zhihu-daily
  :ensure t)



;;; neotree
(use-package neotree
  :config
  ;; (use-package all-the-icons)
  ;; (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :bind (("<f8>" . neotree-toggle)))


(use-package verify-url
  :ensure t)

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/")
;; (use-package semantic-tag-folding
;;   :config
;;   (defun do-after-decorate () (semantic-tag-folding-mode t) )
;;   (add-hook 'semantic-decoration-mode-hook 'do-after-decorate)
;;   )


(use-package hydra
  :ensure t
  :disabled t
  :config
  (defhydra hydra-buffer-menu (:color pink
                                      :hint nil)
    "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
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

;;; erc
;;; emacs irc

;; (defconst irc-channels
;;   '(("freenode.net" "#ubuntu-cn" "#archlinux-cn" "#emacs.tw"
;;      ;; "#geekhack"
;;      )
;;     ("oftc.net" "#arch-cn" "#njulug" "#wormux-cn" "#emacs-cn")
;;     ("esper.net" "#minecraft-cn")))
;; (ignore-errors (setq erc-autojoin-channels-alist irc-channels))

;; (defun erc-start ()
;;   (interactive)
;;   (erc :server "irc.freenode.net" :port 6667 :nick irc-nick
;;        :password irc-password :full-name irc-full-name)
;;   (erc-tls :server "irc.oftc.net" :port 6697 :nick irc-nick
;;            :password irc-password :full-name irc-full-name)
;;   (erc-tls :server "irc.esper.net" :port 6697 :nick irc-nick
;;            :password irc-password :full-name irc-full-name))


;; (setq erc-quit-reason-various-alist
;;       '(("dinner" "Having dinner...")
;;         ("z" "Zzz...")
;;         ("^$" yow)))
;; (setq erc-quit-reason 'erc-quit-reason-various)

;; (defun erc-cmd-THINK (&rest line)
;;   (let ((text
;;          (concat ".oO{ "
;;                  (erc-trim-string (mapconcat 'identity line " "))
;;                  " }")))
;;     (erc-send-action (erc-default-target) text)))

;; (defun erc-cmd-SLAP (&rest nick)
;;   (if (not (equal '() nick))
;;       (erc-send-action
;;        (erc-default-target)
;;        (concat "slaps " (car nick)
;;                " with Peskin's Introduction to QFT."))))

;; (defun erc-cmd-SHOWOFF (&rest ignore)
;;   "Show off implementation"
;;   (let* ((chnl (erc-buffer-list))
;;          (srvl (erc-buffer-list 'erc-server-buffer-p))
;;          (memb (apply '+ (mapcar (lambda (chn)
;;                                    (with-current-buffer chn
;;                                      (1- (length (erc-get-channel-user-list)))))
;;                                  chnl)))
;;          (show (format "is connected to %i networks and talks in %i chans to %i ppl overall :>"
;;                        (length srvl)
;;                        (- (length chnl) (length srvl))
;;                        memb)))
;;     (erc-send-action (erc-default-target) show)))

;; ;; Say hi to everyone, use with CAUTION!!
;; (defun erc-cmd-HI ()
;;   (defun hi-to-nicks (nick-list)
;;     (if (eq nick-list '())
;;         nil
;;       (erc-send-message (concat "Hi, " (car nick-list)))
;;       (sleep-for 1)
;;       (hi-to-nicks (cdr nick-list))))

;;   (let ((nicks (erc-get-channel-nickname-list)))
;;     (hi-to-nicks nicks)))

;; [[https://www.zhihu.com/question/27478438/answer/59796810][Emacs 有什么奇技淫巧? - 地铁风的回答 - 知乎]]
;; [[https://www.zhihu.com/question/27478438][Emacs 有什么奇技淫巧? - 知乎]]


;;;persp-mode
(use-package persp-mode
  ;; :ensure t
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

(defun restart-tabbar-mode ()
  (interactive)
  (tabbar-mode nil)
  (tabbar-mode 1))

(restart-tabbar-mode)
;; (pyim-restart-1 t)

(global-set-key (kbd "C-c v") 'view-mode)
(global-set-key (kbd "C-c g i") 'open-my-init-file)
(global-set-key (kbd "C-c g g") 'gtd)
(global-set-key (kbd "C-c g o") 'my-customize-org)
(global-set-key (kbd "<f2>") 'my-customize-local)
;; (define-key matlab-mode-map (kbd "M-j") nil)



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
;;   (if wiznote-formated-timestamp
;;       (insert wiznote-formated-timestamp)))


;; remove the prompt for killing emacsclient buffers 需要放在最后加载
;; http://stackoverflow.com/questions/268088/how-to-remove-the-prompt-for-killing-emacsclient-buffers
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)




;;; maximize-window: three ways do not work maybe because of the value of initial-frame-alist at the end of configuration
;;; way 1 not work
;; (custom-set-variables
;;  '(initial-frame-alist (quote ((fullscreen . maximized)))))
;; (w32-send-sys-command 61488)
;; (run-with-idle-timer 0.5 nil 'w32-send-sys-command 61488)
;; (toggle-frame-maximized)

;; way 2 not work
;; (defun w32-maximize-frame ()
;;   "Maximize the current frame (windows only)"
;;   (interactive)
;;   (w32-send-sys-command 61488))

;; (if (eq system-type 'windows-nt)
;;     (progn
;;       (add-hook 'window-setup-hook 'w32-maximize-frame t))
;;   (set-frame-parameter nil 'fullscreen 'maximized))

;;;way 3 works: from Emacs 随想 http://everet.org/thinking-of-emacs.html
;; ;; 实现全屏效果，快捷键为f11
;; (global-set-key [(control f11)] 'my-fullscreen)
;; (defun my-fullscreen ()
;;   (interactive)
;;   (x-send-client-message
;;    nil 0 nil "_NET_WM_STATE" 32
;;    '(2 "_NET_WM_STATE_FULLSCREEN" 0))
;;   )
;; ;; 最大化
;; (defun my-maximized ()
;;   (interactive)
;;   (if (fboundp 'x-send-client-message)
;;       (progn
;;         (x-send-client-message
;;          nil 0 nil "_NET_WM_STATE" 32
;;          '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
;;         (x-send-client-message
;;          nil 0 nil "_NET_WM_STATE" 32
;;          '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
;;         ))
;;   )
;; ;; 启动emacs时窗口最大化
;; (when window-system
;;   (my-maximized))


;;; Maximize window: this line must be put at the end of configuration
(setq-default initial-frame-alist (quote ((fullscreen . maximized))))

(provide 'init-local)
