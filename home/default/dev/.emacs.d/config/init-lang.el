;;; init-lang.el --- Language specific settings for developement.


;;; Code:
(use-package haskell-mode
  :config
  (use-package intero)
  (use-package shm)
  (use-package company-cabal)
  (use-package company-ghc)
  (use-package helm-ghc)
  (use-package flycheck-haskell)
  (add-hook 'haskell-mode-hook
            (lambda()
              (structured-haskell-mode))))

(use-package idris-mode
  :config
  (use-package helm-idris))

(use-package proof-site
  :config
  (use-package coq-mode)
  (use-package company-coq))


(use-package python-mode
  :mode "\\.py\\'"
  :interpreter "python"
  :config
  (use-package ein
    :config
    (ein:use-smartrep t)))

(use-package rust-mode
  :bind (("TAB" . company-indent-or-complete-common))
  :config
  (use-package cargo)
  (use-package racer-mode)
  (use-package rustfmt)
  (use-package company-racer)
  (use-package flycheck-rust)
  (add-hook 'rust-mode-hook
            (lambda()
              (cargo-minor-mode)
              (racer-mode))))

(use-package scala-mode
  :mode ("\\.scala\\'" "\\.sbt\\'")
  :interpreter ("scala" . scala-mode)
  :bind (("C-e" . ensime)
         ("RET" . newline-and-indent)
         ("<backtab>" . scala-indent:indent-with-reluctant-strategy))
  :init
  (setq scala-indent:default-run-on-strategy 'eager
        scala-indent:indent-value-expression nil
        scala-indent:align-parameters nil)
  :config
  (use-package ensime)
  (use-package sbt-mode))

(use-package geiser
  :config
  (add-hook 'scheme-mode-hook 'geiser-mode))

(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 2
                  sh-indentation 2
                  smie-indent-basic 2)))

(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)))

(use-package web-mode
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))


(provide 'init-lang)
;;; init-lang.el ends here
