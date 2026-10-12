;;; discord-rpc.el --- Discord Rich Presence client for Emacs -*- lexical-binding: t; -*-

;; Copyright (C) 2026 zaack1337

;; Author: zaack1337 <isaacgameramos@gmail.com>
;; Keywords: comm, games, tools
;; Package-Requires: ((emacs "27.1"))
;; Version: 1.0.0

;;; Commentary:

;; A small, dependency-free (besides built-in `json' and `project') client
;; for Discord's Rich Presence over the local IPC socket.
;;
;; It speaks the Discord IPC protocol directly:
;;
;;   [ opcode : u32 little-endian ][ length : u32 little-endian ][ json payload ]
;;
;; Opcodes: 0 = HANDSHAKE, 1 = FRAME, 2 = CLOSE, 3 = PING, 4 = PONG.
;;
;; Usage:
;;
;;   (require 'discord-rpc)
;;   (setq discord-rpc-application-id "123456789012345678")
;;   (discord-rpc-mode 1)
;;
;; The socket is discovered automatically on Linux/macOS ($XDG_RUNTIME_DIR,
;; /tmp, ...) including Snap and Flatpak locations.  On Windows it uses the
;; named pipe `\\\\.\\pipe\\discord-ipc-N'.
;;
;; If you do not have a Discord application, an IPC-compatible client such as
;; arRPC/Vesktop can be used with a placeholder application ID.

;;; Code:

(require 'json)
(require 'project)
(require 'cl-lib)

(defgroup discord-rpc nil
  "Discord Rich Presence."
  :group 'external
  :prefix "discord-rpc-")

(defcustom discord-rpc-application-id "000000000000000000"
  "Discord application (client) ID.

Create one at <https://discord.com/developers/applications> so the
application name and uploaded art assets are shown.  With IPC-compatible
relays (arRPC/Vesktop) a placeholder value is enough to display generic
activity."
  :type 'string)

(defcustom discord-rpc-timer-mode 'project
  "How the elapsed-time counter behaves.
`session' never resets during the Emacs session.
`project' resets whenever the current project changes.
`off' disables the timestamp entirely."
  :type '(choice (const session) (const project) (const off)))

(defcustom discord-rpc-show-project t
  "When non-nil, show the current project name."
  :type 'boolean)

(defcustom discord-rpc-show-file t
  "When non-nil, show the current file name."
  :type 'boolean)

(defcustom discord-rpc-show-major-mode nil
  "When non-nil, show the major mode when no file is available."
  :type 'boolean)

(defcustom discord-rpc-show-git-branch nil
  "When non-nil, show the current Git branch as the small text."
  :type 'boolean)

(defcustom discord-rpc-large-image-key "emacs"
  "Asset key (uploaded to the Discord app) used as the large image."
  :type 'string)

(defcustom discord-rpc-large-image-text "GNU Emacs"
  "Tooltip shown when hovering the large image."
  :type 'string)

(defcustom discord-rpc-update-interval 15
  "Seconds between automatic presence updates."
  :type 'integer)

(defcustom discord-rpc-idle-pause 300
  "Seconds of user idle time before the presence is cleared.
Set to nil to keep showing activity while idle."
  :type '(choice (const :tag "Never clear" nil) integer))

(defcustom discord-rpc-debug nil
  "When non-nil, log connection and protocol errors to *Messages*."
  :type 'boolean)

(defconst discord-rpc--opcode-handshake 0)
(defconst discord-rpc--opcode-frame 1)
(defconst discord-rpc--opcode-close 2)
(defconst discord-rpc--opcode-ping 3)
(defconst discord-rpc--opcode-pong 4)

(defvar discord-rpc--process nil)
(defvar discord-rpc-mode nil
  "Non-nil when Discord Rich Presence is enabled.")
(defvar discord-rpc--incoming "")
(defvar discord-rpc--timer nil)
(defvar discord-rpc--debounce-timer nil)
(defvar discord-rpc--start nil)
(defvar discord-rpc--current-project nil)

(defun discord-rpc--debug (fmt &rest args)
  (when discord-rpc-debug
    (apply #'message (concat "discord-rpc: " fmt) args)))

(defun discord-rpc--now-ms ()
  "Current time as milliseconds since the epoch."
  (truncate (* 1000 (float-time))))

(defun discord-rpc--u32-bytes (n)
  "Return N encoded as a 4-byte little-endian unibyte string."
  (unibyte-string (logand n #xFF)
                  (logand (ash n -8) #xFF)
                  (logand (ash n -16) #xFF)
                  (logand (ash n -24) #xFF)))

(defun discord-rpc--u32 (str offset)
  "Read a little-endian u32 from STR at OFFSET."
  (logior (aref str offset)
          (ash (aref str (+ offset 1)) 8)
          (ash (aref str (+ offset 2)) 16)
          (ash (aref str (+ offset 3)) 24)))

(defun discord-rpc--socket-dirs ()
  "Return a list of directories that may contain the Discord IPC socket."
  (delete-dups
   (delq nil
         (list (getenv "XDG_RUNTIME_DIR")
               (and (getenv "XDG_RUNTIME_DIR")
                    (expand-file-name ".flatpak/com.discordapp.Discord"
                                      (getenv "XDG_RUNTIME_DIR")))
               (and (getenv "XDG_RUNTIME_DIR")
                    (expand-file-name "app/com.discordapp.Discord"
                                      (getenv "XDG_RUNTIME_DIR")))
               (and (getenv "XDG_RUNTIME_DIR")
                    (expand-file-name "snap.discord" (getenv "XDG_RUNTIME_DIR")))
               (getenv "TMPDIR")
               (getenv "TMP")
               (getenv "TEMP")
               (expand-file-name (or (getenv "TMPDIR") "/tmp"))
               "/tmp"))))

(defun discord-rpc--socket-candidates ()
  "Return candidate IPC endpoint names, ordered by preference."
  (if (eq system-type 'windows-nt)
      (cl-loop for i from 0 below 10
               collect (format "\\\\.\\pipe\\discord-ipc-%d" i))
    (cl-loop for dir in (discord-rpc--socket-dirs)
             append (cl-loop for i from 0 below 10
                             collect (expand-file-name
                                      (format "discord-ipc-%d" i) dir)))))

(defun discord-rpc--live-p ()
  "Return non-nil when the IPC process is alive."
  (and discord-rpc--process (process-live-p discord-rpc--process)))

(defun discord-rpc--filter (_proc chunk)
  "Accumulate incoming bytes from CHUNK and parse complete packets."
  (setq discord-rpc--incoming (concat discord-rpc--incoming chunk))
  (discord-rpc--parse-incoming))

(defun discord-rpc--sentinel (proc _event)
  "Reset state when the IPC PROC dies."
  (unless (process-live-p proc)
    (when (eq proc discord-rpc--process)
      (setq discord-rpc--process nil))
    (discord-rpc--debug "connection closed")))

(defun discord-rpc--handle-frame (opcode payload)
  "Handle a decoded OPCODE with JSON PAYLOAD."
  (pcase opcode
    ((pred (= discord-rpc--opcode-ping))
     (discord-rpc--send discord-rpc--opcode-pong payload))
    ((pred (= discord-rpc--opcode-close))
     (setq discord-rpc--process nil))
    ((pred (= discord-rpc--opcode-frame))
     (discord-rpc--debug "frame: %s" payload))
    (_ nil)))

(defun discord-rpc--parse-incoming ()
  "Parse as many complete packets as possible from the input buffer."
  (catch 'incomplete
    (while t
      (when (< (length discord-rpc--incoming) 8)
        (throw 'incomplete nil))
      (let* ((opcode (discord-rpc--u32 discord-rpc--incoming 0))
             (len (discord-rpc--u32 discord-rpc--incoming 4)))
        (when (< (length discord-rpc--incoming) (+ 8 len))
          (throw 'incomplete nil))
        (let ((payload (substring discord-rpc--incoming 8 (+ 8 len))))
          (setq discord-rpc--incoming
                (substring discord-rpc--incoming (+ 8 len)))
          (discord-rpc--handle-frame
           opcode (decode-coding-string payload 'utf-8)))))))

(defun discord-rpc--connect ()
  "Connect to Discord's IPC socket.  Return non-nil on success."
  (if (discord-rpc--live-p)
      t
    (let ((endpoint (cl-find-if #'file-exists-p
                                (discord-rpc--socket-candidates))))
      (when endpoint
        (condition-case err
            (progn
              (setq discord-rpc--incoming "")
              (setq discord-rpc--process
                    (make-network-process
                     :name "discord-rpc"
                     :family 'local
                     :service endpoint
                     :coding 'binary
                     :noquery t
                     :filter #'discord-rpc--filter
                     :sentinel #'discord-rpc--sentinel))
              (discord-rpc--send
               discord-rpc--opcode-handshake
               (json-serialize `((v . 1)
                                 (client_id . ,discord-rpc-application-id))))
              (discord-rpc--debug "connected to %s" endpoint)
              t)
          (error
           (setq discord-rpc--process nil)
           (discord-rpc--debug "connect failed: %S" err)
           nil))))))

(defun discord-rpc--send (opcode payload)
  "Send OPCODE with PAYLOAD (string or JSON-serializable object)."
  (when (discord-rpc--live-p)
    (condition-case err
        (let* ((json (if (stringp payload)
                         payload
                       (json-serialize payload)))
               (bytes (encode-coding-string json 'utf-8))
               (len (string-bytes bytes)))
          (process-send-string discord-rpc--process
                               (concat (discord-rpc--u32-bytes opcode)
                                       (discord-rpc--u32-bytes len)
                                       bytes)))
      (error
       (discord-rpc--debug "send failed: %S" err)
       nil))))

(defun discord-rpc--nonce ()
  "Return a random nonce string."
  (format "%08x-%04x-%04x-%04x-%012x"
          (random (ash 1 32)) (random (ash 1 16)) (random (ash 1 16))
          (random (ash 1 16)) (random (ash 1 48))))

(defun discord-rpc--project-root ()
  "Return the current project root directory, or nil."
  (ignore-errors
    (when-let ((proj (project-current nil)))
      (project-root proj))))

(defun discord-rpc--project-name ()
  "Return the name of the current project, or nil."
  (when-let ((root (discord-rpc--project-root)))
    (file-name-nondirectory (directory-file-name root))))

(defun discord-rpc--git-branch ()
  "Return the current Git branch of the project, or nil."
  (when-let ((root (discord-rpc--project-root)))
    (let ((branch (string-trim
                   (shell-command-to-string
                    (format "git -C %s symbolic-ref --short -q HEAD 2>/dev/null"
                            (shell-quote-argument root))))))
      (unless (string-empty-p branch) branch))))

(defun discord-rpc--pretty-mode (mode)
  "Turn a major MODE symbol into a friendly string."
  (when mode
    (let ((name (symbol-name mode)))
      (when (string-suffix-p "-mode" name)
        (setq name (substring name 0 (- (length name) 5))))
      (capitalize (replace-regexp-in-string "[-_]" " " name)))))

(defun discord-rpc--clamp (str)
  "Sanitize STR to satisfy Discord's 2..128 character field limit."
  (when (and str (stringp str))
    (let ((s (string-trim (replace-regexp-in-string "[[:cntrl:]]+" " " str))))
      (when (> (length s) 128)
        (setq s (substring s 0 128)))
      (when (= (length s) 1)
        (setq s (concat s " ")))
      (unless (string-empty-p s) s))))

(defun discord-rpc--assets ()
  "Build the activity assets alist."
  (when (and discord-rpc-large-image-key
             (not (string-empty-p discord-rpc-large-image-key)))
    `((large_image . ,discord-rpc-large-image-key)
      (large_text . ,(or discord-rpc-large-image-text "GNU Emacs")))))

(defun discord-rpc--build-activity ()
  "Build the `activity' object sent to Discord, or nil to clear it."
  (let* ((project (discord-rpc--project-name))
         (file (and discord-rpc-show-file buffer-file-name
                    (file-name-nondirectory buffer-file-name)))
         (mode (and discord-rpc-show-major-mode
                    (discord-rpc--pretty-mode major-mode)))
         (branch (and discord-rpc-show-git-branch (discord-rpc--git-branch)))
         (details (discord-rpc--clamp
                   (if (and discord-rpc-show-project project)
                       project
                     "GNU Emacs")))
         (state (discord-rpc--clamp
                 (cond (branch (concat (or file mode "Editing") " | " branch))
                       (t (or file mode
                              (and discord-rpc-show-project project)
                              "Editing")))))
         (assets (discord-rpc--assets))
         (timestamps (when (and discord-rpc--start
                                (not (eq discord-rpc-timer-mode 'off)))
                       `((start . ,discord-rpc--start)))))
    (delq nil
          (list (when details (cons 'details details))
                (when state (cons 'state state))
                (when timestamps (cons 'timestamps timestamps))
                (when assets (cons 'assets assets))))))

(defun discord-rpc--maybe-reset-start ()
  "Reset the elapsed timer when the project changes (project timer mode)."
  (when (eq discord-rpc-timer-mode 'project)
    (let ((proj (discord-rpc--project-root)))
      (when (and proj (not (equal proj discord-rpc--current-project)))
        (setq discord-rpc--current-project proj
              discord-rpc--start (discord-rpc--now-ms))))))

(defun discord-rpc--idle-p ()
  "Return non-nil when the user has been idle for too long."
  (and discord-rpc-idle-pause
       (ignore-errors
         (when-let ((idle (current-idle-time)))
           (> (float-time idle) discord-rpc-idle-pause)))))

(defun discord-rpc--push (activity)
  "Send SET_ACTIVITY with ACTIVITY (nil clears the presence)."
  (discord-rpc--send
   discord-rpc--opcode-frame
   (json-serialize `((cmd . "SET_ACTIVITY")
                     (nonce . ,(discord-rpc--nonce))
                     (args . ((pid . ,(emacs-pid))
                              (activity . ,(or activity :null))))))))

(defun discord-rpc--update ()
  "Refresh the Discord presence."
  (when (discord-rpc--connect)
    (if (discord-rpc--idle-p)
        (discord-rpc--push nil)
      (discord-rpc--maybe-reset-start)
      (discord-rpc--push (discord-rpc--build-activity)))))

(defun discord-rpc--on-buffer-change (&rest _)
  "Debounce a presence update after a buffer/window change."
  (when (and discord-rpc-mode (not discord-rpc--debounce-timer))
    (setq discord-rpc--debounce-timer
          (run-with-idle-timer
           1.5 nil
           (lambda ()
             (setq discord-rpc--debounce-timer nil)
             (discord-rpc--update))))))

(defun discord-rpc--close ()
  "Close the IPC connection."
  (when (discord-rpc--live-p)
    (discord-rpc--send discord-rpc--opcode-close "{}")
    (ignore-errors (delete-process discord-rpc--process)))
  (setq discord-rpc--process nil))

;;;###autoload
(define-minor-mode discord-rpc-mode
  "Global minor mode publishing an Emacs Rich Presence to Discord."
  :global t
  (if discord-rpc-mode
      (progn
        (setq discord-rpc--start (discord-rpc--now-ms))
        (add-hook 'window-buffer-change-functions #'discord-rpc--on-buffer-change)
        (discord-rpc--update)
        (setq discord-rpc--timer
              (run-at-time discord-rpc-update-interval
                           discord-rpc-update-interval
                           #'discord-rpc--update)))
    (remove-hook 'window-buffer-change-functions #'discord-rpc--on-buffer-change)
    (when discord-rpc--debounce-timer
      (cancel-timer discord-rpc--debounce-timer)
      (setq discord-rpc--debounce-timer nil))
    (when discord-rpc--timer
      (cancel-timer discord-rpc--timer)
      (setq discord-rpc--timer nil))
    (discord-rpc--push nil)
    (discord-rpc--close)))

;;;###autoload
(defun discord-rpc-enable ()
  "Enable `discord-rpc-mode'."
  (interactive)
  (discord-rpc-mode 1))

;;;###autoload
(defun discord-rpc-disable ()
  "Disable `discord-rpc-mode'."
  (interactive)
  (discord-rpc-mode -1))

;;;###autoload
(defun discord-rpc-refresh ()
  "Force an immediate presence refresh."
  (interactive)
  (discord-rpc--update))

(provide 'discord-rpc)
;;; discord-rpc.el ends here
