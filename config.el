(setq user-full-name "artur sharipov"
      user-mail-address "theartua@gmail.com")

(setq doom-localleader-key ",")


(use-package reverse-im
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))


(setq mac-right-option-modifier 'control)

(exec-path-from-shell-initialize)

(setq display-line-numbers-type nil)
(global-display-line-numbers-mode 0)

(map! :leader
      :desc "Commands"
      "SPC" 'fzf-projectile)

(setq cider-save-file-on-load t)

(after! cider
  (setq cider-repl-pop-to-buffer-on-connect nil)
  (set-popup-rule! "^\\*cider-repl*" :size 0.4 :side 'right :select t :quit nil :ttl nil)
  (set-popup-rule! "^\\*cider-error*" :size 0.4 :side 'bottom :select t :quit t)
  (setq cljr-assume-language-context 'clj)
  ;; (setq cider-eldoc-display-for-symbol-at-point nil) ; disable cider showing eldoc during symbol at point

  ;; (setq clojure-indent-style 'align-arguments)
  ;; (setq clojure-align-forms-automatically nil)
  )

;; clj debug
(defun clj-insert-persist-scope-macro ()
  (interactive)
  (insert
   "(defmacro persist-scope
              \"Takes local scope vars and defines them in the global scope. Useful for RDD\"
              []
              `(do ~@(map (fn [v] `(def ~v ~v))
                  (keys (cond-> &env (contains? &env :locals) :locals)))))"))

(defun persist-scope ()
  (interactive)
  (let ((beg (point)))
    (clj-insert-persist-scope-macro)
    (cider-eval-region beg (point))
    (delete-region beg (point))
    (insert "(persist-scope)")
    (cider-eval-defun-at-point)
    (delete-region beg (point))))

(setq doom-theme 'doom-one)

(setq doom-font (
font-spec :family "iosevka"
:size 14))

(set-face-attribute 'flyspell-incorrect nil :underline '(:color "#ffc800" :style wave))

(add-to-list 'load-path "/opt/homebrew/Cellar/mu/1.6.10/share/emacs/site-lisp/mu/mu4e")

(setq
 mue4e-headers-skip-duplicates t
 mu4e-view-show-images t
 mu4e-view-show-addresses t
 mu4e-use-fancy-chars t
 mu4e-compose-format-flowed nil
 mu4e-date-format "%y/%m/%d"
 mu4e-headers-date-format "%Y/%m/%d"
 mu4e-change-filenames-when-moving t)

(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it
   starttls-use-gnutls t
   smtpmail-starttls-credentials '(("smtp.gmail.com" 587 nil nil))
   smtpmail-auth-credentials
     '(("smtp.gmail.com" 587 "USERNAME@gmail.com" nil))
   smtpmail-default-smtp-server "smtp.gmail.com"
   smtpmail-smtp-server "smtp.gmail.com"
   smtpmail-smtp-service 587)

(set-email-account! "theartua"
  '((smtpmail-smtp-user     . "theartua@gmail.com"))
  t)

(set-email-account! "hs"
  '((smtpmail-smtp-user     . "artur.sharipov@health-samurai.io")
    ;; (smtpmail-smtp-server "smtp.gmail.com")
    ;; (smtpmail-smtp-service 587)
    ) t)

(setq mu4e-context-policy 'ask-if-none
      mu4e-compose-context-policy 'always-ask)

(setq rmh-elfeed-org-files '("/Users/artua/org/elfeed.org"))

(map! :leader
      (:prefix "o"
        :desc "Elfeed" "e" 'elfeed))

(map! (:map elfeed-search-mode-map
       :localleader
       :desc "Update feed"
       "u" #'elfeed-update))

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)

(setq evil-move-cursor-back nil)

(setq x-select-enable-clipboard t)

(use-package super-save
  :config
  (add-to-list 'super-save-hook-triggers 'find-file-hook)
  (setq super-save-remote-files nil)
  (setq super-save-exclude '(".gpg", ".pyc", ".elc"))
  (setq super-save-auto-save-when-idle t)
  (setq auto-save-default nil)
  (super-save-mode +1))

(use-package! evil-lisp-state
  :init
  (setq evil-lisp-state-global t)
  :config
  (map! :leader :desc "lisp" "k" evil-lisp-state-map))

(after! which-key
  (add-to-list
    'which-key-replacement-alist
    '((nil . "evil-lisp-state-") . (nil . ""))))

(map! :v "s" #'evil-surround-region)

(map! :leader
      ;;"TAB" #'evil-switch-to-windows-last-buffer
      "p a" #'projectile-toggle-between-implementation-and-test)

(map! :n "C-w" #'er/expand-region
      :m "C-w" #'er/expand-region
      :i "C-w" #'er/expand-region
      :r "C-w" #'er/expand-region
      :v "C-w" #'er/expand-region)

(map! (:after helm-files :map (helm-find-files-map helm-read-file-map)
       "C-h" #'helm-find-files-up-one-level
       "C-j" #'helm-next-line
       "C-k" #'helm-previous-line
       "C-l" #'helm-execute-persistent-action))

(map! "s-P" #'helm-M-x
      "s-p" #'helm-projectile
      "s-o" #'helm-find-files
      "s-O" #'imenu
      "s-b" #'+neotree/open
      ;; "s-b" #'fzf-switch-buffer
      "s-w" #'kill-current-buffer
      "s-g" #'magit-status
      "s-d" #'evil-multiedit-match-and-next
      "s-." #'lsp-execute-code-action)

(setq org-directory "~/org/")

(defun notify-osx (title message)
  (call-process "terminal-notifier"
                nil 0 nil
                "-group" "Emacs"
                "-title" title
                "-sender" "org.gnu.Emacs"
                "-message" message))

(add-hook 'org-pomodoro-finished-hook
          (lambda ()
          (notify-osx "Pomodoro completed!" "Time for a break.")))

(add-hook 'org-pomodoro-break-finished-hook
          (lambda ()
          (notify-osx "Pomodoro Short Break Finished" "Ready for Another?")))

(add-hook 'org-pomodoro-long-break-finished-hook
          (lambda ()
          (notify-osx "Pomodoro Long Break Finished" "Ready for Another?")))

(add-hook 'org-pomodoro-killed-hook
          (lambda ()
          (notify-osx "Pomodoro Killed" "One does not simply kill a pomodoro!")))

(use-package ob-tmux
  ;; Install package automatically (optional)
  :ensure t
  :custom
  (org-babel-default-header-args:tmux
   '((:results . "silent")	;
     (:session . "default")	; The default tmux session to send code to
     (:socket  . nil)))		; The default tmux socket to communicate with
  ;; The tmux sessions are prefixed with the following string.
  ;; You can customize this if you like.
  (org-babel-tmux-session-prefix "ob-")
  ;; The terminal that will be used.
  ;; You can also customize the options passed to the terminal.
  ;; The default terminal is "gnome-terminal" with options "--".
  ;;
  ;; Directly to emacs window:
  ;; #!/bin/bash
  ;; emacsclient -e "(progn (vterm) (vterm-send-string \"$*\") (vterm-send-return))"
  (org-babel-tmux-terminal "/Applications/Alacritty.app/Contents/MacOS/alacritty")
  (org-babel-tmux-terminal-opts '("-t" "ob-tmux" "-e")))
