;;; init-other.el --- Tool specific settings for developement.


;;; Code:

(use-package nix-mode
  :config
  (use-package nixos-options
    :bind (("C-c C-S-n" . helm-nixos-options))
    :config
    (use-package company-nixos-options)
    (use-package helm-nixos-options)
    (add-to-list 'company-backends 'company-nixos-options)))

(use-package yaml-mode
  :config
  (use-package ansible
    :config
    (use-package company-ansible)
    (add-to-list 'company-backends 'company-ansible)
    (add-hook 'ansible-hook 'ansible::auto-decrypt-encrypt))
  (add-hook 'yaml-mode-hook '(lambda () (ansible 1))))


(provide 'init-other)
;;; init-other.el ends here
