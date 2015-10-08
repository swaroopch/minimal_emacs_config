
;; Basics
(setq echo-keystrokes 0.02)

;; Encoding
(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)
(setq coding-system-for-write 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

;; UI
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Font
(set-frame-font "Fira Mono-14" nil t)

;; Package management
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-refresh-contents)
(package-initialize)

;; From Emacs Prelude
(defun require-package (package)
  (unless (package-installed-p package)
    (package-install package)))

(defun require-packages (packages)
  (mapc #'require-package packages))

(defvar my-packages
  '(helm
    org
    solarized-theme))

(require-packages my-packages)

;; Solarized theme
(defvar solarized-use-variable-pitch nil)
(defvar solarized-scale-org-headlines nil)
(require 'solarized)
(load-theme 'solarized-light t)

;; Helm mainly for Org jumping, but since it's loaded anyway, use everywhere.
(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h f") 'helm-apropos)

;; From Spacemacs
(require 'helm)
;; Swap default TAB and C-z commands.
;; For GUI.
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
;; For terminal.
(define-key helm-map (kbd "TAB") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-z") 'helm-select-action)

;;; Org Mode ;;;
(global-set-key (kbd "C-c c") 'org-capture)

(require 'org)
(require 'org-id)
(require 'org-habit)
(require 'org-attach)
(add-to-list 'org-modules 'org-habit)

;; Default directory
(setq org-directory "~/Box/")

;; Disable flycheck in Org Mode
;; (add-hook 'org-mode-hook (lambda ()
;;                            (flycheck-mode -1)))

;; Display inline images
(setq org-startup-with-inline-images t)

;; Capture
;; http://orgmode.org/manual/Setting-up-capture.html
(setq org-default-notes-file (concat org-directory "inbox.org"))

;; ~<Leader> o~ is the open space for user-defined shortcuts
;; http://orgmode.org/org.html#Capture-templates
;; (global-set-key (kbd "C-c o c") 'org-capture)
(setq org-capture-templates
      '(("i" "Inbox" entry (file+headline (concat org-directory "inbox.org")
                                          "Inbox")
         "* TODO %?\n  %U\n  %i\n")
        ("d" "Diary" entry (file+datetree (concat org-directory "diary.org"))
         "* %?\n  %i\n")
        ("f" "Food" entry (file+datetree (concat org-directory "food.org"))
         "* %?\n  %i\n")))

;; Link abbreviations
;; http://orgmode.org/manual/Link-abbreviations.html
(setq org-link-abbrev-alist
      '(("task" . "https://phabricator.automatic.co/%s")
        ("diff" . "https://phabricator.automatic.co/%s")))

;; Agenda
(setq org-agenda-files (list (concat org-directory "automatic.org")
                             (concat org-directory "control.org")
                             (concat org-directory "inbox.org")))
(setq org-agenda-span 2)
(setq org-agenda-start-on-weekday nil)

;; http://orgmode.org/worg/org-faq.html#agenda-wrong-time-of-day
(setq org-agenda-search-headline-for-time nil)

;; TODO states
;; ! indicates insert timestamp
;; @ indicates insert note
;; / indicates entering the state
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAITING(w)" "SOMEDAY/MAYBE(s)"
                  "DELEGATED(g!)"
                  "|"
                  "DONE(d!)" "CANCELLED(c@)")))

;; Don't show DONE in agenda
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)

;; Log into a drawer
;; http://stackoverflow.com/a/8198018/4869
(setq org-log-into-drawer t)
(setq org-clock-into-drawer "CLOCK")
(setq org-clock-idle-time 10)

;; Effort estimation
;; http://orgmode.org/worg/doc.html#org-effort-durations
;; (defvar swa/org-hour 60)
;; (defvar swa/org-day (* 4 swa/org-hour))
;; (defvar swa/org-week (* 5 swa/org-day))
;; (defvar swa/org-month (* 4 swa/org-week))
;; (defvar swa/org-year (* 10 swa/org-month))
;; (setq org-effort-durations
;;       '(("h" . swa/org-hour)
;;         ("d" . swa/org-day)
;;         ("w" . swa/org-week)
;;         ("m" . swa/org-month)
;;         ("y" . swa/org-year)))
(setq org-effort-durations
      '(("h" . 60)
        ("d" . 240)
        ("w" . 1200)
        ("m" . 4800)
        ("y" . 48000)))

;; Code Blocks
;; http://stackoverflow.com/a/10643120/4869
(setq org-src-fontify-natively t)

;; Key bindings
(org-defkey org-mode-map "\C-c\C-j" 'helm-org-in-buffer-headings)

;; Shortcuts to commonly-used Org files
(global-set-key (kbd "s-1") (lambda ()
                              (interactive)
                              (find-file (concat org-directory "automatic.org"))))

(global-set-key (kbd "s-2") (lambda ()
                              (interactive)
                              (find-file (concat org-directory "control.org"))))

(global-set-key (kbd "s-3") (lambda ()
                              (interactive)
                              ;; ~C-c a a~
                              (org-agenda-list)))

(global-set-key (kbd "s-4") (lambda ()
                              (interactive)
                              (find-file (concat org-directory "inbox.org"))))

(global-set-key (kbd "s-5") (lambda ()
                              (interactive)
                              (find-file (concat org-directory "reference.org"))))

;; Line-breaking
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; Spell check
(add-hook 'org-mode-hook '(lambda () (flyspell-mode -1)))

;; Refile settings
;; Taken from https://github.com/vedang/emacs-config/blob/master/configuration/org-mode-config.el
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 4)
                                 (nil :maxlevel . 4)))
      ;; Targets start with the file name - allows creating level 1 tasks
      org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm)

;;; init.el ends here
