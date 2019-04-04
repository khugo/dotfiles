(require 'ox)

(org-export-define-backend 'lever
  '((headline . org-lever-headline))
  :menu-entry
  '(?l "Export to Lever"
       ((?l "To temporary buffer"
	    (lambda (a s v b) (org-lever-export-as-lever)))
	)))



;;;; Headline

(defun org-lever-headline (headline contents info)
  (let* ((level (org-export-get-relative-level headline info))
        (title (org-element-property :raw-value headline)))
    (concat (org-lever-format-title title level) "\n" contents)))

(defun org-lever-format-title (title level)
  (cond ((= level 1) (concat "\n" title "\n" (make-string (length title) ?=)))
         ((= level 2) (concat "\n" title "\n" (make-string (length title) ?=) "\n"))
         ((>= level 3) (concat (make-string (* (max (- level 3) 0) 4) ? ) "* " title))))

(defun org-lever-export-as-lever ()
  (interactive)
  (org-export-to-buffer 'lever "*Org Lever Export*"))
