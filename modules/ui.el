(setq inhibit-startup-message t) ; Tchauzinho buffer S2

(tool-bar-mode -1) ; oculta a barra de ferramentas
(menu-bar-mode -1) ; oculta a barra de menu
(scroll-bar-mode -1) ; oculta a barra de rolagem
(tooltip-mode -1) ; oculta dicas

(global-display-line-numbers-mode t) ; enumeração de linhas
;; (global-hl-line-mode t) destaca linha atual
(column-number-mode t) ; exibe coluna atual

;; espaçamento das bordas laterais
(set-fringe-mode 10)

;; rolagem suave
(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse t
      scroll-step 1)

;; quebra de linha visual
(global-visual-line-mode t)

;; tema
(load-theme 'nimbus t)

;; tipo de cursor
(setq-default cursor-type 'bar)

;; Fonte
(set-face-attribute 'default nil :font "Roboto Mono" :height 120)

;; Tranparencia
(use-package ultra-scroll)
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;; Icones
(use-package nerd-icons
:ensure t
:custom
(nerd-icons-font-family "JetBrainsMono Nerd Font Mono"))
(use-package nerd-icons-dired
  :ensure t
  :hook (dired-mode . nerd-icons-dired-mode))

;; Modeline
(use-package doom-modeline 
  :init (doom-modeline-mode 1)
  :ensure t
  )

(provide 'ui)
