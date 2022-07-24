(require-package 'color-theme-sanityinc-solarized)
(require-package 'color-theme-sanityinc-tomorrow)

;; (use-package solarized-theme
;;   :config
;;   (load-theme 'solarized-light t)
;;   (let ((line (face-attribute 'mode-line :underline)))
;;  (set-face-attribute 'mode-line          nil :overline   line)
;;  (set-face-attribute 'mode-line-inactive nil :overline   line)
;;  (set-face-attribute 'mode-line-inactive nil :underline  line)
;;  (set-face-attribute 'mode-line          nil :box        nil)
;;  (set-face-attribute 'mode-line-inactive nil :box        nil)
;;  (set-face-attribute 'mode-line-inactive nil :background "#f9f2d9")))

(use-package moody
  :config
  (setq x-underline-at-descent-line t)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode)
  (moody-replace-eldoc-minibuffer-message-function))



;; If you don't customize it, this is the theme you get.
;; (setq-default custom-enabled-themes '(sanityinc-tomorrow-bright))
(setq-default custom-enabled-themes '(sanityinc-solarized-light))

;; Ensure that themes will be applied even if they have not been customized
(defun reapply-themes ()
  "Forcibly load the themes listed in `custom-enabled-themes'."
  (dolist (theme custom-enabled-themes)
    (unless (custom-theme-p theme)
      (load-theme theme)))
  (custom-set-variables `(custom-enabled-themes (quote ,custom-enabled-themes))))

(add-hook 'after-init-hook 'reapply-themes)

;; (reapply-themes)

;;------------------------------------------------------------------------------
;; Toggle between light and dark
;;------------------------------------------------------------------------------
(defun light ()
  "Activate a light color theme."
  (interactive)
  (setq custom-enabled-themes '(sanityinc-tomorrow-day))
  (reapply-themes))

(defun dark ()
  "Activate a dark color theme."
  (interactive)
  (setq custom-enabled-themes '(sanityinc-tomorrow-bright))
  (reapply-themes))


(maybe-require-package 'dimmer)


(provide 'init-themes)
