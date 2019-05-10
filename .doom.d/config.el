;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-
(load-file "~/.doom.d/bh.el")
(load-file "~/.doom.d/org-exports/flowdock.el")
(load-file "~/.doom.d/org-exports/lever.el")

(setq display-line-numbers-type 'relative)
(setq tab-width 2)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)

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
        :desc "Open shell in project"                  :n "t" #'projectile-run-shell
        :desc "Agenda"                                 :n "a" #'org-agenda
        (:desc "Clocking" :prefix "c"
          :desc "Clock in"                             :n "i" #'org-clock-in
          :desc "Clock in last"                        :n "l" #'org-clock-in-last
          :desc "Clock out"                            :n "o" #'org-clock-out))
      (:desc "toggle" :prefix "t"                      :n "w" #'toggle-truncate-lines)
      (:prefix "w" :desc "toggle-window-split"         :n "t" #'toggle-window-split))

(eval-after-load "evil"
  '(progn
     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
     (define-key evil-normal-state-map (kbd "C-S-h") 'buf-move-left)
     (define-key evil-normal-state-map (kbd "C-S-l") 'buf-move-right)
     (define-key evil-normal-state-map (kbd "C-S-k") 'buf-move-up)
     (define-key evil-normal-state-map (kbd "C-S-j") 'buf-move-down)
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
(setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")
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

;; Common settings for all reviews
(setq efs/org-agenda-review-settings
      '((org-agenda-show-all-dates t)
        (org-agenda-start-with-log-mode t)
        (org-agenda-start-with-clockreport-mode t)
        (org-agenda-clockreport-parameter-plist (quote (:maxlevel 2 :fileskip0 t)))
        (org-agenda-archives-mode t)
        ;; I don't care if an entry was archived
        (org-agenda-hide-tags-regexp
         (concat org-agenda-hide-tags-regexp
                 "\\|ARCHIVE"))
      ))

(add-to-list 'org-agenda-custom-commands
             '("R" . "Review" )
             )

(add-to-list 'org-agenda-custom-commands
             `("Rd" "Day in review"
                agenda ""
                ;; agenda settings
                ,(append
                  efs/org-agenda-review-settings
                  '((org-agenda-span 'day)
                    (org-agenda-overriding-header "Day in Review"))
                  )
                ))

(add-to-list 'org-agenda-custom-commands
             `("Rw" "Week in review"
                agenda ""
                ;; agenda settings
                ,(append
                  efs/org-agenda-review-settings
                  '((org-agenda-span 'week)
                    (org-agenda-start-on-weekday 1)
                    (org-agenda-overriding-header "Week in Review"))
                  )
                ))

(add-to-list 'org-agenda-custom-commands
             `("Rm" "Month in review"
                agenda ""
                ;; agenda settings
                ,(append
                  efs/org-agenda-review-settings
                  '((org-agenda-span 'month)
                    (org-agenda-start-day "01")
                    (org-read-date-prefer-future nil)
                    (org-agenda-overriding-header "Month in Review"))
                  )
                ))

(defun hugo/org-format-time (time)
  "Formats elisp time to org-mode's format"
  (format-time-string "[%Y-%m-%d %a %H:%M]" time))

(defun hugo/minutes-to-org-duration (minutes)
  "Formats amount of minutes to org-mode's format of %HH:%MM"
  (let* ((hours (floor (/ minutes 60)))
         (minutes-left (- minutes (* hours 60))))
    (format "%02d:%02d" hours minutes-left)))

(defun hugo/capture-template-done-task ()
  "Capture template function for capturing done tasks that I want to clock retroactively.
It will ask for how long the task took to do, after which a DONE task is created
with a clock from [now - task duration]--[now]."
  (let* ((minutes (read-number "How many minutes ago did you start the task? "))
        (current-seconds (float-time))
        (start-time (seconds-to-time (- current-seconds (* minutes 60))))
        (duration-string (hugo/minutes-to-org-duration minutes))
        (start-string (hugo/org-format-time start-time))
        (end-string (hugo/org-format-time (current-time)))
        (logbook (format ":LOGBOOK:\nCLOCK: %s--%s =>  %s\n:END:" start-string end-string duration-string)))
        (concat "* DONE %?\nSCHEDULED: %t\n" logbook "\n" (hugo/make-id-property))))

(setq org-capture-templates
    '(("t" "Todo" entry (file org-default-notes-file)
    "* TODO %?\nSCHEDULED: %t")
      ("p" "Start new task (clocks in)" entry (file org-default-notes-file)
       "* TODO %?\nSCHEDULED: %t" :clock-in t :clock-keep t)
      ("d" "Done" entry (file org-default-notes-file)
       (function hugo/capture-template-done-task))))
(add-hook! org-agenda-mode #'toggle-truncate-lines)

(setq org-md-headline-style 'setext)

(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))

(require 'org-gcal)
(setq org-gcal-client-id (car (read-lines "~/Dropbox/emacs/gcal_client_id"))
      org-gcal-client-secret (car (read-lines "~/Dropbox/emacs/gcal_client_secret"))
      org-gcal-file-alist '(("hugo@smartly.io" .  "~/Dropbox/org/schedule.org")))

;; Use prettier_d for faster formatting
(setq prettier-js-command "prettier_d")
(setq prettier-js-args '("--pkg-conf"))
(add-hook! (web-mode) #'prettier-js-mode)

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
