;;; init-ox-beamer



;;; Basic settings for export
;; (setq org-latex-create-formula-image-program 'imagemagick) ;;注意：由于imagemagick的程序 convert.exe 与 window格式转化程序 convert.exe 同名，故需要处理，否则或出错，查找convert.exe  evernote中的相关说明. 24.5中 org latex preview失效，24.2没有问题，与org版本无关，不知何种原因


;;; some html settings
(setq org-html-with-latex (quote verbatim)) ;; 方便word中mathtype处理latex代码
(setq org-html-extension "htm")             ;; 与 ox-twbs 输出区分


;;---- 在html输出中参考文献引用使用上标------------------------------------
(defadvice org-html-latex-fragment (around bibtex-citation)
  "Translate \"\\cite\" LaTeX fragments into HTML syntax.
Fallback to `html' back-end for other keywords."
  (let ((fragment (ad-get-arg 0)))
    (if (not (org-bibtex-citation-p fragment)) ad-do-it
      (setq ad-return-value
            (mapconcat
             (lambda (key)
               (let ((key (org-trim key)))
                 (format "<sup>[<a href=\"#%s\">%s</a>]</sup>" ;; 增加了 sup
                         key
                         (or (cdr (assoc key org-bibtex-html-entries-alist))
                             key))))
             (org-split-string (org-bibtex-get-citation-key fragment) ",")
             "")))))

(defadvice org-html-link (around bibtex-link)
  "Translate \"cite:\" type links into HTML syntax.
Fallback to `html' back-end for other types."
  (let ((link (ad-get-arg 0)))
    (if (not (org-bibtex-citation-p link)) ad-do-it
      (setq ad-return-value
            (mapconcat
             (lambda (key)
               (format "<sup>[<a href=\"#%s\">%s</a>]</sup>" ;; 增加了 sup
                       key
                       (or (cdr (assoc key org-bibtex-html-entries-alist))
                           key)))
             (org-split-string (org-bibtex-get-citation-key link)
                               "[ \t]*,[ \t]*")
             "")))))

;;---- 处理输出html换行会被解析成空格问题---------------------------------
(defadvice org-html-paragraph (before fsh-org-html-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to html."
  (let ((fixed-contents)
        (orig-contents (ad-get-arg 1))
        (reg-han "[[:multibyte:]]"))
    (setq fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                          "\\1\\2" orig-contents))
    (ad-set-arg 1 fixed-contents)
    ))

;;---- twbs 中文空格问题
(defadvice org-twbs-paragraph (before fsh-org-twbs-paragraph-advice
                                      (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to odt."
  (let ((fixed-contents)
        (orig-contents (ad-get-arg 1))
        (reg-han "[[:multibyte:]]"))
    (setq fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                          "\\1\\2" orig-contents))
    (ad-set-arg 1 fixed-contents)
    ))	

;;---- 处理输出odt换行会被解析成空格问题----------------------------------
(defadvice org-odt-paragraph (before fsh-org-odt-paragraph-advice
                                     (paragraph contents info) activate)
  "Join consecutive Chinese lines into a single long line without
unwanted space when exporting org-mode to odt."
  (let ((fixed-contents)
        (orig-contents (ad-get-arg 1))
        (reg-han "[[:multibyte:]]"))
    (setq fixed-contents (replace-regexp-in-string
                          (concat "\\(" reg-han "\\) *\n *\\(" reg-han "\\)")
                          "\\1\\2" orig-contents))
    (ad-set-arg 1 fixed-contents)
    ))



;;; latex export settings

;;LaTeX math mode ($…$) font color in org mode
(setq org-highlight-latex-and-related (quote (latex)))
;;add $...$ for math equations
(setq org-entities-user '(("$" "$" nil " " " " " " " ")))
(setq org-emphasis-alist (quote (("*" bold) ("/" italic) ("_" underline) ("=" org-verbatim verbatim) ("~" org-code verbatim) ("+" (:strike-through t)) ("$" math))))

;;default packages 这一部分需要根据 latex beamer 和具体场合进行详细考虑
(setq org-latex-default-packages-alist (quote (
                                               "\\usepackage[BoldFont]{xeCJK}
\\setCJKmainfont[BoldFont=AdobeHeitiStd-Regular]{AdobeSongStd-Light}
\\setCJKfamilyfont{song}{AdobeSongStd-Light}
\\setCJKfamilyfont{hei}{AdobeHeitiStd-Regular}
\\setCJKfamilyfont{kai}{AdobeKaitiStd-Regular}
\\setCJKfamilyfont{fs}{Sun Yat-sen Hsingshu}

\\renewcommand{\\contentsname}{\\centerline{\\textcolor{violet}{目 \\ \\ 录}}}    % 将Contents改为目录
\\renewcommand{\\abstractname}{摘 \\ \\ 要}      % 将Abstract改为摘要
\\renewcommand{\\refname}{参考文献}            % 将Reference改为参考文献
\\renewcommand\\tablename{表}
\\renewcommand\\figurename{图}
\\renewcommand{\\today}{\\number\\year 年 \\number\\month 月 \\number\\day 日}

\\usepackage[dvipsnames]{xcolor}
\\PassOptionsToPackage{colorlinks=true,citecolor=blue, linkcolor=violet, bookmarksdepth=4}{hyperref}

\\usepackage{lscape}
\\usepackage{indentfirst}
\\usepackage{textcomp}                      % provide many text symbols
\\usepackage{setspace}                      % 各种间距设置



% ---------------------------------Table------------------------------
\\usepackage{booktabs}
\\usepackage{array}                         % 提供表格中每一列的宽度及位置支持
\\usepackage{multirow}
\\usepackage{rotating}
\\newcolumntype{L}[1]{>{\\raggedright\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}
\\newcolumntype{C}[1]{>{\\centering\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}
\\newcolumntype{R}[1]{>{\\raggedleft\\let\\newline\\\\\\arraybackslash\\hspace{0pt}}m{#1}}

%\\sloppy
%\\linespread{1.0}                           % 设置行距
\\setlength{\\parindent}{22pt}
%\\setlength{\\parskip}{1ex plus 0.5ex minus 0.2ex}

"
                                               ("AUTO" "inputenc" t)
                                               ("T1" "fontenc" nil)
                                               ("" "fixltx2e" nil)
                                               ("" "graphicx" t)
                                               ("" "longtable" nil)
                                               ("" "float" nil)
                                               ("" "wrapfig" nil)
                                               ("" "soul" t)
                                               ("" "textcomp" nil)
                                               ("" "amsmath" t)
                                               ("" "marvosym" t)
                                               ("" "wasysym" t)
                                               ("" "latexsym" t)
                                               ("" "amssymb" t)
                                               ("" "lmodern,bm" t)
                                               ("" "hyperref" nil)
                                               ("" "listings" t)
                                               ("" "tikz" t)
                                               "
\\lstset{numbers=left, numberstyle=\\ttfamily\\tiny\\color{Gray}, stepnumber=1, numbersep=8pt,
  frame=leftline,
  framexleftmargin=0mm,
  rulecolor=\\color{CadetBlue},
  backgroundcolor=\\color{Periwinkle!20},
  stringstyle=\\color{CadetBlue},
  flexiblecolumns=false,
  aboveskip=5pt,
  belowskip=-5pt,
  language=R,
  basicstyle=\\ttfamily\\footnotesize,
  columns=flexible,
  keepspaces=true,
  breaklines=true,
  extendedchars=true,
  escapechar=\\%,
  texcl=true,
  showstringspaces=true,
  keywordstyle=\\bfseries,
  keywordstyle=\\color{Purple},
  xleftmargin=20pt,
  xrightmargin=10pt,
  morecomment=[s]{\\#}{\\#},
  commentstyle=\\color{OliveGreen!60}\\scriptsize,
  tabsize=4}
"
                                               "\\tolerance=1000")))


;;enable listings macro package for latex code blocks, if want color plz use color macro package
(setq org-latex-listings 'listings)
(setq org-latex-listings-options'(
                                  ("numbers" "left")
                                  ))


;; I do not know the real functionality of this function now
(defun my-org-setup ()
  (defun org-latex-utf8-fixbbl ()
    (org-latex-export-to-latex)
    (interactive)
    (if (get-buffer "*Latex-Compile*")
        (kill-buffer "*Latex-Compile*")
      )
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "del /s *.log *.aux *.eps *.dvi %s.out %s.exa %s.ilg %s.idx
%s.ind %s.lof %s.lot %s.toc %s.bbl %s.blg ctextemp_*.*"))
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "runpdf-org.bat " (substring (buffer-name) 0 -4) ) )
    (message (concat "runpdf-org.bat " (substring (buffer-name) 0 -4) )))

  (defun org-beamer-utf8-fixbbl ()
    (org-beamer-export-to-latex)
    (interactive)
    (if (get-buffer "*Latex-Compile*")
        (kill-buffer "*Latex-Compile*")
      )	
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "del /s *.log *.aux *.eps *.dvi %s.out %s.exa %s.ilg %s.idx
%s.ind %s.lof %s.lot %s.toc %s.bbl %s.blg ctextemp_*.*"))
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "runpdf-org.bat " (substring (buffer-name) 0 -4) ) )
    (message (concat "runpdf-org.bat " (substring (buffer-name) 0 -4) )))

  (defun org-view-pdf ()
    (interactive)
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".pdf"))
    (message (concat "Open " (substring (buffer-name) 0 -4) ".pdf")))

  (defun org-view-latex ()
    (interactive)
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".tex"))
    (message (concat "Open " (substring (buffer-name) 0 -4) ".tex")))

  (define-key org-mode-map "\M-n a" 'org-latex-utf8-fixbbl)
  (define-key org-mode-map "\M-n b" 'org-beamer-utf8-fixbbl)
  (define-key org-mode-map "\M-n \M-v" 'org-view-pdf)
  (define-key org-mode-map "\M-n l" 'org-view-latex)
  (define-key org-src-mode-map (kbd "C-c C-'") 'org-edit-src-exit)

  (setq org-src-fontify-natively t)
  (setq org-src-tab-acts-natively t)         
  (setq org-babel-inline-result-wrap "%s") ;;Formatting output of inline org-mode source blocks
  
  (defun org-insert-src-block (src-code-type)
    "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
    (interactive
     (let ((src-code-types
            '("R" "emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
              "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
              "octave" "oz" "plantuml" "sass" "screen" "sql" "awk" "ditaa"
              "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
              "scheme" "sqlite")))
       (list (ido-completing-read "Source code type: " src-code-types))))
    (progn
      (newline-and-indent)
      (insert (format "#+BEGIN_SRC %s\n" src-code-type))
      (newline-and-indent)
      (insert "#+END_SRC\n")
      (previous-line 2)
      (org-edit-src-code)))
  (define-key org-mode-map "\M-ni" 'org-insert-src-block)
  (define-key org-mode-map "\M-ne" 'org-edit-src-code)
  
  
  (defun org-html-twbs-export ()
    (org-twbs-export-to-html)
    (interactive)
    (start-process-shell-command "nil" "*Latex-Compile*"  (concat "open " (substring (buffer-name) 0 -4) ".html"))
    (message (concat "Open " (substring (buffer-name) 0 -4) ".html")))
  
  (define-key org-mode-map "\M-nh" 'org-html-twbs-export)
  )
(add-hook 'org-mode-hook 'my-org-setup t)


;;; reftex settings, I donnot know if org-ref will replace this one
;; (defun org-mode-reftex-setup ()
;;   (load-library "reftex")
;;   (and (buffer-file-name)
;;        (file-exists-p (buffer-file-name))
;;        (reftex-parse-all))
;;   (define-key org-mode-map (kbd "C-c )") 'reftex-reference)
;;   (define-key org-mode-map (kbd "C-c (") 'reftex-label)
;;   )
;; (add-hook 'org-mode-hook 'org-mode-reftex-setup)

;; (org-add-link-type "ebib" 'ebib)




(defun restart-org ()
  (defvar val (quote (ascii beamer html icalendar latex odt)))
  (progn
    (setq org-export--registered-backends
          (org-remove-if-not
           (lambda (backend)
             (let ((name (org-export-backend-name backend)))
               (or (memq name val)
                   (catch 'parentp
                     (dolist (b val)
                       (and (org-export-derived-backend-p b name)
                            (throw 'parentp t)))))))
           org-export--registered-backends))
    (let ((new-list (mapcar 'org-export-backend-name
                            org-export--registered-backends)))
      (dolist (backend val)
        (cond
         ((not (load (format "ox-%s" backend) t t))
          (message "Problems while trying to load export back-end `%s'"
                   backend))
         ((not (memq backend new-list)) (push backend new-list))))
      (set-default 'org-export-backends new-list)))
  (interactive)
  )

(provide 'init-ox-beamer)
