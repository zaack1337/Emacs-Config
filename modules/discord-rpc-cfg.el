;;; discord-rpc-cfg.el --- Discord Rich Presence -*- lexical-binding: t; -*-
;; Biblioteca em ~/.emacs.d/lisp/discord-rpc/discord-rpc.el

(require 'discord-rpc)

;; Application ID do app no Discord Developer Portal.
;; Faca upload de um asset chamado "emacs" para o logo no Rich Presence.
(setq discord-rpc-application-id "1559320390637981718"
      discord-rpc-timer-mode 'project
      discord-rpc-show-project t
      discord-rpc-show-file t
      discord-rpc-show-major-mode nil
      discord-rpc-show-git-branch nil
      discord-rpc-update-interval 15
      discord-rpc-idle-pause 300
      discord-rpc-large-image-key "emacs"
      discord-rpc-large-image-text "GNU Emacs")

(discord-rpc-mode 1)

(provide 'discord-rpc-cfg)
;;; discord-rpc-cfg.el ends here
