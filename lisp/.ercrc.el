
;;; erc
;;; emacs irc

;; (defconst irc-channels
;;   '(("freenode.net" "#ubuntu-cn" "#archlinux-cn" "#emacs.tw"
;;      ;; "#geekhack"
;;      )
;;     ("oftc.net" "#arch-cn" "#njulug" "#wormux-cn" "#emacs-cn")
;;     ("esper.net" "#minecraft-cn")))
;; (ignore-errors (setq erc-autojoin-channels-alist irc-channels))

;; (defun erc-start ()
;;   (interactive)
;;   (erc :server "irc.freenode.net" :port 6667 :nick irc-nick
;;        :password irc-password :full-name irc-full-name)
;;   (erc-tls :server "irc.oftc.net" :port 6697 :nick irc-nick
;;            :password irc-password :full-name irc-full-name)
;;   (erc-tls :server "irc.esper.net" :port 6697 :nick irc-nick
;;            :password irc-password :full-name irc-full-name))


;; (setq erc-quit-reason-various-alist
;;       '(("dinner" "Having dinner...")
;;         ("z" "Zzz...")
;;         ("^$" yow)))
;; (setq erc-quit-reason 'erc-quit-reason-various)

;; (defun erc-cmd-THINK (&rest line)
;;   (let ((text
;;          (concat ".oO{ "
;;                  (erc-trim-string (mapconcat 'identity line " "))
;;                  " }")))
;;     (erc-send-action (erc-default-target) text)))

;; (defun erc-cmd-SLAP (&rest nick)
;;   (if (not (equal '() nick))
;;       (erc-send-action
;;        (erc-default-target)
;;        (concat "slaps " (car nick)
;;                " with Peskin's Introduction to QFT."))))

;; (defun erc-cmd-SHOWOFF (&rest ignore)
;;   "Show off implementation"
;;   (let* ((chnl (erc-buffer-list))
;;          (srvl (erc-buffer-list 'erc-server-buffer-p))
;;          (memb (apply '+ (mapcar (lambda (chn)
;;                                    (with-current-buffer chn
;;                                      (1- (length (erc-get-channel-user-list)))))
;;                                  chnl)))
;;          (show (format "is connected to %i networks and talks in %i chans to %i ppl overall :>"
;;                        (length srvl)
;;                        (- (length chnl) (length srvl))
;;                        memb)))
;;     (erc-send-action (erc-default-target) show)))

;; ;; Say hi to everyone, use with CAUTION!!
;; (defun erc-cmd-HI ()
;;   (defun hi-to-nicks (nick-list)
;;     (if (eq nick-list '())
;;         nil
;;       (erc-send-message (concat "Hi, " (car nick-list)))
;;       (sleep-for 1)
;;       (hi-to-nicks (cdr nick-list))))

;;   (let ((nicks (erc-get-channel-nickname-list)))
;;     (hi-to-nicks nicks)))

;; [[https://www.zhihu.com/question/27478438/answer/59796810][Emacs 有什么奇技淫巧? - 地铁风的回答 - 知乎]]
;; [[https://www.zhihu.com/question/27478438][Emacs 有什么奇技淫巧? - 知乎]]
