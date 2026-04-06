(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(use-package pip-requirements
  :mode ("requirements\\(?:\\.in\\)?\\'" . pip-requirements-mode))

(use-package py-autopep8
  :hook (elpy-mode . py-autopep8-enable-on-save))

(use-package elpy
  :defer t
  :hook (python-mode . elpy-enable)
  :init
  (setq elpy-rpc-python-command "python")
  ;; (setq elpy-rpc-python-command "pythonw")
  ;; use jupyter
  (setq python-shell-interpreter "jupyter"
        python-shell-interpreter-args "console --simple-prompt"
        python-shell-prompt-detect-failure-warning nil)
  :config
  ;; (add-to-list 'python-shell-completion-native-disabled-interpreters
  ;;              "jupyter")
  ;; use ipython
  ;; (if (eq system-type 'windows-nt)
  ;;     (setq python-shell-interpreter "ipython"
  ;; python-shell-interpreter-args "-i --simple-prompt"))
  ;; (setq python-shell-unbuffered nil)
  ;; (setq python-shell-prompt-detect-failure-warning nil)
  (define-key elpy-mode-map (kbd "C-x C-e") 'elpy-shell-send-statement-and-step))

(use-package jedi
  :defer t)


(use-package flycheck
  :after elpy
  :config
  (when (require 'flycheck nil t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))


(use-package ein
  :defer t)

(when (maybe-require-package 'anaconda-mode)
  (after-load 'python
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))
  (when (maybe-require-package 'company-anaconda)
    (after-load 'company
      (add-hook 'python-mode-hook
                (lambda () (sanityinc/local-push-company-backend 'company-anaconda))))))

(provide 'init-python-mode)
