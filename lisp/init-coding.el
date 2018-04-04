;;; init-coding --- initialize coding of all environments
;;; 修改编码之后需要删除 projectile.eld，不然每一次打开文件都会弹出 temp file 让你选择编码

(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
;; (setq locale-coding-system 'utf-8)
;; (set-locale-environment  "en_US.UTF-8" nil)

;; (setq coding-system-for-read 'utf-8-unix) ;if set this variable to utf-8, there will be some dirty code in shell mode prompt, but if not, there will be some dirty code in shell mode file name and path name
;; (setq coding-system-for-write 'utf-8-unix) ;set to utf-8-unix can inhibit to show the coding choice prompt for temp file(especially for chinese-pyim and projectile.eld), but make open pdf after latex export fail, so just use the default value nil or gbk/chinese-gbk. if non-nil, this value will also overwrite buffer-file-coding-system
;; (setq coding-system-for-write 'nil) ;nil means raw-text
;; (setq coding-system-for-write 'chinese-gbk-unix)

(cond
 ((eq system-type 'windows-nt)
  (set-file-name-coding-system 'chinese-gbk))
 ((eq system-type 'gnu/linux)
  (set-file-name-coding-system 'utf-8-unix)))

;; 文件默认保存为 utf-8
;; (set-default buffer-file-coding-system 'utf-8-unix) ; just apply to saving buffer, not for sending output to subprocess or decoding file while reading it

(set-keyboard-coding-system nil) ;the coding system for keyboard input, nil means raw text
;; (set-keyboard-coding-system 'utf-8-unix) ;the coding system for keyboard input
;; (set-terminal-coding-system 'chinese-gbk)  ;the coding system for terminal output
                                        ; The setting has no effect on graphical terminals
;; Do not set the following two sentences(selection-coding-system and clipboard-coding-system), otherwise will make filename copy in windows become messy code
;; (set-clipboard-coding-system 'chinese-gbk) ;set-clipboard-coding-system is just an alis of set-selection-coding-system
;; (set-selection-coding-system 'chinese-gbk) ;Coding Systems for Interprocess Communication, must be gbk/chinese-gbk on Windows for clipboard
;;(set-next-selection-coding-system 'utf-8-unix) ; Use CODING-SYSTEM for next communication with other window system clients.
                                        ; This setting is effective for the next communication only.

(prefer-coding-system 'chinese-gbk)
(prefer-coding-system 'utf-8)

;; let plink and cmpproxy use coding type of gbk-dos
(when (eq system-type 'windows-nt)
  (set-default 'process-coding-system-alist
               '(("[pP][lL][iI][nN][kK]" gbk-dos . gbk-dos)
                 ("[cC][mM][dD][pP][rR][oO][xX][yY]" gbk-dos . gbk-dos))))

;; set buffer coding system, which is just for saving buffer
(defun unix-file ()
  "Change the current buffer to utf-8 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-unix t))
(defun dos-file ()
  "Change the current buffer to utf-8 with DOS line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-dos t))
(defun mac-file ()
  "Change the current buffer to utf-8 with Mac line-ends."
  (interactive)
  (set-buffer-file-coding-system 'utf-8-mac t))


;; batch line ending conversion in dired mode
(defun xah-change-file-line-ending-style (*files *style)
  "Change current file or dired marked file's newline convention.

When called non-interactively, *style is one of 'unix 'dos 'mac or any of accepted emacs coding system. See `list-coding-systems'.

URL `http://ergoemacs.org/emacs/elisp_convert_line_ending.html'
Version 2016-10-16"
  (interactive
   (list
    (if (eq major-mode 'dired-mode )
        (dired-get-marked-files)
      (list (buffer-file-name)))
    (ido-completing-read "Line ending:" '("Linux/MacOSX/Unix" "MacOS9" "Windows") "PREDICATE" "REQUIRE-MATCH")))
  (let* (
         (-codingSystem
          (cond
           ((equal *style "Linux/MacOSX/Unix") 'unix)
           ((equal *style "MacOS9") 'mac)
           ((equal *style "Windows") 'dos)
           (t (error "code logic error 65327. Expect one of it." )))))
    (mapc
     (lambda (x) (xah-convert-file-coding-system x -codingSystem))
     *files)))

(defun xah-change-file-line-ending-style-utf8 (*files *style)
  "Change current file or dired marked file's newline convention.

When called non-interactively, *style is one of 'unix 'dos 'mac or any of accepted emacs coding system. See `list-coding-systems'.

URL `http://ergoemacs.org/emacs/elisp_convert_line_ending.html'
Version 2016-10-16"
  (interactive
   (list
    (if (eq major-mode 'dired-mode )
        (dired-get-marked-files)
      (list (buffer-file-name)))
    (ido-completing-read "Line ending:" '("Linux/MacOSX/Unix" "MacOS9" "Windows") "PREDICATE" "REQUIRE-MATCH")))
  (let* (
         (-codingSystem
          (cond
           ((equal *style "Linux/MacOSX/Unix") 'utf-8-unix)
           ((equal *style "MacOS9") 'utf-8-mac)
           ((equal *style "Windows") 'utf-8-dos)
           (t (error "code logic error 65327. Expect one of it." )))))
    (mapc
     (lambda (x) (xah-convert-file-coding-system x -codingSystem))
     *files)))

(defun xah-convert-file-coding-system (*fpath *coding-system)
  "Convert file's encoding.
 *fpath is full path to file.
 *coding-system is one of 'unix 'dos 'mac or any of accepted emacs coding system. See `list-coding-systems'.

If the file is already opened, it will be saved after this command.

URL `http://ergoemacs.org/emacs/elisp_convert_line_ending.html'
Version 2015-07-24"
  (let (-buffer
        (-bufferOpened-p (get-file-buffer *fpath)))
    (if -bufferOpened-p
        (with-current-buffer -bufferOpened-p
          (set-buffer-file-coding-system *coding-system)
          (save-buffer))
      (progn
        (setq -buffer (find-file *fpath))
        (set-buffer-file-coding-system *coding-system)
        (save-buffer)
        (kill-buffer -buffer)))))


(provide 'init-coding)
