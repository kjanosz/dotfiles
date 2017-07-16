;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
; (package-initialize)

(require 'package)

(cond
 ;; on NixOS, use only /nix/store/
 ((executable-find "nixos-version")
  (setq package-archives nil))

 ;; on any other host, install used packages from (M)ELPA
 (t
  (setq package-archives
        '(("melpa" . "https://melpa.org/packages/")
          ("gnu" . "http://elpa.gnu.org/packages/")))
  (setq use-package-always-ensure t)))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

(add-to-list 'load-path (expand-file-name "~/.emacs.d/config/"))

(require 'init-general)
(require 'init-lang)
(require 'init-other)
(require 'init-text)
