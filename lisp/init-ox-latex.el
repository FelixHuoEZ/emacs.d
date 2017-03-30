;;; init org-export-latex


;;; org-export-latex-pdf

;; require
(require 'org)
(require 'ox)
(require 'ox-latex)

;; latex
;; (setq org-latex-coding-system 'utf-8) ; I do not know what the sentence do
(setq org-export-allow-bind-keywords t)

;; booktabs usage, table centering and removal of every horizontal rule but the first one (in a "table.el" table only)
(setq org-latex-tables-booktabs t)
(setq org-latex-tables-centered t)

;; Export backends
(setq org-export-backends (quote (ascii beamer html icalendar latex odt)))

;; cdlatex configuration
(require-package 'cdlatex)
(require 'cdlatex)
(add-hook 'org-mode-hook 'turn-on-org-cdlatex)



;; 不要在latex输出文件中插入\maketitle
;; (setq org-latex-title-command "")
(setq org-latex-title-command "\\maketitle")
(setq org-latex-toc-command "\\tableofcontents")
;; (setq org-latex-date-format "%Y-%m-%d") ; I do not know what the sentence do

;; (setq org-export-with-LaTeX-fragments 'imagemagick)
;; (setq org-latex-create-formula-image-program 'imagemagick)


(setq org-latex-commands '( ("latexmk -xelatex -g -pdf %b.tex"
                             "bibtex %b"
                             "latexmk -xelatex -g -pdf %b.tex"
                             "latexmk -xelatex -g -pdf %b.tex")
                            ("xelatex -interaction nonstopmode -output-directory %o %f")))

;; (setq org-latex-commands '( ("latexmk -xelatex -g -pdf %f"
;;                              "bibtex %b"
;;                              "latexmk -xelatex -g -pdf %f"
;;                              "latexmk -xelatex -g -pdf %f")
;;                             ("xelatex -interaction nonstopmode -output-directory %o %f")))

;; (setq org-latex-commands '(("xelatex -interaction nonstopmode -output-directory %o %f"
;;                             "bibtex %b"
;;                             "xelatex -interaction nonstopmode -output-directory %o %f"
;;                             "xelatex -interaction nonstopmode -output-directory %o %f")
;;                            ("xelatex -interaction nonstopmode -output-directory %o %f")))

;; (setq org-latex-commands '(("latex -interaction nonstopmode -output-directory %o %f"
;;                             "bibtex %b"
;;                             "latex -interaction nonstopmode -output-directory %o %f"
;;                             "latex -interaction nonstopmode -output-directory %o %f")
;;                            ("latex -interaction nonstopmode -output-directory %o %f")))

;; (setq org-pdflatex-commands '(("pdflatex -interaction nonstopmode -output-directory %o %f"
;;                             "bibtex %b"
;;                             "pdflatex -interaction nonstopmode -output-directory %o %f"
;;                             "pdflatex -interaction nonstopmode -output-directory %o %f")
;;                            ("pdflatex -interaction nonstopmode -output-directory %o %f")))

;; 设置org mode to latex 的引擎为 xelatex
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-to-pdf-process '("xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f" "xelatex -interaction nonstopmode -output-directory %o %f"))

