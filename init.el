(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)

(package-initialize)

(eval-when-compile (require 'use-package))

;; Packages

(use-package general
  :ensure t)

(use-package helm
  :ensure t
  :after general evil
  :init
  (require 'helm-config)
  :config
  (helm-mode 1)
  (general-define-key "M-x" #'helm-M-x)
  (general-define-key
    :keymaps 'helm-map
    "C-j" 'helm-next-line
    "C-h" 'helm-previous-line
    "TAB" 'helm-execute-persistent-action
    "ESC" 'helm-keyboard-quit)
  (general-evil-define-key
    'normal 'global
    :prefix "SPC"
    "." 'helm-find-files))

(use-package evil
  :ensure t
  :after general
  :config
  (evil-mode 1)
  (general-define-key
    :states 'normal
    "C-u" 'evil-scroll-up)
  )

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t))

;; Configuration

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
