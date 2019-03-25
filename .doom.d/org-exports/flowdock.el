(require 'ox)

(org-export-define-backend 'flowdock
  '((headline . org-flowdock-headline))
  :menu-entry
  '(?f "Export to Flowdock"
       ((?f "To temporary buffer"
	    (lambda (a s v b) (org-flowdock-export-as-flowdock)))
	)))



;;;; Headline

(defun org-flowdock-headline (headline contents info)
  (let* ((level (org-export-get-relative-level headline info))
        (title (org-element-property :raw-value headline)))
    (concat (org-flowdock-format-title title level) "\n" contents)))

(defun org-flowdock-format-title (title level)
  (cond ((= level 1) (concat "\n" title "\n" (make-string (length title) ?=)))
         ((= level 2) (concat "\n" title "\n" (make-string (length title) ?-)))
         ((= level 3) (concat "\n" "**" title "**" "\n"))
         ((>= level 4) (concat (make-string (* (max (- level 4) 0) 2) ? ) "- " title))))

(defun org-flowdock-export-as-flowdock ()
  (interactive)
  (org-export-to-buffer 'flowdock "*Org Flowdock Export*"))