;; latex class redefinition in org
;; ctex for Chinese
(add-to-list 'org-latex-classes
             '("ctexart"
               "\\documentclass[fontset=none,UTF8,a4paper,zihao=-4]{ctexart}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}
\\setCJKmainfont[ItalicFont={KaiTi_GB2312}]{SimSun}
\\setCJKsansfont{WenQuanYi Micro Hei}
\\setCJKmonofont{WenQuanYi Micro Hei}
\\setmainfont{Times New Roman}   %% 若不指定则使用Tex的默认英文衬线字体
\\setmonofont{Monaco}   % 英文等宽字体，需要系统安装 Monaco
\\setsansfont{Trebuchet MS} % 英文无衬线字体"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-latex-classes
             '("ctexrep"
               "\\documentclass[fontset=none,UTF8,a4paper,zihao=-4]{ctexrep}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
               ("\\part{%s}" . "\\part*{%s}")
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes
             '("ctexbook"
               "\\documentclass[fontset=none,UTF8,a4paper,zihao=-4]{ctexbook}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
               ("\\part{%s}" . "\\part*{%s}")
               ("\\chapter{%s}" . "\\chapter*{%s}")
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")))

(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass[presentation]{beamer}
\\usepackage[UTF8,space]{ctex}
[NO-DEFAULT-PACKAGES]
[PACKAGES]
[EXTRA]
"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ))

;; latex for English
(add-to-list 'org-latex-classes
             '("article"
               "\\documentclass{arcitle}
\\usepackage[top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm]{geometry}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


;;set default latex class for org file
(setq org-latex-default-class "ctexart")


;; org不建议自定义org-latex-default-package-alist变量
;; (setq org-latex-default-packages-alist
;;       '(("" "fixltx2e" nil)
;;         ("" "graphicx" t)
;;         ("" "longtable" nil)
;;         ("" "float" nil)
;;         ("" "wrapfig" nil)
;;         ("" "rotating" nil)
;;         ("" "amsmath" t)
;;         ("" "textcomp" t)
;;         ("" "marvosym" t)
;;         ("" "wasysym" t)
;;         ("" "amssymb" t)
;;         ("" "hyperref" nil)
;;         "\\tolerance=1000"))

;; org不建议自定义org-latex-default-package-alist变量，但"inputenc" and "fontenc"两个宏包似乎和xelatex有冲突，调整默认值！
;; 如果直接设置该变量，可以直接去除这三个 cell，不需要下面这三段代码
;; (setf org-latex-default-packages-alist
;;       (remove '("AUTO" "inputenc" t) org-latex-default-packages-alist))
(setf org-latex-default-packages-alist
      (remove '("T1" "fontenc" t) org-latex-default-packages-alist))
;; (setf org-latex-default-packages-alist
;;       (remove '("normalem" "ulem" t) org-latex-default-packages-alist))


;; modify hyperref options in default packages alist
(setf org-latex-default-packages-alist
      (remove '("" "hyperref" nil) org-latex-default-packages-alist))
(add-to-list 'org-latex-default-packages-alist '("colorlinks=true,linkcolor=blue,citecolor=blue" "hyperref" nil))

(add-to-list 'org-latex-default-packages-alist '("" "float" nil))
(add-to-list 'org-latex-default-packages-alist '("" "titletoc" nil))
(add-to-list 'org-latex-default-packages-alist '("" "titling" nil))

(setq  org-latex-packages-alist
       '(("" "tikz" nil)
         ("" "CJKulem" nil)
         ("" "pifont" nil)
         ("" "xltxtra" t)
         ("" "fontspec" nil)
         ("" "xunicode" nil)
         ;; ("" "graphicx" nil)
         ;; ("top=2.54cm, bottom=2.54cm, left=3.17cm, right=3.17cm" "geometry" nil)
         ("" "caption" nil)
         ("" "multicol" nil)
         ("" "multirow" nil)
         ("" "bm" nil)
         ("" "esint" nil)
         ("" "lscape" nil)
         ("" "fancyhdr" nil)
         ;; ("" "titlesec" nil)  titlesec conflict with titling for the command thetitle
         ;; ("" "cite" nil)
         ("numbers,square,super,sort&compress" "natbib" nil)
         ("" "listings" nil)
         "
\\newcommand{\\circlenum}[1]{\\ding{\\numexpr171+#1}}
\\DeclareSymbolFont{matha}{OML}{txmi}{m}{it}% txfonts
\\DeclareMathSymbol{\\varv}{\\mathord}{matha}{118}
\\makeatletter
\\newcommand*{\\fullcite}[2][]{%
\\begingroup
\\let\\NAT@mbox=\\mbox
\\let\\@cite\\NAT@citenum
\\let\\NAT@space\\NAT@spacechar
\\let\\NAT@super@kern\\relax
\\renewcommand\\NAT@open{[}%
\\renewcommand\\NAT@close{]}%
\\cite[#1]{#2}%
\\endgroup
}
\\makeatother
"))

;; latex公式预览，调整latex预览时使用的header，默认使用ctexart类。这一部分我还没有搞懂是什么意思
(setq org-format-latex-header
      (replace-regexp-in-string
       "\\\\documentclass{.*}"
       "\\\\documentclass[nofonts,UTF8]{ctexart}"
       org-format-latex-header))

(defun eh-org-latex-compile (orig-fun texfile &optional snippet)
  (let ((org-latex-pdf-process
         (if snippet (car (cdr org-latex-commands))
           (car org-latex-commands))))
    (funcall orig-fun texfile snippet)))

(advice-add 'org-latex-compile :around #'eh-org-latex-compile)


;; (defun eh-org-latex-compile (orig-fun texfile &optional snippet)
;;   (let ((org-latex-pdf-process
;;          (if snippet
;;              (plist-get (cdr (assoc "fragment" org-latex-commands)) :pdf)
;;            (plist-get (cdr (assoc "default" org-latex-commands)) :pdf))))
;;     (funcall orig-fun texfile snippet))
;;   (funcall orig-fun texfile snippet))

;; (advice-add 'org-latex-compile :around #'eh-org-latex-compile)


;; Use XeLaTeX to export PDF in Org-mode
;; (setq org-latex-pdf-process
;;       '("xelatex -interaction nonstopmode -output-directory %o %f"
;;         "xelatex -interaction nonstopmode -output-directory %o %f"
;;         "xelatex -interaction nonstopmode -output-directory %o %f"))

;; see the variable org-entities for the complete list.
;; ‘\-’ is treated as a shy hyphen, and ‘--’, ‘---’, and ‘...’ are all converted into special commands creating hyphens of different lengths or a compact set of dots.
;; display entities as UTF-8 characters for all org documents, use the following command, or use #+STARTUP: entitiespretty in the header of the specified file
;; use "C-c C-x \" to toggle the option
(setq org-pretty-entities nil)
;; set dvipng as the deault program to previes inline latex quations
;; (setq org-latex-create-formula-image-program 'imagemagick)
(setq org-latex-create-formula-image-program 'dvipng)


(provide 'init-ox-latex)
