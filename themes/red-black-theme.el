;;; red-black-theme.el --- Red / Black / White theme -*- lexical-binding: t; -*-

(deftheme red-black
  "A brutalist red, black and white Emacs theme.")

(let ((black0 "#0a0a0a")
      (black1 "#111111")
      (black2 "#1a1a1a")
      (black3 "#313131")
      (black4 "#333333")
      (black5 "#444444")

      (red0 "#8b0000")
      (red1 "#aa0000")
      (red2 "#cc1111")
      (red3 "#dd2222")
      (red4 "#ff3333")

      (white0 "#aaaaaa")
      (white1 "#cccccc")
      (white2 "#e8e8e8")
      (white3 "#ffffff"))

  (custom-theme-set-faces
   'red-black

   ;; ─────────────────────────────────────────
   ;; Base
   ;; ─────────────────────────────────────────

   `(default
     ((t (:background ,black0 :foreground ,white1))))

   `(cursor
     ((t (:background ,red2))))

   `(fringe
     ((t (:background ,black0 :foreground ,black4))))

   `(vertical-border
     ((t (:foreground ,black3))))

   `(border
     ((t (:foreground ,black3))))

   `(minibuffer-prompt
     ((t (:foreground ,red3 :weight bold))))

   `(region
     ((t (:background ,red0))))

   `(highlight
     ((t (:background ,black2))))

   `(hl-line
     ((t (:background ,black2))))

   `(secondary-selection
     ((t (:background ,red0))))

   `(isearch
     ((t (:foreground ,black0
          :background ,red3
          :weight bold))))

   `(isearch-fail
     ((t (:foreground ,white3
          :background ,red4
          :weight bold))))

   `(lazy-highlight
     ((t (:foreground ,black0
          :background ,red3))))

   ;; ─────────────────────────────────────────
   ;; Line numbers
   ;; ─────────────────────────────────────────

   `(line-number
     ((t (:foreground ,black4
          :background ,black0))))

   `(line-number-current-line
     ((t (:foreground ,red2
          :background ,black2
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Mode line
   ;; ─────────────────────────────────────────

   `(mode-line
     ((t (:foreground ,white1
          :background ,black2
          :box nil))))

   `(mode-line-inactive
     ((t (:foreground ,black4
          :background ,black1
          :box nil))))

   ;; ─────────────────────────────────────────
   ;; Header / tab line
   ;; ─────────────────────────────────────────

   `(header-line
     ((t (:foreground ,white0
          :background ,black1))))

   `(tab-bar
     ((t (:foreground ,black4
          :background ,black1))))

   `(tab-bar-tab
     ((t (:foreground ,red2
          :background ,black0
          :weight bold))))

   `(tab-bar-tab-inactive
     ((t (:foreground ,black4
          :background ,black1))))

   ;; ─────────────────────────────────────────
   ;; Font lock
   ;; ─────────────────────────────────────────

   `(font-lock-comment-face
     ((t (:foreground ,black4
          :slant italic))))

   `(font-lock-comment-delimiter-face
     ((t (:foreground ,black4
          :slant italic))))

   `(font-lock-string-face
     ((t (:foreground ,white0))))

   `(font-lock-constant-face
     ((t (:foreground ,white2))))

   `(font-lock-number-face
     ((t (:foreground ,red2))))

   `(font-lock-keyword-face
     ((t (:foreground ,red3
          :weight bold))))

   `(font-lock-builtin-face
     ((t (:foreground ,red3
          :weight bold))))

   `(font-lock-function-name-face
     ((t (:foreground ,white3
          :weight bold))))

   `(font-lock-variable-name-face
     ((t (:foreground ,white1))))

   `(font-lock-type-face
     ((t (:foreground ,white2
          :weight bold))))

   `(font-lock-warning-face
     ((t (:foreground ,red4
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Parentheses / delimiters
   ;; ─────────────────────────────────────────

   `(show-paren-match
     ((t (:foreground ,red4
          :weight bold
          :underline t))))

   `(show-paren-mismatch
     ((t (:foreground ,white3
          :background ,red4
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Errors / warnings
   ;; ─────────────────────────────────────────

   `(error
     ((t (:foreground ,red4
          :weight bold))))

   `(warning
     ((t (:foreground ,red3
          :weight bold))))

   `(success
     ((t (:foreground ,white2
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Compilation
   ;; ─────────────────────────────────────────

   `(compilation-error
     ((t (:foreground ,red4
          :weight bold))))

   `(compilation-warning
     ((t (:foreground ,red2))))

   `(compilation-info
     ((t (:foreground ,white0))))

   ;; ─────────────────────────────────────────
   ;; Org mode
   ;; ─────────────────────────────────────────

   `(org-level-1
     ((t (:foreground ,red3
          :weight bold
          :height 1.25))))

   `(org-level-2
     ((t (:foreground ,red2
          :weight bold
          :height 1.15))))

   `(org-level-3
     ((t (:foreground ,white3
          :weight bold))))

   `(org-level-4
     ((t (:foreground ,white2
          :weight bold))))

   `(org-link
     ((t (:foreground ,red3
          :underline t))))

   `(org-code
     ((t (:foreground ,white0
          :background ,black1))))

   `(org-block
     ((t (:foreground ,white1
          :background ,black1))))

   `(org-block-begin-line
     ((t (:foreground ,black5
          :background ,black1))))

   `(org-block-end-line
     ((t (:foreground ,black5
          :background ,black1))))

   ;; ─────────────────────────────────────────
   ;; Completion / minibuffer
   ;; ─────────────────────────────────────────

   `(completions-common-part
     ((t (:foreground ,red3
          :weight bold))))

   `(completions-first-difference
     ((t (:foreground ,red4
          :weight bold))))

   `(completions-highlight
     ((t (:background ,red0
          :foreground ,white3
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Company / Corfu
   ;; ─────────────────────────────────────────

   `(company-tooltip
     ((t (:foreground ,white1
          :background ,black2))))

   `(company-tooltip-selection
     ((t (:foreground ,white3
          :background ,red1
          :weight bold))))

   `(company-tooltip-common
     ((t (:foreground ,red3
          :weight bold))))

   `(corfu-default
     ((t (:foreground ,white1
          :background ,black2))))

   `(corfu-current
     ((t (:foreground ,white3
          :background ,red1
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Dired
   ;; ─────────────────────────────────────────

   `(dired-directory
     ((t (:foreground ,red3
          :weight bold))))

   `(dired-header
     ((t (:foreground ,red2
          :weight bold))))

   `(dired-flagged
     ((t (:foreground ,red4
          :weight bold))))

   `(dired-mark
     ((t (:foreground ,red3
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Magit
   ;; ─────────────────────────────────────────

   `(magit-section-heading
     ((t (:foreground ,red3
          :weight bold))))

   `(magit-section-highlight
     ((t (:background ,black2))))

   `(magit-branch-local
     ((t (:foreground ,white2))))

   `(magit-branch-remote
     ((t (:foreground ,red3))))

   `(magit-diff-added
     ((t (:foreground ,white1
          :background ,black1))))

   `(magit-diff-removed
     ((t (:foreground ,red4
          :background ,black1))))

   ;; ─────────────────────────────────────────
   ;; Flycheck / Flymake
   ;; ─────────────────────────────────────────

   `(flycheck-error
     ((t (:underline (:style wave :color ,red4)))))

   `(flycheck-warning
     ((t (:underline (:style wave :color ,red2)))))

   `(flymake-error
     ((t (:underline (:style wave :color ,red4)))))

   `(flymake-warning
     ((t (:underline (:style wave :color ,red2)))))

   ;; ─────────────────────────────────────────
   ;; Links
   ;; ─────────────────────────────────────────

   `(link
     ((t (:foreground ,red3
          :underline t))))

   ;; ─────────────────────────────────────────
   ;; Org agenda / TODO
   ;; ─────────────────────────────────────────

   `(org-todo
     ((t (:foreground ,red4
          :weight bold))))

   `(org-done
     ((t (:foreground ,black5
          :weight bold))))

   `(org-warning
     ((t (:foreground ,red3
          :weight bold))))

   ;; ─────────────────────────────────────────
   ;; Messages
   ;; ─────────────────────────────────────────

   `(warning
     ((t (:foreground ,red3))))

   `(error
     ((t (:foreground ,red4
          :weight bold))))

   `(success
     ((t (:foreground ,white2
          :weight bold))))

   ))

;;;###autoload
(add-to-list 'custom-theme-load-path
             (file-name-directory (or load-file-name buffer-file-name)))

(provide-theme 'red-black)

;;; red-black-theme.el ends here
