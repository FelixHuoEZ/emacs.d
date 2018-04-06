(add-hook 'after-init-hook 'recentf-mode)
(setq-default
 recentf-max-saved-items 1000
 recentf-exclude '("/tmp/" "/ssh:"))
(global-set-key "\C-x\ j" 'recentf-open-files)

(provide 'init-recentf)
