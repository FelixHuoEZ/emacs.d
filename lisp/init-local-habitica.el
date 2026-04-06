;;; init-local-habitica.el --- Optional Habitica integration -*- lexical-binding: t -*-

(require 'subr-x)
(require 'init-local-private nil t)

(defvar hsk-habitica-uid nil
  "Local Habitica user ID loaded from `init-local-private.el'.")

(defvar hsk-habitica-token nil
  "Local Habitica API token loaded from `init-local-private.el'.")

(defun hsk/habitica-credentials-configured-p ()
  "Return non-nil when local Habitica credentials are configured."
  (and (stringp hsk-habitica-uid)
       (not (string-empty-p hsk-habitica-uid))
       (stringp hsk-habitica-token)
       (not (string-empty-p hsk-habitica-token))))

(use-package habitica
  :commands (habitica-tasks)
  :init
  (setq habitica-show-streak t)
  :config
  (if (hsk/habitica-credentials-configured-p)
      (setq habitica-uid hsk-habitica-uid
            habitica-token hsk-habitica-token)
    (message "Habitica credentials are missing in init-local-private.el.")))

(provide 'init-local-habitica)
