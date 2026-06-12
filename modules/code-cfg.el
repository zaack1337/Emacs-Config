;; eglot
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-ts-mode))

(defun my/corfu-setup ()
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'eglot-completion-at-point
                     #'cape-file
                     #'cape-dabbrev))))


(use-package eglot
  :ensure nil
  :init
  :hook ((c-ts-mode
	  rust-ts-mode
	  python-ts-mode)
	 . eglot-ensure)
  :config
  (add-hook 'eglot-managed-mode-hook #'my/corfu-setup))

;; treesit
(use-package treesit-auto
  :ensure t
  :config
  (global-treesit-auto-mode)
  (setq treesit-auto-install 'prompt)

  :init
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash.git" "v0.23.3"))
        (c . ("https://github.com/tree-sitter/tree-sitter-c.git" "v0.23.6"))
	(cpp . ("https://github.com/tree-sitter/tree-sitter-cpp.git" "v0.23.4"))
	(css . ("https://github.com/tree-sitter/tree-sitter-css.git" "v0.23.2"))
	(dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile" "v0.2.0"))
	(elixir . ("https://github.com/elixir-lang/tree-sitter-elixir" "v0.3.4"))
	(html . ("https://github.com/tree-sitter/tree-sitter-html.git" "v0.23.2"))
	(json . ("https://github.com/tree-sitter/tree-sitter-json.git" "v0.24.8"))
	(lua . ("https://github.com/tree-sitter-grammars/tree-sitter-lua" "v0.3.0"))
	(python . ("https://github.com/tree-sitter/tree-sitter-python.git" "v0.23.6"))
	(rust . ("https://github.com/tree-sitter/tree-sitter-rust.git" "v0.23.3"))
	(yaml . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml.git" "v0.7.2"))
	(tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
	(typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
	(javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "v0.21.2" "src"))
	))
  :ensure t
  )

;; corfu - auto Complete
(use-package corfu
  :ensure t
  :init
  (global-corfu-mode)
  (setq corfu-auto t)
  (setq corfu-auto-delay 0.1))

(use-package cape
  :ensure t
  )

(electric-pair-mode 1)

(provide 'code-cfg)
