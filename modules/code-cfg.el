(use-package eglot
  :ensure t
  :init
(add-hook 'prog-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'rust-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'eglot-ensure)
)

(provide 'code-cfg)
