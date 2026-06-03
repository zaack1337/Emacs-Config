(add-to-list 'load-path "~/.emacs.d/modules/")

(require 'ui)
(require 'packages)
(require 'dashboard-cfg)
(require 'markdown-cfg)
(require 'code-cfg)
(require 'general-cfg)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(dashboard markdown-mode nerd-icons nerd-icons-dired nimbus-theme
	       ultra-scroll)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

