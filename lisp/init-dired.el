(require-package 'dired+)
(require-package 'dired-sort)

(setq-default diredp-hide-details-initially-flag nil
              dired-dwim-target t)

;; Prefer g-prefixed coreutils version of standard utilities when available
(let ((gls (executable-find "gls")))
  (when gls (setq insert-directory-program gls)))

(after-load 'dired
  (require 'dired+)
  (require 'dired-sort)
  (when (fboundp 'global-dired-hide-details-mode)
    (global-dired-hide-details-mode -1))
  (setq dired-recursive-deletes 'top)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  ;; (add-hook 'dired-mode-hook
  ;;           (lambda () (guide-key/add-local-guide-key-sequence "%"))))
  )
(when (maybe-require-package 'diff-hl)
  (after-load 'dired
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))


;;; 以下为子龙山人的部分配置
;; 删除目录的时候， 取消 Emacs 询问是否递归删除或拷贝
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)

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
