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
 '(custom-safe-themes
   '("4948bf17970f7fe49cdb2e4829d2434ea4c990a37df983258b068b6954bad143"
     default))
 '(org-agenda-files '("~/notes/initial.org"))
 '(package-selected-packages
   '(cape corfu dashboard doom-modeline magit marginalia markdown-mode
	  nerd-icons-dired nix-mode org-modern page-break-lines
	  treesit-auto ultra-scroll vertico yasnippet
	  yasnippet-snippets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

