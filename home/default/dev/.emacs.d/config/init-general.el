;;; init-general.el --- General settings


;;; Code:

;;;;;;;;;;;;;;;
; Performance ;
;;;;;;;;;;;;;;;

;; always load newest byte code
(setq load-prefer-newer t)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(setq
  max-lisp-eval-depth 50000
  max-specpdl-size 5000)

;;;;;;;;;;;
; General ;
;;;;;;;;;;;

(use-package base16-theme
  :config
  (load-theme 'base16-tomorrow-night t)
  (setq frame-background-mode 'dark))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package smartparens
  :config
  (smartparens-global-mode t))

(use-package switch-window
  :bind (("C-x o" . switch-window)))

(use-package company)

(use-package flycheck
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package helm)

(use-package helm-ag)

(use-package magit
  :config
  (global-magit-file-mode))

(use-package neotree
  :bind (("<f2>" . neotree-toggle)
         ("<f3>" . neotree-show))
  :init
  (setq neo-theme (quote nerd)
        neo-smart-open t
        neo-window-width 40
        neo-vc-integration (quote (char))))

(use-package projectile
  :config
  (use-package helm-projectile)
  (projectile-global-mode)
  (setq projectile-completion-system 'helm
        projectile-switch-project-action 'helm-projectile))

(use-package ranger
  :config
  (ranger-override-dired-mode t))


;;;;;;;;
; Sane ;
;;;;;;;;

; tramp
(setq tramp-histfile-override nil) ; send tramp history to default shell history file

; backup
(setq
  make-backup-files t
  backup-by-copying t ; for symlinks
  backup-directory-alist '((".*" . "~/.emacs.d/backups"))
  auto-save-file-name-transforms `((".*", temporary-file-directory t))
  version-control t
  kept-new-versions 10
  kept-old-versions 2
  delete-old-versions t)

; bars 
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

; splash
(setq 
  inhibit-splash-screen t
  initial-scratch-message nil)

(setq echo-keystrokes 0.1
      use-dialog-box nil
      visible-bell t)

(global-linum-mode t)   ; line numbers
(global-hl-line-mode t) ; line highlighting
(show-paren-mode t)     ; show matching parentheses

(setq select-enable-clipboard t) ; allow pasting outside of Emacs

(setq-default 
  c-basic-offset 2
  tab-width 2
  indent-tabs-mode nil)

(setq
  column-number-mode t
  line-number-mode t
  fill-column 80
  next-line-add-newlines t)

(global-unset-key "\C-z")

(global-set-key (kbd "C-.") 'imenu-anywhere)


(provide 'init-general)
;;; init-general.el ends here
