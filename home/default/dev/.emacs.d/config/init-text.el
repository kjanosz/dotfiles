;;; init-text.el --- Settings for text processing


;;; Code:

(use-package tex
  :config
  (setq-default TeX-PDF-mode t)
  (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
  (setq TeX-command-default "XeLaTeX"
        TeX-save-query nil
        TeX-show-compilation t)
  (add-hook 'LaTeX-mode-hook '(lambda ()
                                (visual-line-mode)
                                (flyspell-mode)
                                (LaTeX-math-mode)
                                (turn-on-reftex)))
  (add-hook 'TeX-language-en-hook (lambda ()
                                    (ispell-change-dictionary "english")))
  (add-hook 'TeX-language-pl-hook (lambda ()
                                    (ispell-change-dictionary "polish"))))

(use-package markdown-mode
  :config
  (use-package pandoc-mode)
  (add-hook 'markdown-mode-hook 'pandoc-mode)
  (add-hook 'pandoc-mode-hook 'pandoc-load-default-settings))

(use-package org
  :config
  (require 'org-crypt)
  (org-crypt-use-before-save-magic)
  (setq org-crypt-key "janosz.krzysztof@gmail.com")
  (setq org-pandoc-options-for-beamer-pdf '((latex-engine . "xelatex"))
        org-pandoc-options-for-latex-pdf '((latex-engine . "xelatex")))
  (setq org-todo-keyword
        '((sequence "TODO(t)" "|" "IN-PROGRESS(p)" "WAITING(w)" "DONE(d)" "CANCELLED(c)")))
  (setq org-todo-keyword-faces
      '(("TODO" . org-warning)
        ("IN_PROGRESS" . (:foreground "orange" :weight bold))
        ("WAITING" . (:foreground "yellow" :weight bold))
        ("DONE" . (:foreground "green" :weight bold))
        ("CANCELLED" . (:foreground "gray" :weight bold)))))

(use-package org-journal
  :ensure t
  :defer t
  :config
  (require 'org-crypt)
  (org-crypt-use-before-save-magic)
  (setq org-crypt-key "janosz.krzysztof@gmail.com")
  :custom
  (org-journal-dir "~/Documents/Journal/")
  (org-journal-date-format "%A, %F")
  (org-journal-encrypt-journal t))


(provide 'init-text)
;;; init-text.el ends here
