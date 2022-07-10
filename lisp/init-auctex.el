;;; auctex

;; (load "auctex.el" nil t t)
(require-package 'auctex)
;; (load "preview-latex.el" nil t t)
;; (if (string-equal system-type "windows-nt")
;;     (require 'tex-mik))
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(mapc (lambda (mode)
        (add-hook 'LaTeX-mode-hook mode))
      (list 'auto-complete-mode
            'auto-fill-mode
            'LaTeX-math-mode
            'turn-on-reftex
            'linum-mode))
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-auto-untabify t     ; remove all tabs before saving
                  TeX-engine 'xetex       ; use xelatex default
                  TeX-show-compilation t) ; display compilation windows
            (TeX-global-PDF-mode t)       ; PDF mode enable, not plain
            (setq TeX-save-query nil)
            (imenu-add-menubar-index)
            (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))

;; XeLaTeX
(add-hook 'LaTeX-mode-hook (lambda()
                             ;; (add-to-list 'TeX-command-list '("LaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
                             (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
                             ;; (setq TeX-command-default "XeLaTeX")
                             (setq TeX-save-query  nil )
                             (setq TeX-show-compilation t)))

;; run latex compiler with option -shell-escape
(setq LaTeX-command-style '(("" "%(PDF)%(latex) -shell-escape %S%(PDFout)")))

;; use Sumatra PDF to preview pdf
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-view-program-list
      '(
        ("XDG" "xdg-open %o")
        ("Evince" "evince %o")
        ("SumatraPDF" ("SumatraPDF.exe -reuse-instance" (mode-io-correlate " -forward-search %b %n ") " %o"))
        ("Okular" "okular --unique %o" )
        ("Firefox" "firefox %o")
        ("Chrome" "chromium %o")))



(cond
 ((eq system-type 'windows-nt)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-view-program-selection '((output-pdf "SumatraPDF")
                                                 (output-dvi "Yap"))))))

 ((eq system-type 'gnu/linux)
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq TeX-view-program-selection '((output-pdf "Okular")
                                                 (output-dvi "Okular")))))))

;; set ghostscript for latex
;; (setq preview-gs-command "D:/Program Files/gs/gs9.19/bin/gswin64c")

(provide 'init-auctex)
