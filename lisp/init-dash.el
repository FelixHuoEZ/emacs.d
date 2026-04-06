;; Support for the http://kapeli.com/dash documentation browser

(defun sanityinc/dash-installed-p ()
  "Return t if Dash is installed on this machine, or nil otherwise."
  (let ((lsregister "/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"))
    (and (file-executable-p lsregister)
         (not (string-equal
               ""
               (shell-command-to-string
                (concat lsregister " -dump|grep com.kapeli.dash")))))))

(defun sanityinc/dash-at-point ()
  "Open the symbol at point in Dash, installing support on demand."
  (interactive)
  (when (and *is-a-mac*
             (not (package-installed-p 'dash-at-point))
             (sanityinc/dash-installed-p))
    (require-package 'dash-at-point))
  (unless (require 'dash-at-point nil t)
    (user-error "dash-at-point is not installed"))
  (call-interactively #'dash-at-point))

(when *is-a-mac*
  (global-set-key (kbd "C-c D") #'sanityinc/dash-at-point))

(provide 'init-dash)
