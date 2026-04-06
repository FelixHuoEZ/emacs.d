;;; init-local-pyim.el --- On-demand pyim setup -*- lexical-binding: t -*-

(use-package pyim
  :config
  ;; Basic navigation and conversion settings for pyim.
  (setq pyim-default-scheme 'quanpin)

  ;; (setq pyim-enable-words-predict '(dabbrev pinyin-similar pinyin-znabc))
  ;; (setq pyim-enable-words-predict nil)
  (require 'pyim-dregcache)
  (require 'pyim-cregexp-utils)
  (require 'pyim-cstring-utils)

  (setq pyim-backends '(dcache-personal dcache-common pinyin-chars pinyin-shortcode pinyin-znabc))
  ;; (setq pyim-backends '(dcache-personal dcache-common pinyin-chars))
  ;; (setq pyim-backends '(dcache-common))

  (setq-default pyim-english-input-switch-functions
                '(pyim-probe-dynamic-english
                  pyim-probe-isearch-mode
                  pyim-probe-program-mode
                  pyim-probe-org-structure-template))

  (setq-default pyim-punctuation-half-width-functions
                '(pyim-probe-punctuation-line-beginning
                  pyim-probe-punctuation-after-punctuation))

  (use-package pyim-basedict
    :config
    (pyim-basedict-enable))

  (setq pyim-dicts
        '(
          ;; (:name "bigdict" :file "~/.emacs.d/pyim/dicts/pyim-bigdict.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ;; (:name "guessdict" :file "~/.emacs.d/pyim/dicts/pyim-guessdict.gpyim" :coding utf-8-unix :dict-type guess-dict)
          ;; (:name "sogou-dic-utf8" :file "~/.emacs.d/pyim/dicts/sogou-dic-utf8.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ;; (:name "sogoucell" :file "~/.emacs.d/pyim/dicts/SogouCellWordLib.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ;; (:name "millions" :file "~/.emacs.d/pyim/dicts/millions.pyim" :coding utf-8-unix :dict-type pinyin-dict)

          (:name "Useful" :file "~/.emacs.d/pyim/dicts/Useful.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "words" :file "~/.emacs.d/pyim/dicts/words.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "Daily" :file "~/.emacs.d/pyim/dicts/Daily.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "Electronics" :file "~/.emacs.d/pyim/dicts/Electronics.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "CS" :file "~/.emacs.d/pyim/dicts/CS.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          (:name "Math-Physics" :file "~/.emacs.d/pyim/dicts/Math-Physics.pyim" :coding utf-8-unix :dict-type pinyin-dict)
          ))

  ;; Enable searching with pinyin.
  (setq pyim-isearch-enable-pinyin-search t)
  ;; (setq pyim-guidance-format-function 'pyim-guidance-format-function-one-line)
  (setq pyim-page-length 9)
  ;; (setq pyim-page-style 'one-line)
  (setq pyim-page-tooltip nil)
  ;; (setq pyim-page-tooltip 'pos-tip)
  ;; (setq pyim-page-tooltip 'popup)

  ;; 词库导出，后续更新版本需要注释掉
  ;; (defun pyim-personal-dcache-export ()
  ;; "将 pyim-dcache-icode2word 导出为 pyim 词库文件。"
  ;; (interactive)
  ;; (let ((file (read-file-name "将个人缓存中的词条导出到文件：")))
  ;; (with-temp-buffer
  ;; (insert ";;; -*- coding: utf-8-unix -*-\n")
  ;; (maphash
  ;; #'(lambda (key value)
  ;; (insert (concat key " " (mapconcat #'identity value " ") "\n")))
  ;; pyim-dcache-icode2word)
  ;; (write-file file))))

  (use-package pyim-company
    :disabled t
    :ensure nil
    :config
    (setq pyim-company-max-length 6))

  ;; Keep the original pyim-centric keybindings, but only after pyim is
  ;; intentionally loaded for the current session.
  (global-set-key (kbd "M-j") #'pyim-convert-string-at-point)
  (global-set-key (kbd "C-c h") #'pyim-punctuation-translate-at-point)
  (global-set-key (kbd "C-c C-h") #'pyim-punctuation-toggle)
  (global-set-key (kbd "M-f") #'pyim-forward-word)
  (global-set-key (kbd "M-b") #'pyim-backward-word))

(provide 'init-local-pyim)
