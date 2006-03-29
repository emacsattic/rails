;;; rails-navigation.el --- emacs-rails navigation functions

;; Copyright (C) 2006 Galinsky Dmitry <dima dot exe at gmail dot com>

;; Authors: Galinsky Dmitry <dima dot exe at gmail dot com>,
;;          Rezikov Peter <crazypit13 (at) gmail.com>

;; Keywords: ruby rails languages oop
;; $URL: svn+ssh://crazypit@rubyforge.org/var/svn/emacs-rails/trunk/rails-core.el $
;; $Id: rails-navigation.el 23 2006-03-27 21:35:16Z crazypit $

;;; License

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

(defvar rails-use-text-menu nil
  "If t use text menu, popup menu otherwise")


;;;;;;;;;; Goto file on current line ;;;;;;;;;;

(defmacro* def-goto-line (name (&rest conditions) &rest body)
  (let ((line (gensym))
	(field (gensym))
	(prefix (gensym)))
   `(progn
      (defun ,name (,line ,prefix)
	(block ,name
	  ,@(loop for (sexpr . map) in conditions
		  collect
		  `(when (string-match ,sexpr ,line)
		     (let ,(loop for var-acc in map collect
				 (if (listp var-acc)
				     `(,(first var-acc) (match-string ,(second var-acc) ,line))
				   var-acc))
		       (return-from ,name (progn ,@body))))))))))

(defun rails-goto-file-on-current-line (prefix)
  "Analyze string (or ERb block) and open some file relative with this string.
F.e. on line with \"renader :partial\" run this function and partial file will by oppend.
Also this function wor with \"layout 'name'\",
 \"render/redirect-to [:action => 'name',] [controller => 'n']\", stylesheet_link_tag an other.

Rule for action/contoller line goto:
 if you in contoller cursor will be placed on controller action.
 if you in view -- view-file with action will be opened.
 Use prefix before command to change navigation direction."
  (interactive "P")
  (save-match-data
     (unless
	 (when-bind
	  (line (save-excursion
		  (if (rails-core:rhtml-buffer-p)
		      (rails-core:erb-block-string)
		    (current-line-string))))
	  (loop for func in rails-on-current-line-gotos
		until (when (funcall func line prefix) (return t))))
       (message "Can't go to some file form this line."))))

(defvar rails-on-current-line-gotos
  '(rails-line-->partial rails-line-->controller+action
    rails-line-->layout rails-line-->stylesheet)
  "Functions that will calles when to analyze line when rails-goto-file-on-current-line runned.")

(def-goto-line rails-line-->stylesheet (("[ ]*stylesheet_link_tag[ ][\"']\\([^\"']*\\)[\"']"
				      (name 1)))
  (rails-core:find-or-ask-to-create
   (format "Stylesheet \"%s\" does not exist do you whant to create it? " name)
   (rails-core:stylesheet-name name)))

(def-goto-line rails-line-->partial (("[ ]*render.*:partial[ ]*=>[ ]*[\"']\\([^\"']*\\)[\"']"
				      (name 1)))
  (find-or-ask-to-create
   (format "Partial \"%s\" does not exist do you whant to create it? " name) 
   (rails-core:partial-name name)))

(def-goto-line rails-line-->layout (("^[ ]*layout[ ]*[\"']\\(.*\\)[\"']" (name  1)))
  (rails-core:find-or-ask-to-create
   (format "Layout \"%s\" does not exist do you whant to create it? " name) 
   (rails-core:layout-file name)))

(defvar rails-line-to-controller/action-keywords
  '("render" "redirect_to" "link_to" "form_tag" "start_form_tag"))

(defun rails-line-->controller+action (line prefix)
  (when (loop for keyword in rails-line-to-controller/action-keywords
	      when (string-match (format "^[ ]*%s " keyword) line) do (return t))
    (let (action controller)
      (when (string-match ":action[ ]*=>[ ]*[\"']\\([^\"']*\\)[\"']" line)
	(setf action (match-string 1 line)))
      (when (string-match ":controller[ ]*=>[ ]*[\"']\\([^\"']*\\)[\"']" line)
	(setf controller (match-string 1 line)))      
      (rails-core:open-controller+action
       (if (rails-core:rhtml-buffer-p)
	   (if prefix :controller :view)
	 (if prefix :view :controller))
       (if controller
	   (rails-core:full-controller-name controller)
	 (rails-core:current-controller))
       action))))

;;;;;;;;;; Goto file from file ;;;;;;;;;;




;;; For Models

(defun rails-by-model-switch-to (what file-func)
  (let ((model (rails-core:current-model)))
    (rails-core:find-or-ask-to-create
     (format "%s for model %s does not exist, create it? " what model)
     (funcall file-func  model))))

(defun rails-by-model-switch-to-model ()
  (rails-by-model-switch-to "Model" 'rails-model-file))


;; Plural BUGS!!!
;; (defun rails-goto-fixtures-->model ()
;;   (rails-goto-model-->simple
;;    "Model" 'rails-core:current-model-from-fixtures
;;    'rails-model-file))

;; (defun  rails-goto-fixtures-->unit-test ()
;;   (rails-goto-model-->simple
;;    "Unit test" 'rails-core:current-model-from-fixtures
;;   'rails-core:unit-test-file))

(defun rails-by-model-switch-to-unit-test ()
  (rails-by-model-switch-to "Unit test" 'rails-core:unit-test-file))

(defun rails-by-model-switch-to-fixtures ()
  (rails-by-model-switch-to "Fixtures" 'rails-core:fixtures-file))

(defvar rails-goto-file-from-file-actions
  '((:controller
     (:invisible        rails-for-controller:switch-to-view2)
     rails-for-controller:views-for-current-action
     ("Helper"          rails-for-controller:switch-to-helper)
     ("Functional test" rails-for-controller:switch-to-functional-test))
    (:view
     ("Controller"      rails-for-rhtml:switch-to-controller-action)
     ("Helper"          rails-for-controller:switch-to-helper)
     ("Functional test" rails-for-controller:switch-to-functional-test))
    (:helper
     ("Controller"      rails-for-controller:switch-to-controller)
     ("View"            rails-for-controller:switch-to-views))
    (:functional-test
     ("Controller"      rails-for-controller:switch-to-controller))
;;; For Models
    (:model
     ("Unit test" rails-by-model-switch-to-unit-test)
     ("Fixtures"  rails-by-model-switch-to-fixtures))
    ;; Plural BUGS!!!    
    ;;     (rails-core:fixtures-buffer-p
    ;;      (rails-goto-fixtures-->model "Model test")
    ;;      (rails-goto-fixtures-->unit-test "Unit test"))
    (:unit-test
     ("Model"      rails-by-model-switch-to-model)
     ("Fixtures"   rails-by-model-switch-to-fixtures))))

(defun rails-goto-menu-call (goto)
  (cond ((and (symbolp goto) (fboundp goto)) (funcall goto))
	((stringp goto) (find-file goto))))

(defun rails-goto-file-from-file (show-menu)
  "Deteminate type of file and goto another file.
  With prefix show menu with variants."
  (interactive "P")
  (rails-core:with-root
   (root)
   (let ((variants (rest (find (rails-core:buffer-type)
			       rails-goto-file-from-file-actions
			       :key #'first))))
     (if variants
	 (let ((variants
		(loop for variant in variants
		      when (symbolp variant)
		      append (funcall variant)
		      else collect variant)))
	   (progn
	     ;; Menu
	     (if show-menu
		 (when-bind
		  (goto (rails-core:menu
			 (list "Go To: "
			       (cons "goto"
				     (loop for (title func) in variants
					   when (not (eq title :invisible))
					   collect `(,title  ,func))))))
		  (rails-goto-menu-call goto))
	       ;;
	       (rails-goto-menu-call (second (first variants))))))
       (message "Can't go to some file from this file.")))))

(defun rails-goto-file-from-file-with-menu ()
  "Deteminate type of file and goto another file (choose type from menu)"
  (interactive)
  (rails-goto-file-from-file t))

;;;;;;;;;; Rails finds ;;;;;;;;;;

(defun rails-find (path)
  "Open find-file in minbuffer for ``path'' in rails-root"
  (let ((default-directory (rails-core:file path)))
    (call-interactively rails-find-file-function)))

(defmacro* def-rails-find (name dir)
  "Define new rails-find function"
  `(defun ,name ()
     ,(format "Run find-file in Rails \"%s\" dir" dir)
     (interactive)
     (rails-find ,dir)))

(def-rails-find rails-find-controller "app/controllers/")

(def-rails-find rails-find-view "app/views/")

(def-rails-find rails-find-layout "app/views/layouts/")

(def-rails-find rails-find-db "db/")

(def-rails-find rails-find-public "public/")

(def-rails-find rails-find-helpers "app/helpers/")

(def-rails-find rails-find-models "app/models/")

(def-rails-find rails-find-config "config/")


(provide 'rails-navigation)
