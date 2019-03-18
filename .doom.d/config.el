;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(load-file "~/.doom.d/bh.el")

(setq display-line-numbers-type 'relative)
(setq tab-width 2)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq mac-function-modifier 'meta)
(setq mac-option-modifier nil)

(setq treemacs-indentation 1)
(setq evil-snipe-scope 'buffer)

(require 'helm-descbinds)
(helm-descbinds-mode)

(require 'keychain-environment)
(keychain-refresh-environment)

;; Keybindings
(map! :leader
      (:desc "file" :prefix "f"
        :desc "Find in files"                          :n "s" #'helm-do-ag-project-root
        :desc "Rename current file"                    :n "n" #'rename-current-buffer-file)
      (:desc "git" :prefix "g"
        :desc "Branch popup"                           :n "b"  #'magit-branch-popup)
      (:desc "open / org" :prefix "o"
        :desc "Find org file"                          :n "." #'org-find-file
        :desc "Save org buffers"                       :n "s" #'org-save-all-org-buffers
        :desc "Open shell in project"                  :n "t" #'projectile-run-shell)
      (:desc "toggle" :prefix "t"                      :n "w" #'toggle-truncate-lines)
      (:prefix "w" :desc "toggle-window-split"         :n "t" #'toggle-window-split))

(eval-after-load "evil"
  '(progn
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
     ;; Make evil-mode up/down operate in screen lines instead of logical lines
     (define-key evil-motion-state-map "j" 'evil-next-visual-line)
     (define-key evil-motion-state-map "k" 'evil-previous-visual-line)
     ;; Also in visual mode
     (define-key evil-visual-state-map "j" 'evil-next-visual-line)
     (define-key evil-visual-state-map "k" 'evil-previous-visual-line)))

;; Org
(require 'org-habit)
(setq org-default-notes-file (expand-file-name "~/Dropbox/org/refile.org"))
(setq org-log-done 'time)
(setq org-agenda-files '("~/Dropbox/org/"))
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "PROGRESS(p)" "|" "DONE(d)")
                         (sequence "[ ](T)" "|" "[X](D)")))
(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((tags-todo "-hobby/!PROGRESS"
                ((org-agenda-overriding-header "In progress:")))
          (tags-todo "-CANCELLED-hobby/!NEXT"
                ((org-agenda-overriding-header "Next tasks:")))
          (tags-todo "-REFILE-read-hobby/!TODO"
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
       "* NEXT %?\n%u\n", :clock-in t :clock-resume t)))
(add-hook! org-agenda-mode #'toggle-truncate-lines)

;; TypeScript
(def-package! typescript-mode
  :mode "\\.ts$"
  :config
  (add-hook 'typescript-mode-hook #'rainbow-delimiters-mode))

(def-package! tide
  :after typescript-mode
  :config
  (defun +typescript|init-tide ()
    (when (or (eq major-mode 'typescript-mode)
              (and (eq major-mode 'web-mode)
                   buffer-file-name
                   (equal (file-name-extension buffer-file-name) "tsx")))
      (setq flycheck-check-syntax-automatically '(save mode-enabled))
      (tide-setup)
      (flycheck-mode +1)
      (eldoc-mode +1)
      (company-mode +1)
      (setq tide-project-root (doom-project-root))))
  (add-hook! (typescript-mode web-mode) #'+typescript|init-tide))

;; Use prettier_d for faster formatting
(setq prettier-js-command "prettier_d")
(setq prettier-js-args '("--pkg-conf"))
(add-hook! (typescript-mode web-mode) #'prettier-js-mode)

(add-to-list 'auto-mode-alist '("\\.restclient\\'" . restclient-mode))

;; Custom functions

(defun org-find-file () (interactive)
  (helm-find-files-1 "~/Dropbox/org/"))

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

(defun yank-filename ()
  "Put the current file name on the clipboard"
  (interactive)
  (kill-new (buffer-file-name)))

;; Keep region when undoing in region
(defadvice undo-tree-undo (around keep-region activate)
  (if (use-region-p)
      (let ((m (set-marker (make-marker) (mark)))
            (p (set-marker (make-marker) (point))))
        ad-do-it
        (goto-char p)
        (set-mark m)
        (set-marker p nil)
        (set-marker m nil))
    ad-do-it))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical split"
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting"
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))
