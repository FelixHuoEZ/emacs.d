;;; early-init.el --- Early startup settings -*- lexical-binding: t -*-

;; Keep startup work as small as possible, then restore the defaults once the
;; main init has finished loading.
(defvar hsk--startup-file-name-handler-alist file-name-handler-alist)
(defvar hsk--startup-gc-cons-threshold gc-cons-threshold)
(defvar hsk--startup-gc-cons-percentage gc-cons-percentage)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil
      package-enable-at-startup nil
      frame-inhibit-implied-resize t
      load-prefer-newer noninteractive)

(defun hsk/reset-startup-optimizations ()
  "Restore startup-only optimizations."
  (setq file-name-handler-alist hsk--startup-file-name-handler-alist
        gc-cons-threshold hsk--startup-gc-cons-threshold
        gc-cons-percentage hsk--startup-gc-cons-percentage))

(add-hook 'emacs-startup-hook #'hsk/reset-startup-optimizations 101)

;;; early-init.el ends here
