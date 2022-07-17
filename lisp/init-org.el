;; (maybe-require-package 'org-fstree)

(use-package org
  :ensure nil
  :commands (org-dynamic-block-define)
  :custom-face (org-ellipsis ((t (:foreground nil))))
  ;; :pretty-hydra
  ;; ((:title (pretty-hydra-title "Org Template" 'fileicon "org" :face 'all-the-icons-green :height 1.1 :v-adjust 0.0)
  ;;          :color blue :quit-key "q")
  ;;  ("Basic"
  ;;   (("a" (hot-expand "<a") "ascii")
  ;;    ("c" (hot-expand "<c") "center")
  ;;    ("C" (hot-expand "<C") "comment")
  ;;    ("e" (hot-expand "<e") "example")
  ;;    ("E" (hot-expand "<E") "export")
  ;;    ("h" (hot-expand "<h") "html")
  ;;    ("l" (hot-expand "<l") "latex")
  ;;    ("n" (hot-expand "<n") "note")
  ;;    ("o" (hot-expand "<q") "quote")
  ;;    ("v" (hot-expand "<v") "verse"))
  ;;   "Head"
  ;;   (("i" (hot-expand "<i") "index")
  ;;    ("A" (hot-expand "<A") "ASCII")
  ;;    ("I" (hot-expand "<I") "INCLUDE")
  ;;    ("H" (hot-expand "<H") "HTML")
  ;;    ("L" (hot-expand "<L") "LaTeX"))
  ;;   "Source"
  ;;   (("s" (hot-expand "<s") "src")
  ;;    ("m" (hot-expand "<s" "emacs-lisp") "emacs-lisp")
  ;;    ("y" (hot-expand "<s" "python :results output") "python")
  ;;    ("p" (hot-expand "<s" "perl") "perl")
  ;;    ("r" (hot-expand "<s" "ruby") "ruby")
  ;;    ("S" (hot-expand "<s" "sh") "sh")
  ;;    ("g" (hot-expand "<s" "go :imports '\(\"fmt\"\)") "golang"))
  ;;   "Misc"
  ;;   (("u" (hot-expand "<s" "plantuml :file CHANGE.png") "plantuml")
  ;;    ("Y" (hot-expand "<s" "ipython :session :exports both :results raw drawer\n$0") "ipython")
  ;;    ("P" (progn
  ;;           (insert "#+HEADERS: :results output :exports both :shebang \"#!/usr/bin/env perl\"\n")
  ;;           (hot-expand "<s" "perl")) "Perl tangled")
  ;;    ("<" self-insert-command "ins"))))
  :bind (("C-c a" . org-agenda)
         ("C-c b" . org-switchb)
         ("C-c x" . org-capture)
         :map org-mode-map
         ("<" . (lambda ()
                  "Insert org template."
                  (interactive)
                  (if (or (region-active-p) (looking-back "^\s*" 1))
                      (org-hydra/body)
                    (self-insert-command 1))))
         :map org-mode-map
         ("C-M-<up>" . org-up-element)
         ("C-c p" . org-open-exported-pdf)
         ("C-<tab>" . nil)
         ("C-S-<tab>" . nil))
  :hook (((org-babel-after-execute org-mode) . org-redisplay-inline-images) ; display image
         (org-mode . (lambda ()
                       "Beautify org symbols."
                       (when centaur-prettify-org-symbols-alist
                         (if prettify-symbols-alist
                             (push centaur-prettify-org-symbols-alist prettify-symbols-alist)
                           (setq prettify-symbols-alist centaur-prettify-org-symbols-alist)))
                       (prettify-symbols-mode 1)))
         (org-indent-mode . (lambda()
                              (diminish 'org-indent-mode)
                              ;; HACK: Prevent text moving around while using brackets
                              ;; @see https://github.com/seagle0128/.emacs.d/issues/88
                              (make-variable-buffer-local 'show-paren-mode)
                              (setq show-paren-mode nil))))
  :config
  ;; For hydra
  (defun hot-expand (str &optional mod)
    "Expand org template.

STR is a structure template string recognised by org like <s. MOD is a
string with additional parameters to add the begin line of the
structure element. HEADER string includes more parameters that are
prepended to the element after the #+HEADER: tag."
    (let (text)
      (when (region-active-p)
        (setq text (buffer-substring (region-beginning) (region-end)))
        (delete-region (region-beginning) (region-end)))
      (insert str)
      (if (fboundp 'org-try-structure-completion)
          (org-try-structure-completion) ; < org 9
        (progn
          ;; New template expansion since org 9
          (require 'org-tempo nil t)
          (org-tempo-complete-tag)))
      (when mod (insert mod) (forward-line))
      (when text (insert text))))

  (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n")
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

  ;; [[http://emacs.stackexchange.com/questions/13820/inline-verbatim-and-code-with-quotes-in-org-mode/13828#13828][Inline verbatim and code with quotes in Org-mode - Emacs Stack Exchange]]

  ;;----------------- 设置各级标题样式 ----------------------
  (set-face-attribute 'org-level-1 nil :height 1.1 :bold t :foreground "yellow4")
  (set-face-attribute 'org-level-2 nil :height 1.1 :bold t)
  (set-face-attribute 'org-level-3 nil :height 1.0 :bold t)


  ;; To speed up startup, don't put to init section
  (setq org-modules nil                 ; Faster loading
        org-directory centaur-org-directory
        org-priority-faces '((?A . error)
                             (?B . warning)
                             (?C . success))

        ;; Agenda styling
        org-agenda-files `(,centaur-org-directory)
        org-agenda-block-separator ?─
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "⭠ now ─────────────────────────────────────────────────"

        org-tags-column -80
        org-log-done 'time
        org-catch-invisible-edits 'smart
        org-startup-indented t
        org-ellipsis (if (char-displayable-p ?⏷) "\t⏷" nil)
        org-pretty-entities nil
        org-hide-emphasis-markers t
        visual-line-mode t
        org-edit-timestamp-down-means-later t
        org-archive-mark-done nil
        org-archive-location "%s_archive::* Archive"
        org-export-coding-system 'utf-8
        org-fast-tag-selection-single-key 'expert
        org-html-validation-link nil
        org-export-kill-product-buffer-when-displayed t
        org-support-shift-select t
        ;;highlight code in src code block
        org-src-fontify-natively t

        )

  ;; Add new template
  (add-to-list 'org-structure-template-alist '("n" . "note"))

  ;; Use embedded webkit browser if possible
  (when (featurep 'xwidget-internal)
    (push '("\\.\\(x?html?\\|pdf\\)\\'"
            .
            (lambda (file _link)
              (centaur-webkit-browse-url (concat "file://" file) t)))
          org-file-apps))

  ;; Add gfm/md backends
  (use-package ox-gfm)
  (add-to-list 'org-export-backends 'md)

  (with-eval-after-load 'counsel
    (bind-key [remap org-set-tags-command] #'counsel-org-tag org-mode-map))

  ;; Prettify UI
  (if emacs/>=27p
      (use-package org-modern
        :hook ((org-mode . org-modern-mode)
               (org-agenda-finalize . org-modern-agenda)
               (org-modern-mode . (lambda ()
                                    "Adapt `org-modern-mode'."
                                    ;; Disable Prettify Symbols mode
                                    (setq prettify-symbols-alist nil)
                                    (prettify-symbols-mode -1)))))
    (progn
      (use-package org-superstar
        :if (and (display-graphic-p) (char-displayable-p ?◉))
        :hook (org-mode . org-superstar-mode)
        :init (setq org-superstar-headline-bullets-list '("◉""○""◈""◇""⁕")))
      (use-package org-fancy-priorities
        :diminish
        :hook (org-mode . org-fancy-priorities-mode)
        :init (setq org-fancy-priorities-list
                    (if (and (display-graphic-p) (char-displayable-p ?🅐))
                        '("🅐" "🅑" "🅒" "🅓")
                      '("HIGH" "MEDIUM" "LOW" "OPTIONAL"))))))

  ;; Babel
  (setq org-confirm-babel-evaluate nil
        org-src-fontify-natively t
        org-src-tab-acts-natively t)

  (defvar load-language-alist '(
                                ;; (R  . t)
                                (ditaa . t)
                                ;; (asymptote . t)
                                (dot . t)
                                (gnuplot . t)
                                (haskell . nil)
                                (latex . t)
                                ;; (ledger . t)
                                (ocaml . nil)
                                (octave . t)
                                (screen . nil)
                                ;; (,(if (locate-library "ob-sh") 'sh 'shell) . t)
                                (sql . nil)
                                (sqlite . t)
                                (emacs-lisp . t)
                                (perl       . t)
                                (python     . t)
                                (ruby       . t)
                                (js         . t)
                                (css        . t)
                                (sass       . t)
                                (C          . t)
                                (java       . t)
                                (plantuml   . t)))

  ;; ob-sh renamed to ob-shell since 26.1.
  (cl-pushnew '(shell . t) load-language-alist)

  (use-package ob-go
    :init (cl-pushnew '(go . t) load-language-alist))

  (use-package ob-rust
    :init (cl-pushnew '(rust . t) load-language-alist))

  ;; Install: npm install -g @mermaid-js/mermaid-cli
  (use-package ob-mermaid
    :init (cl-pushnew '(mermaid . t) load-language-alist))

  (org-babel-do-load-languages 'org-babel-load-languages
                               load-language-alist)

  ;; Rich text clipboard
  (use-package org-rich-yank
    :bind (:map org-mode-map
                ("C-M-y" . org-rich-yank)))

  ;; Table of contents
  (use-package toc-org
    :hook (org-mode . toc-org-mode))

  ;; Export text/html MIME emails
  (use-package org-mime
    :bind (:map message-mode-map
                ("C-c M-o" . org-mime-htmlize)
                :map org-mode-map
                ("C-c M-o" . org-mime-org-buffer-htmlize)))

  ;; Add graphical view of agenda
  (use-package org-timeline
    :hook (org-agenda-finalize . org-timeline-insert-timeline))

  (when emacs/>=27p
    ;; Auto-toggle Org LaTeX fragments
    (use-package org-fragtog
      :diminish
      :hook (org-mode . org-fragtog-mode))

    ;; Preview
    (use-package org-preview-html
      :diminish
      :bind (:map org-mode-map
                  ("C-c C-h" . org-preview-html-mode))
      :init (when (featurep 'xwidget-internal)
              (setq org-preview-html-viewer 'xwidget))))

  ;; Presentation
  (use-package org-tree-slide
    :diminish
    :functions (org-display-inline-images
                org-remove-inline-images)
    :bind (:map org-mode-map
                ("s-<f7>" . org-tree-slide-mode)
                :map org-tree-slide-mode-map
                ("<left>" . org-tree-slide-move-previous-tree)
                ("<right>" . org-tree-slide-move-next-tree)
                ("S-SPC" . org-tree-slide-move-previous-tree)
                ("SPC" . org-tree-slide-move-next-tree))
    :hook ((org-tree-slide-play . (lambda ()
                                    (text-scale-increase 4)
                                    (org-display-inline-images)
                                    (read-only-mode 1)))
           (org-tree-slide-stop . (lambda ()
                                    (text-scale-increase 0)
                                    (org-remove-inline-images)
                                    (read-only-mode -1))))
    :init (setq org-tree-slide-header nil
                org-tree-slide-slide-in-effect t
                org-tree-slide-heading-emphasis nil
                org-tree-slide-cursor-init t
                org-tree-slide-modeline-display 'outside
                org-tree-slide-skip-done nil
                org-tree-slide-skip-comments t
                org-tree-slide-skip-outline-level 3))

  ;; org-attach
  (require 'org-attach-git)
  (setq org-attach-dir-relative t)
  (setq org-attach-use-inheritance t)
  (setq org-attach-id-dir "attach/")

  ;; attachment 关键字对应图片导出链接不对，hook 一下
  ;; https://emacs-china.org/t/org-mode-attachment-html/15522/2
  (defun my/org-attach-expand-links (_)
    (save-excursion
      (while (re-search-forward "attachment:" nil t)
        (let ((link (org-element-context)))
          (when (and (eq 'link (org-element-type link))
                     (string-equal "attachment"
                                   (org-element-property :type link)))
            (let* ((description (and (org-element-property :contents-begin link)
                                     (buffer-substring-no-properties
                                      (org-element-property :contents-begin link)
                                      (org-element-property :contents-end link))))
                   (file (org-element-property :path link))
                   (fullpath (org-attach-expand file))
                   (current-dir (file-name-directory (or default-directory
                                                         buffer-file-name)))
                   (relpath (file-relative-name fullpath current-dir))
                   (new-link ;;(format "[[file:%s][file:%s]]" relpath relpath)))
                    (org-link-make-string
                     (concat "file:" relpath)
                     description)))
              (goto-char (org-element-property :end link))
              (skip-chars-backward " \t")
              (delete-region (org-element-property :begin link) (point))
              (insert new-link)))))))
  (remove-hook 'org-export-before-parsing-hook 'org-attach-expand-links)
  (add-hook 'org-export-before-parsing-hook 'my/org-attach-expand-links)

  ;; Pomodoro
  (use-package org-pomodoro
    :custom-face
    (org-pomodoro-mode-line ((t (:inherit warning))))
    (org-pomodoro-mode-line-overtime ((t (:inherit error))))
    (org-pomodoro-mode-line-break ((t (:inherit success))))
    :bind (:map org-mode-map
                ("C-c C-x m" . org-pomodoro))
    :init
    (with-eval-after-load 'org-agenda
      (bind-keys :map org-agenda-mode-map
                 ("K" . org-pomodoro)
                 ("C-c C-x m" . org-pomodoro)))))


;; Purcell's configs
(when *is-a-mac*
  (maybe-require-package 'grab-mac-link))

(maybe-require-package 'org-cliplink)

(define-key global-map (kbd "C-c l") 'org-store-link)

;; Various preferences
;; (setq
;;  ;; org-log-done t
;;  ;; org-log-done 'time

;;  ;; 之前是用的下面这些配置
;;  ;; org-log-done 'note
;;  ;; org-catch-invisible-edits 'show
;;  ;; org-tags-column 80
;;  )


;;; Sacco General Settings

(define-key global-map (kbd "C-c g l") 'org-toggle-link-display)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

;; (global-set-key (kbd "C-c l") 'org-store-link)
;; (global-set-key (kbd "C-c a") 'org-agenda)
;; (global-set-key (kbd "C-c b") 'org-iswitchb)

;; (define-key global-map (kbd "C-c l") 'org-store-link)
;; (define-key global-map (kbd "C-c a") 'org-agenda)

;; 之前是用的下面这一行配置
;; (define-key global-map (kbd "C-c b") 'org-iswitchb)

;; (define-key global-map (kbd "C-c b") 'org-table-blank-field)

;; (setq-default  org-log-done 'note)

;; solve the impossible problem of escape double quote and single quote

;; (after-load 'org
;;   ;; (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n\r")
;;   ;; (custom-set-variables `(org-emphasis-alist ',org-emphasis-alist))
;;   ;; (org-element-set-regexps)

;;   ;; (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,\"'")

;;   (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n")
;;   (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)

;;   ;; [[http://emacs.stackexchange.com/questions/13820/inline-verbatim-and-code-with-quotes-in-org-mode/13828#13828][Inline verbatim and code with quotes in Org-mode - Emacs Stack Exchange]]
;;   )


;; 之前是用的下面这一行配置
;; set folded headline with inverted triangle
;; (setq org-ellipsis "▼")

;; (after-load 'org
;;   ;;----------------- 设置各级标题样式 ----------------------
;;   (set-face-attribute 'org-level-1 nil :height 1.1 :bold t :foreground "yellow4")
;;   (set-face-attribute 'org-level-2 nil :height 1.1 :bold t)
;;   (set-face-attribute 'org-level-3 nil :height 1.0 :bold t)
;;   )

;; ;;org-bullets
;; (require-package 'org-bullets)
;; (require 'org-bullets)
;; (setq org-bullets-bullet-list  '("✸" "●" "○" "◆" "◇" "▹"))
;; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;;enable rainbow-delimiters-mode in several major mode, I donot exactly undertant this currently
(add-hook 'org-mode-hook #'rainbow-delimiters-mode)
(add-hook 'ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'inferior-ess-mode-hook #'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; (use-package org-fancy-priorities
;;   :config
;;   (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕"))
;;   (add-hook 'org-mode-hook 'org-fancy-priorities-mode))


;;How do I make Org-mode open PDF files
(eval-after-load "org"
  '(progn
     ;; .txt files aren't in the list initially, but in case that changes
     ;; in a future version of org, use if to avoid errors
     (if (assoc "\\.txt\\'" org-file-apps)
         (setcdr (assoc "\\.txt\\'" org-file-apps) "notepad.exe %s")
       (add-to-list 'org-file-apps '("\\.txt\\'" . "notepad.exe %s") t))
     ;; Change .pdf association directly within the alist
     (setcdr (assoc "\\.pdf\\'" org-file-apps) "sumatrapdf %s")
     (add-to-list 'org-file-apps '("\\.png\\'" . default))))


;; 下面这部分应该已经被 truncate 取代了吧？
;;----------------- 设置 auto fill width -----------------
;; (add-hook 'org-mode-hook
;;           (lambda ()
;;             (set-fill-column 80)))

;;; mobile-org
;; Set to the location of your Org files on your local system
(setq org-directory "~/orgfile")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/orgfile/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "E:/Dropbox/Apps/MobileOrg")


;;; Sacco General Settings Ends


;;; ditta

;; Lots of stuff from http://doc.norang.ca/org-mode.html

(defun sanityinc/grab-ditaa (url jar-name)
  "Download URL and extract JAR-NAME as `org-ditaa-jar-path'."
  ;; TODO: handle errors
  (message "Grabbing " jar-name " for org.")
  (let ((zip-temp (make-temp-name "emacs-ditaa")))
    (unwind-protect
        (progn
          (when (executable-find "unzip")
            (url-copy-file url zip-temp)
            (shell-command (concat "unzip -p " (shell-quote-argument zip-temp)
                                   " " (shell-quote-argument jar-name) " > "
                                   (shell-quote-argument org-ditaa-jar-path)))))
      (when (file-exists-p zip-temp)
        (delete-file zip-temp)))))

(after-load 'ob-ditaa
  (unless (and (boundp 'org-ditaa-jar-path)
               (file-exists-p org-ditaa-jar-path))
    (let ((jar-name "ditaa0_9.jar")
          (url "http://jaist.dl.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip"))
      (setq org-ditaa-jar-path (expand-file-name jar-name user-emacs-directory))
      (unless (file-exists-p org-ditaa-jar-path)
        (sanityinc/grab-ditaa url jar-name)))))

(after-load 'ob-plantuml
  (let ((jar-name "plantuml.jar")
        (url "http://jaist.dl.sourceforge.net/project/plantuml/plantuml.jar"))
    (setq org-plantuml-jar-path (expand-file-name jar-name (file-name-directory user-init-file)))
    (unless (file-exists-p org-plantuml-jar-path)
      (url-copy-file url org-plantuml-jar-path))))



(maybe-require-package 'writeroom-mode)

(define-minor-mode prose-mode
  "Set up a buffer for prose editing.
This enables or modifies a number of settings so that the
experience of editing prose is a little more like that of a
typical word processor."
  nil " Prose" nil
  (if prose-mode
      (progn
        (when (fboundp 'writeroom-mode)
          (writeroom-mode 1))
        (setq truncate-lines nil)
        (setq word-wrap t)
        (setq cursor-type 'bar)
        (when (eq major-mode 'org)
          (kill-local-variable 'buffer-face-mode-face))
        (buffer-face-mode 1)
        ;;(delete-selection-mode 1)
        (set (make-local-variable 'blink-cursor-interval) 0.6)
        (set (make-local-variable 'show-trailing-whitespace) nil)
        (set (make-local-variable 'line-spacing) 0.2)
        (ignore-errors (flyspell-mode 1))
        (visual-line-mode 1))
    (kill-local-variable 'truncate-lines)
    (kill-local-variable 'word-wrap)
    (kill-local-variable 'cursor-type)
    (kill-local-variable 'show-trailing-whitespace)
    (kill-local-variable 'line-spacing)
    (buffer-face-mode -1)
    ;; (delete-selection-mode -1)
    (flyspell-mode -1)
    (visual-line-mode -1)
    (when (fboundp 'writeroom-mode)
      (writeroom-mode 0))))

;;(add-hook 'org-mode-hook 'buffer-face-mode)

(use-package org-protocol
  :ensure nil)


;;; Capturing

;; (global-set-key (kbd "C-c c") 'org-capture)
(defun transform-square-brackets-to-round-ones(string-to-transform)
  "Transforms [ into ( and ] into ), other chars left unchanged."
  (concat
   (mapcar #'(lambda (c) (if (equal c ?[) ?\( (if (equal c ?]) ?\) c))) string-to-transform))
  )

(setq org-capture-templates
      `(("t" "todo" entry (file "~/orgfile/GTD/newgtd.org") ; "newgtd.org" => org-default-gtd-file
         "* TODO %?\n%U\n" :clock-resume t)
        ("n" "note" entry (file+headline ,(concat org-roam-directory "notes.org") "Inbox")
         "* %? :NOTE:\n%U\n%a\n" :clock-resume t)
        ("a" "academic" entry (file+headline ,(concat org-roam-directory "notes.org") "InboxAcademics")
         "* %? :NOTE:\n%U\n%a\n" :clock-resume t)
        ;; org-capture-extension
        ;; https://github.com/sprig/org-capture-extension
        ;; Open the Registry Editor (Win-R, then type regedit). Within HKEY_CLASSES_ROOT, add a key called org-protocol. Within org-protocol, set the data for the string value with the name (Default) to be URL:org-protocol, add another string value with name URL Protocol and no data, and add a key called shell.
        ;; Within shell, create a key called open.
        ;; Within open, create a key called command.
        ;; Within command, set the data for the string value with the name (Default) to "C:\the\path\to\your\emacsclientw.exe" "%1", updating the path to point to your Emacs installation.
        ;; For wsl ArchLinux, command should be: wsl -d ArchLinux emacsclient --socket-name emacs-server-file "%1"
        ("p" "Protocol" entry (file+headline ,(concat org-roam-directory "notes.org") "Inbox")
         "* %^{Title}\nSource: %u, %c\n #+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?")
        ("L" "Protocol Link" entry (file+headline ,(concat org-roam-directory "notes.org") "Inbox")
         "* %? [[%:link][%(transform-square-brackets-to-round-ones \"%:description\")]]\n")
        ;; org-capture-tag-bookmark
        ("pb" "Protocol Bookmarks" entry (file+headline  ,(concat org-roam-directory "notes.org") "Inbox")
         "* %U - %:annotation  %:initial" :immediate-finish t :kill-buffer t)
        ("pn" "Protocol Notes" entry (file+headline ,(concat org-roam-directory "notes.org") "Inbox")
         "* %U - %:annotation  %:initial" :immediate-finish t :kill-buffer t)
        ;; https://www.zmonster.me/2020/06/27/org-roam-introduction.html
        ;; 暂时没用上，not work
        ("a" "Annotation" plain (function org-roam-capture--get-point)
         "%U ${body}\n"
         :file-name "${slug}"
         :head "#+title: ${title}\n#+roam_key: ${ref}\n#+roam_alias:\n"
         :immediate-finish t
         :unnarrowed t)))
(setq org-agenda-files (quote ("~/orgfile/GTD/newgtd.org"
                               "~/orgfile/GTD/journal.org"
                               "~/orgfile/GTD/refile-beorg.org"
                               "~/orgfile/GTD/academic.org"
                               "~/orgfile/GTD/someday.org"
                               "~/orgfile/GTD/birthday.org")))

;;; Refiling

(setq org-refile-use-cache nil)

;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))

(after-load 'org-agenda
  (add-to-list 'org-agenda-after-show-hook 'org-show-entry))

(defadvice org-refile (after sanityinc/save-all-after-refile activate)
  "Save all org buffers after each refile operation."
  (org-save-all-org-buffers))

;; Exclude DONE state tasks from refile targets
(defun sanityinc/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets."
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))
(setq org-refile-target-verify-function 'sanityinc/verify-refile-target)

(defun sanityinc/org-refile-anywhere (&optional goto default-buffer rfloc msg)
  "A version of `org-refile' which allows refiling to any subtree."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-refile goto default-buffer rfloc msg)))

(defun sanityinc/org-agenda-refile-anywhere (&optional goto rfloc no-update)
  "A version of `org-agenda-refile' which allows refiling to any subtree."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-agenda-refile goto rfloc no-update)))

;; Targets start with the file name - allows creating level 1 tasks
;;(setq org-refile-use-outline-path (quote file))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)


;;; To-do settings

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d@/!)")
              (sequence "PROJECT(p)" "|" "DONE(d@/!)" "CANCELLED(c@/!)")
              (sequence "WAITING(w@/!)" "DELEGATED(e!)" "HOLD(h)" "|" "CANCELLED(c@/!)")))
      org-todo-repeat-to-state "NEXT")

(setq org-todo-keyword-faces
      (quote (("NEXT" :inherit warning)
              ("PROJECT" :inherit font-lock-string-face))))



;;; Agenda views

(setq-default org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3))


(let ((active-project-match "-INBOX/PROJECT"))

  (setq org-stuck-projects
        `(,active-project-match ("NEXT")))

  (setq org-agenda-compact-blocks t
        org-agenda-sticky t
        org-agenda-start-on-weekday nil
        org-agenda-span 'day
        org-agenda-include-diary nil
        org-agenda-sorting-strategy
        '((agenda habit-down time-up user-defined-up effort-up category-keep)
          (todo category-up effort-up)
          (tags category-up effort-up)
          (search category-up))
        org-agenda-window-setup 'current-window
        org-agenda-custom-commands
        `(("N" "Notes" tags "NOTE"
           ((org-agenda-overriding-header "Notes")
            (org-tags-match-list-sublevels t)))
          ("g" "GTD"
           ((agenda "" nil)
            (tags "INBOX"
                  ((org-agenda-overriding-header "Inbox")
                   (org-tags-match-list-sublevels nil)))
            (stuck ""
                   ((org-agenda-overriding-header "Stuck Projects")
                    (org-agenda-tags-todo-honor-ignore-options t)
                    (org-tags-match-list-sublevels t)
                    (org-agenda-todo-ignore-scheduled 'future)))
            (tags-todo "-INBOX"
                       ((org-agenda-overriding-header "Next Actions")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("HOLD" "WAITING"))
                                (org-agenda-skip-entry-if 'nottodo '("NEXT")))))
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(todo-state-down effort-up category-keep))))
            (tags-todo ,active-project-match
                       ((org-agenda-overriding-header "Projects")
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX/-NEXT"
                       ((org-agenda-overriding-header "Orphaned Tasks")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("PROJECT" "HOLD" "WAITING" "DELEGATED"))
                                (org-agenda-skip-subtree-if 'nottododo '("TODO")))))
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/WAITING"
                       ((org-agenda-overriding-header "Waiting")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/DELEGATED"
                       ((org-agenda-overriding-header "Delegated")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX"
                       ((org-agenda-overriding-header "On Hold")
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("WAITING"))
                                (org-agenda-skip-entry-if 'nottodo '("HOLD")))))
                        (org-tags-match-list-sublevels nil)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            ;; (tags-todo "-NEXT"
            ;;            ((org-agenda-overriding-header "All other TODOs")
            ;;             (org-match-list-sublevels t)))
            )))))


(add-hook 'org-agenda-mode-hook 'hl-line-mode)


;;; Org clock

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(after-load 'org
  (org-clock-persistence-insinuate))
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Save state changes in the LOGBOOK drawer
(setq org-log-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show clock sums as hours and minutes, not "n days" etc.
(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))



;;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(after-load 'org-clock
  (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
  (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu))



(when (and *is-a-mac* (file-directory-p "/Applications/org-clock-statusbar.app"))
  (add-hook 'org-clock-in-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                (concat "tell application \"org-clock-statusbar\" to clock in \"" org-clock-current-task "\""))))
  (add-hook 'org-clock-out-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                "tell application \"org-clock-statusbar\" to clock out"))))



;; TODO: warn about inconsistent items, e.g. TODO inside non-PROJECT
;; TODO: nested projects!



(require-package 'org-pomodoro)
(setq org-pomodoro-keep-killed-pomodoro-time t)
(after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro))


;; ;; Show iCal calendars in the org agenda
;; (when (and *is-a-mac* (require 'org-mac-iCal nil t))
;;   (setq org-agenda-include-diary t
;;         org-agenda-custom-commands
;;         '(("I" "Import diary from iCal" agenda ""
;;            ((org-agenda-mode-hook #'org-mac-iCal)))))

;;   (add-hook 'org-agenda-cleanup-fancy-diary-hook
;;             (lambda ()
;;               (goto-char (point-min))
;;               (save-excursion
;;                 (while (re-search-forward "^[a-z]" nil t)
;;                   (goto-char (match-beginning 0))
;;                   (insert "0:00-24:00 ")))
;;               (while (re-search-forward "^ [a-z]" nil t)
;;                 (goto-char (match-beginning 0))
;;                 (save-excursion
;;                   (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
;;                 (insert (match-string 0))))))


(after-load 'org
  (when *is-a-mac*
    (define-key org-mode-map (kbd "M-h") nil)
    (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link)))


;;; org-babel
;; (after-load 'org
;;   (org-babel-do-load-languages
;;    'org-babel-load-languages
;;    `(
;;      ;; (R  . t)
;;      (ditaa . t)
;;      ;; (asymptote . t)
;;      (dot . t)
;;      (emacs-lisp . t)
;;      (gnuplot . t)
;;      (haskell . nil)
;;      (latex . t)
;;      ;; (ledger . t)
;;      (ocaml . nil)
;;      (octave . t)
;;      (plantuml . t)
;;      (python . t)
;;      (ruby . t)
;;      (screen . nil)
;;      (,(if (locate-library "ob-sh") 'sh 'shell) . t)
;;      (sql . nil)
;;      (sqlite . t))))



;;; Private User Misc Settings
(defun org-open-exported-pdf ()
  (interactive)
  (let* ((file (concat (file-name-sans-extension (buffer-file-name)) ".pdf")))
    (message "Opening %s..." file)
    (call-process "xdg-open" nil 0 nil file)
    (message "Opening %s done" file)
    ))



;;; Do not ask if to avaluate the code blocks
(defun my-org-confirm-babel-evaluate (lang body)
  (and
   (not (string= lang "latex"))         ;don't ask for latex
   (not (string= lang "emacs-lisp"))    ;don't ask for elisp
   (not (string= lang "sh"))            ;don't ask for shell
   (not (string= lang "python"))
   (not (string= lang "dot"))))                                   ;don't ask for python

(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;; org-edit-latex
(use-package org-edit-latex)


;;; increasingly renumber the equation in fragment
(defun org-renumber-environment (orig-func &rest args)
  (let ((results '())
        (counter -1)
        (numberp))

    (setq results (loop for (begin .  env) in
                        (org-element-map (org-element-parse-buffer) 'latex-environment
                          (lambda (env)
                            (cons
                             (org-element-property :begin env)
                             (org-element-property :value env))))
                        collect
                        (cond
                         ((and (string-match "\\\\begin{equation}" env)
                               (not (string-match "\\\\tag{" env)))
                          (incf counter)
                          (cons begin counter))
                         ((string-match "\\\\begin{align}" env)
                          (prog2
                              (incf counter)
                              (cons begin counter)
                            (with-temp-buffer
                              (insert env)
                              (goto-char (point-min))
                              ;; \\ is used for a new line. Each one leads to a number
                              (incf counter (count-matches "\\\\$"))
                              ;; unless there are nonumbers.
                              (goto-char (point-min))
                              (decf counter (count-matches "\\nonumber")))))
                         (t
                          (cons begin nil)))))

    (when (setq numberp (cdr (assoc (point) results)))
      (setf (car args)
            (concat
             (format "\\setcounter{equation}{%s}\n" numberp)
             (car args)))))

  (apply orig-func args))

(advice-add 'org-create-formula-image :around #'org-renumber-environment)
;; (advice-remove 'org-create-formula-image #'org-renumber-environment)

;;; org-ref and bibtex

(use-package org-ref
  :disabled t
  :config
  (use-package ivy-bibtex)
  (require 'doi-utils)
  ;; doi-utils-add-bibtex-entry-from-doi and doi-utils-add-entry-from-crossref-query
  (require 'org-ref-wos)
  (require 'org-ref-scopus)
  (require 'org-ref-isbn)
  (require 'org-ref-pubmed)
  (require 'org-ref-arxiv)
  (require 'org-ref-sci-id)
  (require 'x2bib)

  (setq org-latex-prefer-user-labels t)
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  ;; on Linux or macOS, just use ln command to make a symbol link or hard link
  ;; on Windows, you should make a symbol link from your zotero export bib file to ~/.emacs.d/zoterobib.bib
  ;; mklink "<path-to-home>/.emacs.d/zoterobib.bib" "<path-and-filename-to-zotero-export-bib>"
  (setq reftex-default-bibliography '(expand-file-name "zoterobib.bib" user-emacs-directory))
  (setq bibtex-completion-pdf-symbol "⌘")
  (setq bibtex-completion-notes-symbol "✎")

  ;; see org-ref for use of these variables
  (setq org-ref-bibliography-notes "D:/MyDocuments/My Knowledge/Data/private-email@example.invalid/Academic/Projects/S 波段双圆极化天线/S波段双圆极化天线文档/双圆极化天线论文笔记.org_Attachments/note-of-dual-circular-polarized-antenna-papers.org"
        org-ref-default-bibliography '("E:/Zotero/autobib/zoteroexport.bib")
        org-ref-pdf-directory "E:/Zotero/storage/")
  (setq bibtex-completion-bibliography "E:/Zotero/autobib/zoteroexport.bib"
        bibtex-completion-library-path "E:/Zotero/storage"
        bibtex-completion-notes-path "E:/Zotero/storage")

  ;; open pdf with system pdf viewer (works on mac)
  ;; (setq bibtex-completion-pdf-open-function
  ;;       (lambda (fpath)
  ;;         (start-process "open" "*open*" "open" fpath)))

  ;; alternative
  ;; (setq bibtex-completion-pdf-open-function 'org-open-file)

  (setq bibtex-completion-pdf-field "File")
  (defun hsk/org-ref-open-pdf-at-point ()
    "Open the pdf for bibtex key under point if it exists."
    (interactive)
    (let* ((results (org-ref-get-bibtex-key-and-file))
           (key (car results))
           (pdf-file (car (bibtex-completion-find-pdf key))))
      (if (file-exists-p pdf-file)
          (org-open-file pdf-file)
        (message "No PDF found for %s" key))))

  (setq org-ref-open-pdf-function 'hsk/org-ref-open-pdf-at-point)
  )




;; Roam
(when (executable-find "cc")
  (use-package org-roam
    :diminish
    :hook (after-init . org-roam-db-autosync-enable)
    :bind (("C-c n l" . org-roam-buffer-toggle)
           ("C-c n f" . org-roam-node-find)
           ("C-c n g" . org-roam-graph)
           ("C-c n i" . org-roam-node-insert)
           ("C-c n c" . org-roam-capture)
           ("C-c n j" . org-roam-dailies-capture-today))
    :init
    (setq org-roam-directory (file-truename dropbox-org-roam-directory))
    :config
    (unless (file-exists-p org-roam-directory)
      (make-directory org-roam-directory))
    ;; 使用侧边栏而不是完整buffer
    (add-to-list 'display-buffer-alist
                 '("\\*org-roam\\*"
                   (display-buffer-in-side-window)
                   (side . right)
                   (slot . 0)
                   (window-width . 0.25)
                   (window-parameters . ((no-other-window . t)
                                         (no-delete-other-windows . t)))))

    ;; 标题链接分级显示
    ;; Codes blow are used to general a hierachy for title nodes that under a file
    (cl-defmethod org-roam-node-doom-filetitle ((node org-roam-node))
      "Return the value of \"#+title:\" (if any) from file that NODE resides in.
      If there's no file-level title in the file, return empty string."
      (or (if (= (org-roam-node-level node) 0)
              (org-roam-node-title node)
            (org-roam-get-keyword "TITLE" (org-roam-node-file node)))
          ""))
    (cl-defmethod org-roam-node-doom-hierarchy ((node org-roam-node))
      "Return hierarchy for NODE, constructed of its file title, OLP and direct title.
        If some elements are missing, they will be stripped out."
      (let ((title     (org-roam-node-title node))
            (olp       (org-roam-node-olp   node))
            (level     (org-roam-node-level node))
            (filetitle (org-roam-node-doom-filetitle node))
            (separator (propertize " > " 'face 'shadow)))
        (cl-case level
          ;; node is a top-level file
          (0 filetitle)
          ;; node is a level 1 heading
          (1 (concat (propertize filetitle 'face '(shadow italic))
                     separator title))
          ;; node is a heading with an arbitrary outline path
          (t (concat (propertize filetitle 'face '(shadow italic))
                     separator (propertize (string-join olp " > ") 'face '(shadow italic))
                     separator title)))))

    (setq org-roam-node-display-template (concat "${type:15} ${doom-hierarchy:80} " (propertize "${tags:*}" 'face 'org-tag)))

    (when emacs/>=27p
      (use-package org-roam-ui
        :init
        (when (featurep 'xwidget-internal)
          (setq org-roam-ui-browser-function #'xwidget-webkit-browse-url))
        :bind (
               ("C-c n u". org-roam-ui-open))
        :config
        (setq org-roam-ui-sync-theme t
              org-roam-ui-follow t
              org-roam-ui-update-on-save t
              org-roam-ui-open-on-start t)))))


(use-package dogears
  ;; These bindings are optional, of course:
  :bind (:map global-map
              ("M-g d" . dogears-go)
              ("M-g M-b" . dogears-back)
              ("M-g M-f" . dogears-forward)
              ("M-g M-d" . dogears-list)
              ("M-g M-D" . dogears-sidebar)))

(use-package org-ql
  :config
  (use-package helm-org-ql))
(use-package org-sidebar)


;;; Private User Misc Settings Ends

(provide 'init-org)
