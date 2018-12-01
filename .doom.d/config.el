;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(setq doom-line-numbers-style 'relative)
(setq neo-window-fixed-size nil)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(eval-after-load "evil"
  '(progn
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)))

;; Org
(setq org-log-done 'time)
(setq org-agenda-files '("~/Dropbox/org/"))
(add-hook 'org-mode-hook
          (lambda () (local-key-set (kbd "C-M-return") 'org-insert-subheading)))
