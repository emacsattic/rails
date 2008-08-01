;;; rails.el --- minor mode for editing RubyOnRails code

;; Copyright (C) 2006 Galinsky Dmitry <dima dot exe at gmail dot com>

;; Authors: Galinsky Dmitry <dima dot exe at gmail dot com>,
;;          Rezikov Peter <crazypit13 (at) gmail.com>
;; Keywords: ruby rails languages oop
;; X-URL:    https://opensvn.csie.org/mvision/emacs/.emacs.d/rails.el
;; $Id$

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

;;; Features

;; * Managment WEBrick/Mongrel
;; * Display color log file
;; * Switch beetwin Action/View
;; * TextMate like snippets (snippets.el)
;; * Automatic generate TAGS in RAILS_ROOT directory
;; * Quick access to configuration files
;; * Search in documentation using ri or chm file
;; * Quick start svn-status in RAILS_ROOT
;; * Integration with script/generate and script/destroy
;; * Fast navigation through rails finds (C-c C-f C-h for help)
;; * Creation of new rails project with rails-create-project
;; * Runing of rails console
;; * Automatic find of error line with rails-find-and-goto-error in rails html report
;; * Auto-determination of current rails DB settings and running SQL console

;;; Install

;; Download
;;  * http://www.kazmier.com/computer/snippet.el
;;  * http://www.webweavertech.com/ovidiu/emacs/find-recursive.txt
;; and place into directory where emacs can find it.
;;
;; Add to your .emacs file:
;;
;; (defun try-complete-abbrev (old)
;;   (if (expand-abbrev) t nil))
;;
;; (setq hippie-expand-try-functions-list
;;       '(try-complete-abbrev
;;         try-complete-file-name
;;         try-expand-dabbrev))
;;
;; (require 'rails)
;;
;; If you want to use Mongrel instead of WEBrick, add this to you .emacs file:
;; (setq rails-use-mongrel t)
;;

;;; For Windows users only:

;;  If you want to use CHM file for help (by default used ri), add this to your .emacs file:
;;    (setq rails-chm-file "<full_path_to_rails_chm_manual>")
;;  Download and install KeyHH.exe from http://www.keyworks.net/keyhh.htm
;;
;;  Howto using Textmate Backtracer
;;   1. Place info you .emacs file:
;;
;;   (require 'gnuserv)
;;   (setq gnuserv-frame (selected-frame))
;;   (gnuserv-start)

;;   2. Create into you emacs bin directory txmt.js and place into it:
;;
;;   var wsh = WScript.CreateObject("WScript.Shell");
;;   url = WScript.Arguments(0);
;;   if (url) {
;;     var req = /file:\/\/([^&]+).*&line=([0-9]+)/;
;;     var file = req.exec(url);
;;     if (file[1] && file[2]) {
;;       wsh.Run("<path_to_emacs_bin_directory>/gnuclientw.exe +" + file[2] + " " + file[1]);
;;     }
;;   }

;;   3. Create registry key structure:
;;   HKEY_CLASSES_ROOT
;;   -- *txmt*
;;   ---- (Default) = "URL:TXMT Protocol"
;;   ---- URL Protocol = ""
;;   ---- *shell*
;;   ------ *open*
;;   -------- *command*
;;   ---------- (Default) = "cscript /H:WScript /nologo <path_to_emacs_bin_direcory>\txmt.js %1"

;;; BUGS:

;; Do not use automatic snippent expand, be various problem in mmm-mode.
;; Snippets now bind in <TAB>

;; More howtos, see
;;   * http://scott.elitists.net/users/scott/posts/rails-on-emacs
;;   * http://www.emacswiki.org/cgi-bin/wiki/RubyMode

;;; Changelog:

;; HEAD
;;   * rails-auto-open-browser (automatic open browser on current action) + rails-open-browser-on-controller (Rezikov Peter)
;;   * rails-get-current-controller+action-from-view, rails-get-current-controller+action-from-controller,  rails-get-current-controller+action - extract from rails-switch-to-{action,view} (Rezikov Peter)
;;   * Helper functions rubby-buffer-p,  rails-remove-controller-postfix (Rezikov Peter)
;;   * new functions rails-goto-(model|controller) display menu to select
;;   * Helper functions rails-models-parent-classes and rails-controller-parent-classes (Rezikov Peter)
;;   * Helper functions rails-models and rails-controllers, with return models and
;;     controllers lists, also destroy and generate scripts update - autocomplete added (Rezikov Peter)     
;;   * Automatic running of sql with rails-run-sql and helper functions (Rezikov Peter)
;;     rails-read-enviroment-name, rails-database-emacs-func, rails-db-parameters, yml-next-value (Rezikov Peter)
;;   * helper functions (buffer-string-by-name directory-name append-string-to-file) (Rezikov Peter)
;;   * rails-project-name function (Rezikov Peter)
;;   * Logging functions (rails-log-add rails-logged-shell-command) and logging for rails scripts (Rezikov Peter) rails minor mode log in RAILS-ROOT/rails-minor-mode.log
;;   * add function rails-create-helper-from-block
;;   * replace all calls buffer-name to a buffer-file-name
;;   * Added rails-run-breakpointer (run script/breakpointer) (Rezikov Peter)
;;   * new macro def-snips (with some helper functions), replace all def-snip, and change menu snip declarations (Rezikov Peter)
;;   * def-snip removed (Rezikov Peter)
;;   * rebind rails-switch-view-action to "C-c <up>"
;;   * add rails-create-partial-from-selection, create partial from selection
;;   * add helper function rails-is-current-buffer-rhtml
;;   * add helper function (rails-classname->filename, rails-filename->classname,
;;                          rails-get-controller-filename, rails-get-model-filename,
;;                          rails-get-view-filenames)
;;   * rewrite rails-switch-to-action and rails-switch-to-view
;;   * add snippets for migration (Jason Stewart)
;;   * Integration with script/genrate and script/destroy 
;;     (for controller, model, scaffold and migration) (Rezikov Peter)
;;   * Refactoring of code (Rezikov Peter)
;;   * Many new hotkeys (Rezikov Peter)
;;   * rails-create-project function (Rezikov Peter)
;;   * rails finds - fast navigation in rails directory hierarchy (Rezikov Peter)
;;   * rails-run-console - runs script/console (Rezikov Peter)
;;   * rails-open-config - for fast config search  (Rezikov Peter)
;;   * rails-open-log now interactive with autocomplete (Rezikov Peter)
;;   * Many new functions/macro for better development (rails-file, rails-open-file, rails-controller-file, rails-model-file, with-rails-root, rails-models-alist) (Rezikov Peter)
;;   * rails-switch-view-action: create [action].rhtml if view not exists
;;   * Remove function rails-ri-at-point and rename rails-ri-start to rails-search-doc
;;   * Check rails-chm-file exists before start keyhh
;;   * Fix not match def, if cursor position at begin of line in rails-switch-to-action
;;   * Remove etags support

;; 2006/02/09 (version 0.3)
;;   * Minor fixes in snippets, add extra "-" (Sanford Barr)
;;   * Fix problem at using TAB key
;;   * Display help using CHM manual
;;   * Fix undefined variable html-mode-abbrev-table in older emacs versions
;;   * Add variable rails-use-another-define-key
;;   * Fix void function indent-or-complete
;;   * Add Mongrel support
;;   * Fix compitation warnings
;;   * Display popup menu at point

;; 2006/02/07 (version 0.2)
;;   * Display color logs using ansi-color
;;   * Revert to using snippet.el
;;   * Automatic create TAGS file in RAILS_ROOT
;;   * add variable rails-use-ctags
;;   * fix problem in rails-create-tags (thanks Sanford Barr)
;;   * lazy load TAGS file

;; 2006/02/06 (version 0.1):
;;   * Cleanup code
;;   * Add menu item "SVN status"
;;   * Add menu item "Search documentation"
;;   * If one action associated to multiple views,
;;     display popup menu to a choice view
;;   * More TextMate snippets
;;   * Using ri to search documentation
;;   * Apply patch from Maiha Ishimura

;;; Code:

(eval-when-compile
  (require 'speedbar)
  (require 'ruby-mode))

(require 'rails-lib)
(require 'rails-core)
(require 'rails-ruby)
(require 'rails-ui)

(require 'ansi-color)
(require 'snippet)
(require 'etags)
(require 'find-recursive)

;;;;;;;;;; Variable definition ;;;;;;;;;;

(defvar rails-version "0.3")
(defvar rails-ruby-command "ruby")
(defvar rails-webrick-buffer-name "*WEBrick*")
(defvar rails-webrick-port "3000")
(defvar rails-webrick-default-env "development")
(defvar rails-webrick-url (concat "http://localhost:" rails-webrick-port))
(defvar rails-templates-list '("rhtml" "rxml" "rjs"))
(defvar rails-chm-file nil "Path CHM file or nil")
(defvar rails-use-another-define-key nil )
(defvar rails-use-mongrel nil "Non nil using Mongrel, else WEBrick")

(defvar rails-apply-to-list
  "(FILE-EXTENSION MODE KEYMAP FILE-REGEX)"
  '((".rb"     'rails-minor-mode-for-ruby  'rails-minor-mode-for-ruby-menubar nil )
    (".rhtml"  'rails-minor-mode-for-rhtml 'rails-minor-mode-for-rhtml-menubar nil )
    (".rjs"    'rails-minor-mode-for-ruby  'rails-minor-mode-for-ruby-menubar nil )
    ))

(defvar rails-generation-buffer-name "*RailsGeneration*")
;(defvar rails-ctags-command "ctags -e -a --Ruby-kinds=-f -o %s -R %s %s")
(defvar rails-ctags-command "ctags-exuberant -e -a --Ruby-kinds=-f -o %s -R %s %s")
(defvar rails-enviroments '("development" "production" "test"))
(defvar rails-config-files
  '("environments/development.rb" "environments/production.rb"
    "environments/test.rb" "boot.rb"
    "database.yml" "environment.rb" "routes.rb"))
(defvar rails-use-mode-in-root t
  "Try to find rails root and activate rails-minor-mode for each file finding")
;(defvar rails-find-file-function 'find-file)
(defvar rails-find-file-function 'ido-find-file)

(defvar rails-adapters-alist
  '(("mysql"      . sql-mysql)
    ("postgresql" . sql-postgres))
  "Sets emacs sql function for rails adapter names")

(defvar rails-use-text-menu nil
  "If t use text menu, popup menu otherwise")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;; Rails user functions ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;; Rails Project ;;;;;;;;;;

(defun rails-create-project (dir)
  "Create new project in ``dir'' directory"
  (interactive "FNew project directory: ")
  (shell-command (concat "rails " dir)
		 rails-generation-buffer-name)
  (flet ((rails-core:root () (concat dir "/") ))
    (rails-log-add
     (format "\nCreating project %s\n%s"
	     dir (buffer-string-by-name rails-generation-buffer-name))))
  (find-file dir))


;;;; Open model stuff


;; Deprecated
;; (defun rails-open-model ()
;;   (interactive)
;;   (let ((model-name
;; 	 (completing-read "Model name: " (list->alist (rails-core:models))
;; 			  nil nil (thing-at-point 'sexp))))
;;     (unless (rails-core:find-file-if-exist (rails-model-file model-name))
;;       (when (y-or-n-p (format "Model %s does not exist, create it? " model-name))
;; 	(rails-generate-model model-name)))))


;;;;;;;;;;;;;;;;;;;; Rails scripst ;;;;;;;;;;;;;;;;;;;;

(defun rails-run-script (script buffer parameters &optional message-format)
  "Run rails script with ``parameters'' in ``buffer''"
  (rails-core:with-root
   (root)
   (let ((default-directory root))
     (rails-logged-shell-command
      (format "ruby %s %s"
	      (format "script/%s " script)
	      (apply #'concat
		     (mapcar #'(lambda (str)
				 (if str (concat str " ") ""))
			     parameters)))
      buffer))
   (when message-format
     (message message-format (capitalize (first parameters))
	      (second parameters)))))

;;;;;;;;;; Destroy stuff ;;;;;;;;;;


(defun rails-destroy (&rest parameters)
  "Running destroy script"
  (rails-run-script "destroy" rails-generation-buffer-name parameters
		    "%s %s destroyed."))

(defun rails-destroy-controller (&optional controller-name)
  (interactive
   (list (completing-read "Controller name: " (list->alist (rails-core:controllers t)))))
  (when (string-not-empty controller-name)
    (rails-destroy "controller" controller-name)))

(defun rails-destroy-model (&optional model-name)
  (interactive (list (completing-read "Model name: " (list->alist (rails-core:models)))))
    (when (string-not-empty model-name)
      (rails-destroy "model" model-name)))

(defun rails-destroy-scaffold (&optional scaffold-name)
  ;; buggy
  (interactive "MScaffold name: ")
  (when (string-not-empty scaffold-name)
    (rails-destroy "scaffold" scaffold-name)))


;;;;;;;;;; Generators stuff ;;;;;;;;;;

(defun rails-generate (&rest parameters)
  "Generate with ``parameters''"
  (rails-run-script "generate" rails-generation-buffer-name parameters
		    "%s %s generated.")
  ;(switch-to-buffer-other-window rails-generation-buffer-name)
  )


(defun rails-generate-controller (&optional controller-name actions)
  "Generate controller and open controller file"
  (interactive (list
		(completing-read "Controller name (use autocomplete) : "
				 (list->alist (rails-core:controllers-ancestors)))
		(read-string "Actions (or return to skip): ")))
    (when (string-not-empty controller-name)
	(rails-generate "controller" controller-name actions)
	(rails-core:find-file (rails-controller-file controller-name))))

(defun rails-generate-model (&optional model-name)
  "Generate model and open model file"
  (interactive
   (list (completing-read "Model name: " (list->alist (rails-core:models-ancestors)))))
  (when (string-not-empty model-name)
    (rails-generate "model" model-name)
    (rails-core:find-file (rails-model-file model-name))))


(defun rails-generate-scaffold (&optional model-name controller-name actions)
  "Generate scaffold and open controller file"
  (interactive
   "MModel name: \nMController (or return to skip): \nMActions (or return to skip): ")
  (when (string-not-empty model-name)
    (if (string-not-empty controller-name)
	(progn
	  (rails-generate "scaffold" model-name controller-name actions)
	  (rails-core:find-file (rails-controller-file controller-name)))
      (progn
	(rails-generate "scaffold" model-name)
	(rails-core:find-file (rails-controller-file model-name))))))

(defun rails-generate-migration (migration-name)
  "Generate new migration and open migration file"
  (interactive "MMigration name: ")
  (when (string-not-empty migration-name)
    (rails-generate "migration" migration-name)
    (rails-core:find-file
     (save-excursion
       (set-buffer rails-generation-buffer-name)
       (goto-line 2)
       (search-forward-regexp "\\(db/migrate/[0-9a-z_]+.rb\\)")
       (match-string 1)))))

;;;;;;;;;; Rails views ;;;;;;;;;;

(defun rails-create-partial-from-selection ()
  "Create partial from selection"
  (interactive)
  (if (and mark-active
           transient-mark-mode
           (rails-core:rhtml-buffer-p))
      (save-excursion
        (let ((name (read-string "Partial name? "))
              (content (buffer-substring-no-properties (region-beginning) (region-end))))
          (kill-region (region-beginning) (region-end))
          (insert (concat "<%= render :partial => \"" name "\" %>"))
          (split-window-vertically)
          (other-window 1)
          (find-file (concat "_" name ".rhtml"))
          (goto-char (point-min))
          (insert content)
          (other-window -1)
          (mmm-parse-region (line-beginning-position) (line-end-position))))))


(defun rails-create-helper-from-block (&optional helper-name)
  "Create helper function from current erb block (<% .. %>)"
  (interactive)
  (rails-core:with-root
   (root)
   (let ((current-pos (point))
         (file buffer-file-name)
         begin-pos end-pos)
     (save-excursion
       (setq begin-pos (search-backward "<%" nil t))
       (setq end-pos (search-forward "%>" nil t)))
     (if (and begin-pos
              end-pos
              (> current-pos begin-pos)
              (< current-pos end-pos)
              (string-match "app/views/\\(.*\\)/\\([a-z_]+\\)\.[a-z]+$" file))
         (let* ((helper-file (concat root "app/helpers/" (match-string 1 file) "_helper.rb"))
                (content (buffer-substring-no-properties begin-pos end-pos))
                (helper-alist (if helper-name helper-name (read-string "Enter helper function name with args: ")))
                (helper-alist (split-string helper-alist)))
           (if (file-exists-p helper-file)
               (let (start-point-in-helper helper-func-name)
                 (setq helper-func-name (concat "def " (car helper-alist) " ("))
                 (setq helper-alist (cdr helper-alist))
                 (mapcar (lambda (arg) (setq helper-func-name (concat helper-func-name arg ", "))) helper-alist)
                 (setq helper-func-name (concat (substring helper-func-name 0 -2) ")" ))
                 (kill-region begin-pos end-pos)
                 (insert (concat "<%= " helper-func-name " -%>" ))
                 (mmm-parse-region (line-beginning-position) (line-end-position))
                 (split-window-vertically)
                 (other-window 1)
                 (find-file helper-file)
                 (goto-char (point-min))
                 (search-forward-regexp "module +[a-zA-Z0-9:]+")
                 (newline)
                 (setq start-point-in-helper (point))
                 (insert helper-func-name)
                 (ruby-indent-command)
                 (newline)
                 (insert content)
                 (insert "\nend\n")
;;                  (while (and (re-search-forward "\\(<%=?\\|-?%>\\)" nil t)
;;                              (< (point) start-point-in-helper))
;;                    (replace-match "" nil nil))
                 (replace-regexp "\\(<%=?\\|-?%>\\)" "" nil start-point-in-helper (point))
                 (goto-char start-point-in-helper)
                 (ruby-indent-exp)
                 (other-window -1))
             (message "helper not found")))
       (message "block not found")))))

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

;;;;;;;;;;;;;;;;;;; Goto menus ;;;;;;;;;;;;;;;;;;;

(defun rails-goto-file-with-menu (dir title)
  "Make menu to choose files and find-file it"
  (let (file
        files
        (mouse-coord (if (functionp 'posn-at-point) ; mouse position at point
                         (nth 2 (posn-at-point))
                       (cons 200 100))))
    (setq files (find-recursive-directory-relative-files dir "" "\\.rb$"))
    (setq files (sort files 'string<))
    (setq files (reverse files))
    (setq files (mapcar (lambda(f) (cons (rails-core:class-by-file f) f))
                        files))
    (setq file (x-popup-menu
                (list (list (car mouse-coord) (cdr mouse-coord)) (selected-window))
                (list title (cons title files ))))
    (if file
        (find-file (concat dir file)))))

(defun rails-goto-controller ()
  "Goto Controller"
  (interactive)
  (rails-core:with-root
   (root)
   (rails-goto-file-with-menu (concat root "app/controllers/") "Go to controller..")))

(defun rails-goto-model ()
  "Goto Model"
  (interactive)
  (rails-core:with-root
   (root)
   (rails-goto-file-with-menu (concat root "app/models/") "Go to model..")))

;;;;;;;;;; Shells ;;;;;;;;;;

;; (defun run-ruby-in-buffer (cmd buffer)
;;   "Run ruby in buffer *``buffer''*"
  ;; Rewrite me
;  (kill-buffer "*ruby*")
;;   (run-ruby cmd)
 ; (rename-buffer buffer)
;;   (let ((star-buffer (format "*%s*" buffer)))
;;     (if (not (comint-check-proc buffer))
;; 	(let ((cmdlist (ruby-args-to-list cmd)))
;; 	  (set-buffer (apply 'make-comint buffer (car cmdlist)
;; 			     nil (cdr cmdlist)))
;; 	  (inferior-ruby-mode)))
;;     (setq ruby-buffer)
;;     (pop-to-buffer buffer))
;;   )

;; (defun rails-run-interactive (name script)
;;   "Run interactive shel with script in buffer
;;    *rails-<project-name>-<name>*"
;;   (rails-core:with-root
;;    (root)
;;    (run-ruby-in-buffer (rails-core:file script)
;; 		       (intern (format "*rails-%s-%s*" (rails-core:project-name) name)))))


;; (defun rails-run-console ()
;;   "Run script/console"
;;   (interactive)
;;   (rails-run-interactive "console" "script/console"))

;; (defun rails-run-breakpointer ()
;;   "Run script/breakpointer"
;;   (interactive)
;;   (rails-run-interactive "breakpointer" "script/breakpointer"))


(defun rails-run-console ()
  (interactive)
  (run-ruby (rails-core:file "script/console")))

(defun rails-run-breakpointer ()
  (interactive)
  (run-ruby (rails-core:file "script/breakpointer")))

;;;;;;;;;; Database integration ;;;;;;;;;;

;; (defun rails-get-option (name)
;;   "Find option extracted from script/about"
;;   )



(defstruct rails-db-conf adapter database username password)

(defun rails-db-parameters (env)
  "Return database parameters for enviroment env"
  (rails-core:with-root
   (root) 
   (save-excursion
     (rails-open-config "database.yml")
     (goto-line 1)
     (search-forward-regexp (format "^%s:" env))
     (let ((ans
	    (make-rails-db-conf
	     :adapter  (yml-next-value "adapter")
	     :database (yml-next-value "database")
	     :username (yml-next-value "username")
	     :password (yml-next-value "password"))))
       (kill-buffer (current-buffer))
       ans))))

(defun rails-database-emacs-func (adapter)
  "Return emacs function, that running sql buffer by rails adapter name"
  (cdr (assoc adapter rails-adapters-alist)))

(defun rails-read-enviroment-name (&optional default)
  "Read rails enviroment with autocomplete"
  (completing-read "Environment name: " (list->alist rails-enviroments) nil nil default))

(defun* rails-run-sql (&optional env)
  "Run SQL process for current rails project."
  (interactive (list (rails-read-enviroment-name "development")))
  (if (bufferp (sql-find-sqli-buffer))
      (switch-to-buffer-other-window (sql-find-sqli-buffer))
    (let ((conf (rails-db-parameters env)))
      (let ((sql-server "localhost")
	    (sql-user (rails-db-conf-username conf))
	    (sql-database (rails-db-conf-database conf))
	    (sql-password (rails-db-conf-password conf))
	    (default-process-coding-system '(utf-8 . utf-8)))
	; Reload localy sql-get-login to avoid asking of confirmation of DB login parameters
	(flet ((sql-get-login (&rest pars) () t))
	  (funcall (rails-database-emacs-func (rails-db-conf-adapter conf))))))))

;;;;;;;;;; Goto file on current line ;;;;;;;;;;

(defmacro* def-goto-line (name (&rest conditions) &rest body) ;(+++)
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

(defun rails-goto-file-on-current-line (prefix) ;(+++)
  "Try every goto-file-on-current-line function from ``rails-on-current-line-gotos''
   with current line. If call non nil - stop"
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

(defvar rails-on-current-line-gotos ;(+++)
  '(rails-line-->controller+action rails-line-->layout
    rails-line-->partial rails-line-->stylesheet)
  "Functions that will calles when to analyze line when rails-goto-file-on-current-line runned.")

(def-goto-line rails-line-->stylesheet (("[ ]*stylesheet_link_tag[ ][\"']\\([^\"']*\\)[\"']" ;(+++)
				      (name 1)))
  (rails-core:find-or-ask-to-create
   (format "Stylesheet \"%s\" does not exist do you whant to create it? " name)
   (rails-core:stylesheet-name name)))

(def-goto-line rails-line-->partial (("[ ]*render.*:partial[ ]*=>[ ]*[\"']\\([^\"']*\\)[\"']" ;(+++)
				      (name 1)))
  (find-or-ask-to-create
   (format "Partial \"%s\" does not exist do you whant to create it? " name) 
   (rails-core:partial-name name)))

(def-goto-line rails-line-->layout (("^[ ]*layout[ ]*[\"']\\(.*\\)[\"']" (name  1))) ;(+++)
  (rails-core:find-or-ask-to-create
   (format "Layout \"%s\" does not exist do you whant to create it? " name) 
   (rails-core:layout-file name)))

(defvar rails-line-to-controller/action-keywords ;(+++)
  '("render" "redirect_to" "link_to" "form_tag" "start_form_tag"))

(defun rails-line-->controller+action (line prefix) ;(+++)
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

;;;;;;;;;; Indentation ;;;;;;;;;;

(defun ruby-indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if snippet
      (snippet-next-field)
    (if (looking-at "\\>")
        (hippie-expand nil)
      (ruby-indent-command))))

(defun ruby-newline-and-indent ()
  (interactive)
  (newline)
  (ruby-indent-command))

;;                 (mouse-coord (if (functionp 'posn-at-point) ; mouse position at point
;;                                  (nth 2 (posn-at-point))
;;                                (cons 200 100)))
;;             (setq file
;;                   (x-popup-menu
;;                    (list (list (car mouse-coord) (cdr mouse-coord)) (selected-window))
;;                    (list "Please select.." (cons "Please select.." items ))))

;;;;;;;;;; Goto file from file ;;;;;;;;;;

(defun rails-goto-controller-->view ()
  (rails-core:open-controller+action
   :view (rails-core:current-controller) (rails-core:current-action)))

(defun rails-goto-view-->controller ()
  (rails-core:open-controller+action
   :controller (rails-core:current-controller) (rails-core:current-action)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rails-goto-all-->simple (what file-func)
  (let ((controller (rails-core:current-controller)))
    (rails-core:find-or-ask-to-create
     (format "%s for controller %s does not exist, create it? " what controller)
     (funcall file-func controller))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun rails-goto-all-->helper ()
  (rails-goto-all-->simple "Helper file" 'rails-core:helper-file))

(defun rails-goto-all-->functional-test ()
  (rails-goto-all-->simple "Functional test" 'rails-core:functional-test-file))

(defun rails-goto-helper-->view ()
  (rails-core:open-controller+action
   :view (rails-core:current-controller) nil))

(defun rails-goto-all-->controller ()
  (rails-core:open-controller+action
   :controller (rails-core:current-controller) nil))



;;; For Models

(defun rails-goto-model-->simple (what file-func)
  (let ((model (rails-core:current-model)))
    (rails-core:find-or-ask-to-create
     (format "%s for model %s does not exist, create it? " what model)
     (funcall file-func  model))))

(defun rails-goto-unit-test-->model ()
  (rails-goto-model-->simple "Model" 'rails-model-file))


;; Plural BUGS!!!
;; (defun rails-goto-fixtures-->model ()
;;   (rails-goto-model-->simple
;;    "Model" 'rails-core:current-model-from-fixtures
;;    'rails-model-file))

;; (defun  rails-goto-fixtures-->unit-test ()
;;   (rails-goto-model-->simple
;;    "Unit test" 'rails-core:current-model-from-fixtures
;;   'rails-core:unit-test-file))


(defun rails-goto-model-->unit-test ()
  (rails-goto-model-->simple "Unit test" 'rails-core:unit-test-file))

(defun rails-goto-all-->fixtures ()
  (rails-goto-model-->simple "Fixtures" 'rails-core:fixtures-file))

(defvar rails-goto-file-from-file-actions
  '((:controller
     (rails-goto-controller-->view   "View")
     (rails-goto-all-->helper "Helper")
     (rails-goto-all-->functional-test  "Functional test"))
    (:view
     (rails-goto-view-->controller   "Controller")
     (rails-goto-all-->helper       "Helper")
     (rails-goto-all-->functional-test "Functional test"))
    (:helper
     (rails-goto-helper-->view       "View")
     (rails-goto-all-->controller "Controller"))
    (:functional-test
     (rails-goto-all-->controller "Controller"))
    ;;; For Models
    (:model
     (rails-goto-model-->unit-test "Unit test")
     (rails-goto-all-->fixtures  "Fixtures"))
;; Plural BUGS!!!    
;;     (rails-core:fixtures-buffer-p
;;      (rails-goto-fixtures-->model "Model test")
;;      (rails-goto-fixtures-->unit-test "Unit test"))
    (:unit-test
     (rails-goto-unit-test-->model "Model")
     (rails-goto-all-->fixtures   "Fixtures"))))

(defun rails-goto-file-from-file (show-menu)
  "Deteminate type of file and goto another file.
  With prefix show menu with variants."
  (interactive "P")
  (rails-core:with-root
   (root)
   (unless
       (loop with buffer-type = (rails-core:buffer-type)
	     for (test-type . variants) in rails-goto-file-from-file-actions
	     when (eq test-type buffer-type)
	     do (progn
		  ;; Menu
		  (if show-menu
		      (when-bind (goto-func
				  (rails-core:menu
				   (list "Go To: "
					 (cons "goto"
					       (loop for (func title) in variants
						     collect `(,title  ,func))))))
				 (funcall goto-func))
		    ;;
		    (funcall (caar variants)))
		  (return t)))
     (message "Can't go to some file from this file."))))

(defun rails-goto-file-from-file-with-menu ()
  "Deteminate type of file and goto another file (choose type from menu)"
  (interactive)
  (rails-goto-file-from-file t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;; Open browser ;;;;;;;;;;

(defun rails-open-browser-on-controller (&optional controller  action params) ;(+++)
  "Open browser on controller/action/id"
  ;; Refactor...
  (interactive
   (list
    (completing-read "Controller name: "
		     (list->alist (rails-core:controllers t)))
    (read-from-minibuffer "Action name: ")
    (read-from-minibuffer "Params: ")))
  (rails-core:with-root
   (root)
   (when (string-not-empty controller)
     (rails-webrick-open-browser
      (concat (rails-core:file-by-class controller t) "/"
	      (if (string-not-empty action) (concat action "/")) params)))))

(defun rails-auto-open-browser (ask-parameters?) ;(+++)
  "Autodetect current action and open browser on it
   with prefix ask parameters for action"
  (interactive "P")
  (when-bind (controller (rails-core:current-controller))
	     (rails-open-browser-on-controller
	      controller (rails-core:current-action)
	      (when ask-parameters?
		(read-from-minibuffer "Parameters: ")))))

;;;;;;;;;; Configs ;;;;;;;;;;

(defun rails-open-config (&optional config)
  "Open rails config file"
  (interactive (list (completing-read "Config name: "
				      (list->alist rails-config-files))))
    (rails-core:find-file (concat "config/" config)))

;;;;;;;;;; Logs ;;;;;;;;;;

(defun rails-open-log (&optional env)
  "Open Rails log file for environment ``env''
   (development, production, test)"
  (interactive (list (rails-read-enviroment-name)))
  (rails-core:with-root (root)
     (when (file-exists-p (rails-core:file (concat "/log/" env ".log")))
       (find-file (rails-core:file (concat "/log/" env ".log")))
       (set-buffer-file-coding-system 'utf-8)
       (ansi-color-apply-on-region (point-min) (point-max))
       (set-buffer-modified-p nil)
       (rails-minor-mode t)
       (goto-char (point-max))
       (setq auto-revert-interval 1)
       (setq auto-window-vscroll t)
       (auto-revert-tail-mode t))))


;;;;;;;;;; Rails http server integration ;;;;;;;;;;

(defun rails-webrick-open-browser (&optional address)
  (interactive)
  (let ((url (concat rails-webrick-url "/" address )))
    (message "Opening browser: %s" url)
    (browse-url url)))

(defun rails-webrick-open-buffer()
  (interactive)
  (switch-to-buffer rails-webrick-buffer-name))


(defun rails-webrick-sentinel (proc msg)
  (if (memq (process-status proc) '(exit signal))
        (message
         (concat
          (if rails-use-mongrel "Mongrel" "WEBrick") " stopped"))))

(defun rails-webrick-process-status()
  (let (st)
    (setq st (get-buffer-process rails-webrick-buffer-name))
    (if st t nil)))

(defun rails-webrick-process-stop()
  (interactive)
  (let (proc)
    (setq proc (get-buffer-process rails-webrick-buffer-name))
    (if proc
        (kill-process proc))))

(defun rails-webrick-process (env)
  (let (proc dir root)
    (setq proc (get-buffer-process rails-webrick-buffer-name))
    (unless proc
      (progn
        (setq root (rails-core:root))
        (if root
            (progn
              (setq dir default-directory)
              (setq default-directory root)
              (if rails-use-mongrel
                  (setq proc
                        (apply 'start-process-shell-command
                               "mongrel_rails"
                               rails-webrick-buffer-name
                               "mongrel_rails"
                               (list "start" "0.0.0.0" rails-webrick-port)))
                (setq proc
                      (apply 'start-process-shell-command
                             rails-ruby-command
                             rails-webrick-buffer-name
                             rails-ruby-command
                             (list (concat root "script/server")
                                   (concat " -e " env)
                                   (concat " -p " rails-webrick-port)))))
              (set-process-filter proc 'rails-webrick-filter)
              (set-process-sentinel proc 'rails-webrick-sentinel)
              (setq default-directory dir)

              (message (concat (if rails-use-mongrel
                                   "Mongrel" "Webrick")
                               "(" env  ") started with port " rails-webrick-port)))
          (progn
            (message "RAILS_ROOT not found")))))))

(defun rails-webrick-filter (process line)
  (let ((buffer (current-buffer)))
    (switch-to-buffer rails-webrick-buffer-name)
    (goto-char (point-min))
    (insert line)
    (switch-to-buffer buffer)))

(defun rails-toggle-use-mongrel()
  (interactive)
  (let ((toggle (boundp 'rails-use-mongrel)))
    (setq rails-use-mongrel (not rails-use-mongrel))))

;;;;;;;;;; Documentation stuff ;;;;;;;;;;

(defun rails-search-doc (&rest item)
  (interactive)
  (if (or (not (boundp item))
          (not item))
      (setq item (thing-at-point 'sexp)))
  (unless item
    (setq item (read-string "Search symbol? ")))
  (if item
      (let ((buf (buffer-file-name)))
        (if (and rails-chm-file
                 (file-exists-p rails-chm-file))
            (progn
              (start-process "keyhh" "*keyhh*" "keyhh.exe" "-#klink"
                             (format "'%s'" item)  rails-chm-file))
            (progn
              (unless (string= buf "*ri*")
                (switch-to-buffer-other-window "*ri*"))
              (setq buffer-read-only nil)
              (kill-region (point-min) (point-max))
              (message (concat "Please wait..."))
              (call-process "ri" nil "*ri*" t item)
              (setq buffer-read-only t)
              (local-set-key [return] 'rails-search-doc)
              (goto-char (point-min)))))))

;;;;;;;;;; Version control ;;;;;;;;;;

(defun rails-svn-status-into-root ()
  (interactive)
  (svn-status (rails-core:root)))

;;;;;;;;;; TAGS ;;;;;;;;;;

(defun rails-create-tags ()
  "Create tags file"
  (interactive)
  (rails-core:with-root (root)
    (message "Creating TAGS, please wait...")
    (let ((default-directory root))
      (shell-command (format rails-ctags-command
			     tags-file-name (rails-core:file "app") (rails-core:file "lib"))))    
    (flet ((yes-or-no-p (p) (y-or-n-p p)))
      (visit-tags-table tags-file-name))))

;;;;;;;;;; Error search ;;;;;;;;;;

(defun rails-find-and-goto-error ()
  "Finds error in rails html log ang go to file/line with error "
  (interactive)
  (search-forward-regexp "RAILS_ROOT: \\([^<]*\\)")
  (let ((rails-root (concat (match-string 1) "/")))
    (search-forward "id=\"Application-Trace\"")
    (search-forward "RAILS_ROOT}")
    (search-forward-regexp "\\([^:]*\\):\\([0-9]+\\)")
    (let  ((file (match-string 1))
	   (line (match-string 2)))
      (kill-buffer (current-buffer))
      (message
       (format "Error finded in file \"%s\" on %s line. "  file line))
      (find-file (concat rails-root file))
      (goto-line (string-to-int line)))))

;;;;;;;;;; Hoooks ;;;;;;;;;;;;;;;;;;;;

(add-hook 'ruby-mode-hook
          (lambda()
            (rails-minor-mode t)
            (local-set-key (kbd "C-.") 'complete-tag)
            (if rails-use-another-define-key
                (progn
                  (local-set-key (kbd "TAB") 'ruby-indent-or-complete)
                  (local-set-key (kbd "RET") 'ruby-newline-and-indent))
              (progn
                (local-set-key (kbd "<tab>") 'ruby-indent-or-complete)
                (local-set-key (kbd "<return>") 'ruby-newline-and-indent)))))

(add-hook 'speedbar-mode-hook
          (lambda()
            (speedbar-add-supported-extension "\\.rb")))

(add-hook 'find-file-hooks
          (lambda()
	    (if (and rails-use-mode-in-root (rails-core:root))
		  (rails-minor-mode t))
            (if (and (rails-core:rhtml-buffer-p)
                     (rails-core:root))
                (progn
                  (add-hook 'local-write-file-hooks
                            '(lambda()
                               (save-excursion
                                 (untabify (point-min) (point-max))
                                 (delete-trailing-whitespace))))

                  (rails-minor-mode t)
                  ;(rails-erb-abbrev-init)
                  (if rails-use-another-define-key
                      (local-set-key "TAB"
                                     '(lambda() (interactive)
                                        (if snippet
                                            (snippet-next-field)
                                          (if (looking-at "\\>")
                                              (hippie-expand nil)
                                            (indent-for-tab-command)))))
                    (local-set-key (kbd "<tab>")
                                   '(lambda() (interactive)
                                      (if snippet
                                          (snippet-next-field)
                                        (if (looking-at "\\>")
                                            (hippie-expand nil)
                                          (indent-for-tab-command))))))))))
 
(add-hook 'dired-mode-hook
	  (lambda ()
	    (if (rails-core:root)
		(rails-minor-mode t))))

;;;;;;;;;; Rails minor mode declaration ;;;;;;;;;;

(define-minor-mode rails-minor-mode
  "RubyOnRails"
  nil
  " RoR"
  rails-minor-mode-map

  (abbrev-mode -1)
;  (rails-abbrev-init)

  ;; Tags
  (make-local-variable 'tags-file-name)

  (setq tags-file-name (concat (rails-core:root) "TAGS")))

(provide 'rails)
