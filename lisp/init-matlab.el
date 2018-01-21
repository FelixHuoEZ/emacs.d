(use-package matlab-mode
  :mode "\\.m$"
  ;; :init
  ;; (add-to-list
  ;;  'auto-mode-alist
  ;;  '("\\.m$" . matlab-mode))
  ;; (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
  :config
  (setq matlab-indent-function t)
  ;; 不管怎么设置，都不能 unbind M-j，真是日了狗了，直接去改了 matlab.el
  ;; (define-key matlab-mode-map (kbd "M-j") nil)
  ;; (define-key matlab-mode-map (kbd "<M-j>") nil)
  ;; (unbind-key "M-j" matlab-mode-map)
  ;; (unbind-key "C-j" matlab-mode-map)
  ;; (add-hook 'matlab-mode-hook (lambda () (define-key matlab-mode-map (kbd "M-j") nil)))
  ;; (eval-after-load "matlab-mode"
  ;;   '(define-key matlab-mode-map (kbd "M-j") nil))
  ;; (define-key matlab-mode-map (kbd "M-j") nil)
  ;; :bind
  ;; (:map matlab-mode-map
  ;;       ("M-j" . nil))
  )

;;(require-package 'matlab-mode)
;;(define-key matlab-mode-map (kbd "M-j") nil)

;; ;; Load CEDET.
;; ;; See cedet/common/cedet.info for configuration details.
;; ;; IMPORTANT: For Emacs >= 23.2, you must place this *before* any
;; ;; CEDET component (including EIEIO) gets activated by another
;; ;; package (Gnus, auth-source, ...).
;; (require 'cedet)

;; ;; Replace path below to be where your matlab.el file is.
;; ;; (add-to-list 'load-path "d:/dev/emacs/matlab-emacs")
;; ;; (load-library "matlab-load")
;; (require 'matlab-load)

;; ;; Change path
;; (setq matlab-shell-command "c:/Programs Files/Matlab/R2014a/bin/matlab.exe -nosesktop -nojvm -nosplash")
;; (setq matlab-shell-command-switches '("10000" "20000"))
;; ;; the following is for non-session based evaluations
;; ;;(setq org-babel-matlab-shell-command "c:/Programs Files/matlabshell/matlabshell.cmd")

;; ;; Have libeng.dll on your PATH or use the following
;; (setenv "PATH" (concat "C:/Program Files/MATLAB/R2014a/bin/win64;" (getenv "PATH")))

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((matlab . t) (octave . t)
;;    ))

;; (setq org-babel-default-header-args:matlab
;;       '((:results . "output") (:session . "*MATLAB*")))

;; (setq matlab-shell-command "C:/Program Files/MATLAB/R2014a/bin/matlab.exe")
;; (setq matlab-shell-command-switches '())
;; (setq matlab-shell-echoes nil)
;; (require 'matlab-mode-autoloads)
(provide 'init-matlab)
