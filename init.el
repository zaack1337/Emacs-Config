(add-to-list 'load-path "~/.emacs.d/modules/")

(require 'ui)
(require 'packages-cfg)
(require 'dashboard-cfg)
(require 'markdown-cfg)
(require 'code-cfg)
(require 'general-cfg)
(require 'org-cfg)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("~/notes/initial.org"))
 '(package-selected-packages
   '(cape corfu dashboard doom-modeline doom-themes marginalia
	  markdown-mode nerd-icons-dired nimbus-theme org-modern
	  treesit-auto ultra-scroll vertico vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

