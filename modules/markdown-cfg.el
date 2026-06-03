(use-package markdown-mode
    :ensure t
    :custom
    (markdown-fontify-code-blocks-natively t)
    (markdown-enable-wiki-links t)
    (markdown-italic-underscore t)
    (markdown-asymmetric-header t)
    (markdown-make-gfm-checkboxes-buttons t)
    (markdown-gfm-uppercase-checkbox t)
    (markdown-enable-math t)
    (markdown-content-type "application/xhtml+xml")
    :init
    (add-to-list 'auto-mode-alist
                             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode))
    :bind (:map markdown-mode-map
                            ("C-c C-e" . markdown-do)))

(provide 'markdown-cfg)
