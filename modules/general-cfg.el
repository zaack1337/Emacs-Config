;; Disable backups
(setq auto-save-default nil)
(setq backup-inhibited t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(auto-save-mode nil)

;; define projeto
(setq project-vc-extra-root-markers '(".project"))

;; config agenda
(setq org-agenda-files '("~/notes/"))

(provide 'general-cfg)
