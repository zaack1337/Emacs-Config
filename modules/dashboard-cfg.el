(use-package dashboard
  :ensure t
  :init

;; nerd icons
(setq dashboard-display-icons-p t)
(setq dashboard-icon-type 'nerd-icons)

;; Icones ao widgets do dash
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)

;; deixar conteudo no centro
(setq dashboard-center-content t)

;; adiciona items ao dashboard
(setq dashboard-items '((recents   . 5)))
                 
;; projects area
(setq dashboard-projects-backend 'project-el)

;; banner
(setq dashboard-banner-logo-title "zaack1337 - Emacs")
(setq dashboard-startup-banner (locate-user-emacs-file "263fe1d597a45cac544e2bd5183bba16.jpg"))
;;(setq dashboard-image-banner-max-height 300)
;;(setq dashboard-image-banner-max-width 300)
(dashboard-setup-startup-hook))

(use-package page-break-lines
  :ensure t
  )


(provide 'dashboard-cfg)
