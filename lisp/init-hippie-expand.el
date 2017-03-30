(global-set-key (kbd "M-/") 'hippie-expand)

(setq hippie-expand-try-function-list '(try-expand-debbrev
                                        try-expand-debbrev-all-buffers
                                        try-expand-debbrev-from-kill
                                        try-complete-file-name-partially
                                        try-complete-file-name
                                        try-expand-all-abbrevs
                                        try-expand-list
                                        try-expand-line
                                        try-complete-lisp-symbol-partially
                                        try-complete-lisp-symbol))
;; (setq hippie-expand-try-functions-list
;;       '(try-complete-file-name-partially
;;         try-complete-file-name
;;         try-expand-dabbrev
;;         try-expand-dabbrev-all-buffers
;;         try-expand-dabbrev-from-kill))

(provide 'init-hippie-expand)
