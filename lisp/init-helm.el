;;; helm
(require-package 'helm)
(require 'helm-config)
(require 'helm-eshell)
;(require 'helm-dash)

(helm-mode 1)
(helm-autoresize-mode 1)
;(setq helm-ff-auto-update-initial-value nil)    ; 禁止自动补全

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-s") 'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h g") 'helm-google-suggest)

(setq helm-split-window-in-side-p           t
      helm-move-to-line-cycle-in-source     t
      helm-ff-search-library-in-sexp        t
      helm-M-x-fuzzy-match                  t   ; 模糊搜索
      helm-buffers-fuzzy-matching           t
      helm-locate-fuzzy-match               t
      helm-recentf-fuzzy-match              t
      helm-scroll-amount                    8
      helm-ff-file-name-history-use-recentf t
      helm-semantic-fuzzy-match             t   ; 键入 C-c h i 进入，列出当前文件章节/节点列表，选择后跳转到指定章节/节点。
      helm-imenu-fuzzy-match                t   ; 键入 C-c h i 进入，列出当前文件章节/节点列表，选择后跳转到指定章节/节点。
      helm-apropos-fuzzy-match              t   ; 显示 Emacs 指定命令简述(包括可用函数、变量、属性、功能等等)，可模糊/正则搜索。
      helm-lisp-fuzzy-completion            t   ; 提供 lisp 命令补全/候选，使用该命令之前必须先键入几个 lisp 关键词，哪怕是一个括号。
      )

(add-hook 'eshell-mode-hook                     ; 查看 eshell 命令历史。
          #'(lambda ()
              (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))

(provide 'init-helm)
