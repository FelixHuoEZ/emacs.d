(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(use-package pip-requirements)

(use-package py-autopep8
  :config
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
  )

(use-package elpy
  :config
  (setq elpy-rpc-python-command "python")
  ;; (setq elpy-rpc-python-command "pythonw")
  ;; (elpy-use-ipython)
  (elpy-enable)
  ;; (setq python-shell-unbuffered nil)
  ;; (setq python-shell-prompt-detect-failure-warning nil)
  (define-key elpy-mode-map (kbd "C-x C-e") 'elpy-shell-send-statement-and-step)
  )

(use-package jedi)


(use-package flycheck
  :config
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  )


(use-package ein
  :config
  ;; (if (eq system-type 'windows-nt)
  ;;     (elpy-use-ipython))
  )

(when (maybe-require-package 'anaconda-mode)
  (after-load 'python
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))
  (when (maybe-require-package 'company-anaconda)
    (after-load 'company
      (add-hook 'python-mode-hook
                (lambda () (sanityinc/local-push-company-backend 'company-anaconda))))))

(provide 'init-python-mode)
