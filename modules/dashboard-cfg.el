(require 'dashboard)
(dashboard-setup-startup-hook)

(setq dashboard-banner-logo-title "zaack1337 - Emacs")
(setq dashboard-startup-banner (locate-user-emacs-file "banner.png"))

(setq dashboard-center-content t)

(setq dashboard-image-banner-max-height 300)
(setq dashboard-image-banner-max-width 300)

(provide 'dashboard-cfg)
