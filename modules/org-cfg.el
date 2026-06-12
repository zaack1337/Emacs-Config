;;; org-cfg.el --- Configuração do Org -*- lexical-binding: t; -*-

(define-minor-mode org-read-mode
  "Modo de leitura para arquivos Org."
  :lighter " Read"

  (if org-read-mode
      (progn
        (org-indent-mode 1)

        (when (fboundp 'olivetti-mode)
          (olivetti-mode 1))

        (when (fboundp 'org-modern-mode)
          (org-modern-mode 1))

        (setq-local line-spacing 0.2)

        (message "Read mode enabled"))

    (org-indent-mode -1)

    (when (fboundp 'olivetti-mode)
      (olivetti-mode -1))

    (when (fboundp 'org-modern-mode)
      (org-modern-mode -1))

    (kill-local-variable 'line-spacing)

    (message "Read mode disabled")))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c r") #'org-read-mode))

(use-package org-modern
  :ensure t
  :config
  (setq org-modern-list
        '(?● ?○ ?• ?◦))

  (setq org-modern-star
        '(?◉ ?○ ?• ?◦))

  (setq org-modern-priority
        '((?A . "⚑")
          (?B . "↑")
          (?C . "↓"))))

(add-hook 'org-mode-hook #'org-display-inline-images)

(provide 'org-cfg)
