(require 'ox)

(org-export-define-backend 'flowdock
  '((headline . org-flowdock-headline)
    (paragraph . org-flowdock-paragraph)
    (plain-text . org-flowdock-plain-text)
    (section . org-flowdock-section)
    (link . org-flowdock-link)
    (code . org-flowdock-code)
    (plain-list . org-flowdock-plain-list)
    (item . org-flowdock-item)
    (bold . org-md-bold))
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
  (cond ((= level 1) (concat "\n" title "\n" (make-string 5 ?=)))
         ((= level 2) (concat "\n" title "\n" (make-string 5 ?=)))
         ((>= level 3) (concat (make-string (* (max (- level 3) 0) 2) ? ) "- " title))))

;;;; Paragraph

(defun org-flowdock-paragraph (paragraph contents info)
  ;; Unwrap lines as flowdock treats every linebreak as a new visual line
  ;; Visual line breaks can still be created by inserting two line breaks
  ;; as that creates another paragraph element
 (subst-char-in-string ?\n ? contents))

;;;; Plain text

(defun org-flowdock-plain-text (text info)
  text)

;;;; Section

(defun org-flowdock-section (section contents info)
  contents)

;;;; Link

(defun org-flowdock-link (link desc info)
  (if desc
    (format "[%s](%s)" desc (org-element-property :raw-link link))
    (org-element-property :raw-link link)))

;;;; List

(defun org-flowdock-plain-list (_plain-list contents _info)
  contents)

;;;; Item

(defun org-flowdock-item (item contents info)
  (let* ((type (org-element-property :type (org-export-get-parent item)))
	 (struct (org-element-property :structure item))
	 (bullet (org-element-property :bullet item)))
    (concat bullet " " contents " ")))

;;;; Code

(defun org-flowdock-code (code _contents _info)
  (format "`%s`" (org-element-property :value code)))

(defun org-flowdock-export-as-flowdock ()
  (interactive)
  (org-export-to-buffer 'flowdock "*Org Flowdock Export*"))
