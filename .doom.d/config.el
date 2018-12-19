;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(load-file "~/.doom.d/bh.el")

(setq display-line-numbers-type 'relative)
(setq tab-width 2)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(eval-after-load "evil"
  '(progn
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)))
(setq mac-function-modifier 'meta)
(setq mac-option-modifier nil)

(setq treemacs-indentation 1)

(setq evil-snipe-scope 'buffer)

;; Org
(require 'org-habit)
(setq org-default-notes-file (expand-file-name "~/Dropbox/org/refile.org"))
(setq org-log-done 'time)
(setq org-agenda-files '("~/Dropbox/org/"))
;; (add-hook 'org-mode-hook
;;           (lambda () (local-key-set (kbd "C-M-return") 'org-insert-subheading)))
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((tags-todo "-CANCELLED-hobby/!NEXT"
                ((org-agenda-overriding-header "Next tasks:")))
          (tags-todo "-HOLD-CANCELLED/!"
                ((org-agenda-overriding-header "Projects:")
                (org-agenda-skip-function 'bh/skip-non-projects)
                ;; (org-tags-match-list-sublevels 'indented)
                ))
          (tags-todo "-REFILE-read-hobby/!-NEXT"
                ((org-agenda-overriding-header "Standalone tasks:")
                (org-agenda-skip-function 'bh/skip-project-tasks)
                (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)))
          (tags-todo "+read"
                ((org-agenda-overriding-header "Reading list:")))
          (tags-todo "+hobby"
                ((org-agenda-overriding-header "Hobby tasks:")))))))
(setq org-agenda-start-day "-1d")
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-span 5)
(setq org-capture-templates
    '(("t" "Todo" entry (file org-default-notes-file)
    "* TODO %?\n%u\n" :clock-in t :clock-resume t)
      ("n" "Next" entry (file org-default-notes-file)
       "* NEXT %?\n%u\n%a\n", :clock-in t :clock-resume t)))
(add-hook! org-agenda-mode #'toggle-truncate-lines)

;; TypeScript
(def-package! typescript-mode
  :mode "\\.ts$"
  :config
  (add-hook 'typescript-mode-hook #'rainbow-delimiters-mode)

  (set! :electric 'typescript-mode :chars '(?\} ?\)) :words '("||" "&&"))

  ;; TODO tide-jump-back
  ;; TODO (tide-jump-to-definition t)
  ;; TODO convert into keybinds
  ;; (set! :emr 'typescript-mode
  ;;       '(tide-find-references             "find usages")
  ;;       '(tide-rename-symbol               "rename symbol")
  ;;       '(tide-jump-to-definition          "jump to definition")
  ;;       '(tide-documentation-at-point      "current type documentation")
  ;;       '(tide-restart-server              "restart tide server"))
  )


(def-package! tide
  :after typescript-mode
  :config
  (set! :company-backend 'typescript-mode '(company-tide))
  (defun +typescript|init-tide ()
    (when (or (eq major-mode 'typescript-mode)
              (and (eq major-mode 'web-mode)
                   buffer-file-name
                   (equal (file-name-extension buffer-file-name) "tsx")))
      (tide-setup)
      (flycheck-mode +1)
      (eldoc-mode +1)
      (setq tide-project-root (doom-project-root))))
  (add-hook! (typescript-mode web-mode) #'+typescript|init-tide))

;; Use prettier_d for faster formatting
(setq prettier-js-command "prettier_d")
(setq prettier-js-args '("--pkg-conf"))
(add-hook! (typescript-mode web-mode) #'prettier-js-mode)

(defun org-find-file () (interactive)
  (helm-find-files-1 "~/Dropbox/org/"))

;; Keybindings
(map! :leader
      (:desc "file" :prefix "f"
        :desc "Find in files"             :n "s" #'helm-do-ag-project-root
        )
      (:desc "git" :prefix "g"
        :desc "Branch popup"              :n "b"  #'magit-branch-popup
        )
      (:desc "open / org" :prefix "o"
        :desc "Find org file"             :n "." #'org-find-file
        :desc "Save org buffers"          :n "s" #'org-save-all-org-buffers
        :desc "Open shell in project"     :n "t" #'projectile-run-shell)
      (:desc "toggle" :prefix "t"         :n "w" #'toggle-truncate-lines))
