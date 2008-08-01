;;; rails-ui.el --- user interface for emacs-rails

;; Copyright (C) 2006 Galinsky Dmitry <dima dot exe at gmail dot com>

;; Authors: Galinsky Dmitry <dima dot exe at gmail dot com>,
;;          Rezikov Peter <crazypit13 (at) gmail.com>
;; Keywords: ruby rails languages oop

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


;;;;;;;;;; Some init code ;;;;;;;;;;

(unless (boundp 'html-mode-abbrev-table)
  (setq html-mode-abbrev-table (make-abbrev-table)))
(unless (boundp 'html-helper-mode-abbrev-table)
  (setq html-helper-mode-abbrev-table (make-abbrev-table)))

;;;;;;;;;; Interface ;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Rails snips ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(def-snips (ruby-mode-abbrev-table)
  ("ra"      "render :action => \"$${action}\""
             "render (action)\t(ra)")
  ("ral"     "render :action => \"$${action}\", :layout => \"$${layoutname}\""
             "render (action,layout)\t(ral)")
  ("rf"      "render :file => \"$${filepath}\""
             "render (file)\t(rf)")
  ("rfu"     "render :file => \"$${filepath}\", :use_full_path => $${false}"
             "render (file,use_full_path)\t(rfu)")
  ("ri"      "render :inline => \"$${<%= 'hello' %>}\""
             "render (inline)\t(ri)")
  ("ril"     "render :inline => \"$${<%= 'hello' %>}\", :locals => { $${name} => \"$${value}\" }"
             "render (inline,locals)\t(ril)")
  ("rit"     "render :inline => \"$${<%= 'hello' %>}\", :type => :$${rxml})"
             "render (inline,type)\t(rit)")
  ("rl"      "render :layout => \"$${layoutname}\""
             "render (layout)\t(rl)")
  ("rn"      "render :nothing => $${true}"
             "render (nothing)\t(rn)")
  ("rns"     "render :nothing => $${true}, :status => $${401}"
             "render (nothing,status)\t(rns)")
  ("rp"      "render :partial => \"$${item}\""
             "render (partial)\t(rp)")
  ("rpc"     "render :partial => \"$${item}\", :collection => $${items}"
             "render (partial,collection)\t(rpc)")
  ("rpl"     "render :partial => \"$${item}\", :locals => { :$${name} => \"$${value}\"}"
             "render (partial,locals)\t(rpl)")
  ("rpo"     "render :partial => \"$${item}\", :object => $${object}"
             "render (partial,object)\t(rpo)")
  ("rps"     "render :partial => \"$${item}\", :status => $${500}"
             "render (partial,status)\t(rps)")
  ("rt"      "render :text => \"$${Text here...}\""
             "render (text)\t(rt)")
  ("rtl"     "render :text => \"$${Text here...}\", :layout => \"$${layoutname}\""
             "render (text,layout)\t(rtl)")
  ("rtlt"    "render :text => \"$${Text here...}\", :layout => $${true}"
             "render (text,layout => true)\t(rtlt)")
  ("rts"     "render :text => \"$${Text here...}\", :status => $${401}"
             "")
  ("rcea"    "render_component :action => \"$${index}\""
             "render_component (action)\t(rcea)")
  ("rcec"    "render_component :controller => \"$${items}\""
             "render_component (controller)\t(rcec)")
  ("rceca"   "render_component :controller => \"$${items}\", :action => \"$${index}\""
             "render_component (controller, action)\t(rceca)")
  ("rea"     "redirect_to :action => \"$${index}\""
             "redirect_to (action)\t(rea)")
  ("reai"    "redirect_to :action => \"$${show}\", :id => $${@item}"
             "redirect_to (action, id)\t(reai)")
  ("rec"     "redirect_to :controller => \"$${items}\""
             "redirect_to (controller)\t(rec)")
  ("reca"    "redirect_to :controller => \"$${items}\", :action => \"$${list}\""
             "redirect_to (controller, action)\t(reca)")
  ("recai"   "redirect_to :controller => \"$${items}\", :action => \"$${show}\", :id => $${@item}"
             "redirect_to (controller, action, id)\t(recai)")
  ("flash"   "flash[:$${notice}] = \"$${Text here...}\""
             "flash[...]\t(flash)")
  ("logi"    "logger.info \"$${Text here...}\""
             "logger.info\t(logi)")
  ("par"     "params[:$${id}]"
             "params[...]\t(par)")
  ("ses"     "session[:$${user}]"
             "session[...]\t(ses)")
  ("belongs" "belongs_to :$${model}, :class_name => \"$${class}\", :foreign_key => \"$${key}\""
             "belongs_to (class_name,foreign_key)\t(belongs)")
  ("many"    "has_many :$${model}, :class_name => \"$${class}\", :foreign_key => \"$${key}\", :dependent => :$${destroy}"
             "has_many (class_name,foreign_key,dependent)\t(many)")
  ("one"     "has_one :$${model}, :class_name => \"$${class}\", :foreign_key => \"$${key}\", :dependent => :$${destroy}"
             "has_one (class_name,foreign_key,dependent)\t(one)")
  ("valpres" "validates_presence_of :$${attr}"
             "validates_presence_of\t(valpres)")
  ("valuniq" "validates_uniqueness_of :$${attr}"
             "validates_uniqueness_of\t(valuniq)")
  ("valnum"  "validates_numericality_of :$${attr}"
             "validates_numericality_of\t(valnum)")
  ("bp" "breakpoint" "")
  ;; Migrations
  ("mct"     "create_table :$${name} do |t|\n$>$.\nend"
             "create_table (table)\t(mct)")
  ("mctf"    "create_table :$${name}, :force => true do |t|\n$>$.\nend"
             "create_table (table, force)\t(mctf)")
  ("mdt"     "drop_table :$${name}"
             "drop_table (table)\t(mdt)")
  ("mtcl"    "t.column \"$${name}\", :$${type}"
             "t.column (column)\t(mtcl)")
  ("mac"     "add_column :$${table_name}, :$${column_name}, :$${type}"
             "add_column (table, column, type)\t(mac)")
  ("mcc"     "change_column :$${table_name}, :$${column_name}, :$${type}"
             "change_column (table, column, type)\t(mcc)")
  ("mrec"    "rename_column :$${table_name}, :$${column_name}, :$${new_column_name}"
             "rename_column (table, name, new_name)\t(mrec)")
  ("mrmc"    "remove_column :$${table_name}, :$${column_name}"
             "remove_column (table, column)\t(mrmc)")
  ("mai"     "add_index :$${table_name}, :$${column_name}"
             "add_index (table, column)\t(mai)")
  ("mait"    "add_index :$${table_name}, :$${column_name}, :$${index_type}"
             "add_index (table, column, type)\t(mait)")
  ("mrmi"    "remove_index :$${table_name}, :$${column_name}"
             "remove_index (table, column)\t(mrmi)"))


;;;; ERB Snips ;;;;


(def-snips (html-mode-abbrev-table html-helper-mode-abbrev-table)            
  ("ft"      "<%= form_tag :action => \"$${update}\" %>\n$.\n<%= end_form_tag %>"
             "form_tag\t(ft)")
  ("lia"     "<%= link_to \"$${title}\", :action => \"$${index}\" %>"
             "link_to (action)\t(lia)")
  ("liai"    "<%= link_to \"$${title}\", :action => \"$${edit}\", :id => $${@item} %>"
             "link_to (action, id)\t(liai)")
  ("lic"     "<%= link_to \"$${title}\", :controller => \"$${items}\" %>"
             "link_to (controller)\t(lic)")
  ("lica"    "<%= link_to \"$${title}\", :controller => \"$${items}\", :action => \"$${index}\" %>"
             "link_to (controller, action)\t(lica)")
  ("licai"   "<%= link_to \"$${title}\", :controller => \"$${items}\", :action => \"$${edit}\", :id => $${@item} %>"
             "link_to (controller, action, id)\t(licai)")
  ("%h"      "<%=h $${@item} %>"
             "<% h ... %>\t(%h)")
  ("%if"     "<% if $${cond} -%>\n$.\n<% end -%>"
             "<% if/end %>\t(%if)")
  ("%ifel"   "<% if $${cond} -%>\n$.\n<% else -%>\n<% end -%>"
             "<% if/else/end %>\t(%ifel)")
  ("%unless" "<% unless $${cond} -%>\n$.\n<% end -%>"
             "<% unless/end %>\t(%unless)")
  ("%"       "<% $. -%>"
             "<% ... %>\t(%)")
  ("%%"      "<%= $. %>"
             "<%= ... %>\t(%%)"))

;;;;;;;;;; Menu ;;;;;;;;;;

(define-keys rails-minor-mode-menu-bar-map
  ([rails] (cons "RubyOnRails" (make-sparse-keymap "RubyOnRails")))
  ([rails svn-status]
   '(menu-item "SVN status"
	       (lambda()
		 (interactive)
		 (rails-svn-status)
		 :enable (rails-core:root))))
  ([rails tag] '("Update TAGS file" . rails-create-tags))
  ([rails ri] '("Search documentation" . rails-search-doc))
  ([rails sql] '("SQL Rails buffer" . rails-run-sql))
  ([rails breakpointer] '("Run breakpointer" . rails-run-breakpointer))
  ([rails console] '("Run Rails console" . rails-run-console))
  ([rails brows] '("Open browser..." . rails-open-browser-on-controller))
  ([rails auto-brows] '("Open browser on current action" . rails-auto-open-browser))
  ([rails create-project] '("Create new project" . rails-create-project))
  ([rails separator] '("--"))

  ([rails gen] (cons "Generators" (make-sparse-keymap "Generators")))
  ([rails gen migration] '("Migration" . rails-generate-migration))
  ([rails gen scaffold] '("Scaffold" . rails-generate-scaffold))
  ([rails gen model] '("Model" . rails-generate-model))
  ([rails gen controller] '("Controller" . rails-generate-controller))

  ([rails destr] (cons "Destroy" (make-sparse-keymap "Generators")))
  ([rails destr controller] '("Controller" . rails-destroy-controller))
  ([rails destr model] '("Model" . rails-destroy-model))
  ([rails destr scaffold] '("Scaffold" . rails-destroy-scaffold))

  ([rails snip] (cons "Snippets" (make-sparse-keymap "Snippets")))
  ([rails snip render] (cons "render" (make-sparse-keymap "render")))
  ([rails snip render sk-ra]  (snippet-menu-line 'ruby-mode-abbrev-table "ra"))
  ([rails snip render sk-ral] (snippet-menu-line 'ruby-mode-abbrev-table "ral"))
  ([rails snip render sk-rf]  (snippet-menu-line 'ruby-mode-abbrev-table "rf"))
  ([rails snip render sk-rfu] (snippet-menu-line 'ruby-mode-abbrev-table "rfu"))
  ([rails snip render sk-ri]  (snippet-menu-line 'ruby-mode-abbrev-table "ri"))
  ([rails snip render sk-ril] (snippet-menu-line 'ruby-mode-abbrev-table "ril"))
  ([rails snip render sk-rit] (snippet-menu-line 'ruby-mode-abbrev-table "rit"))
  ([rails snip render sk-rl]  (snippet-menu-line 'ruby-mode-abbrev-table "rl"))
  ([rails snip render sk-rn]  (snippet-menu-line 'ruby-mode-abbrev-table "rn"))
  ([rails snip render sk-rns] (snippet-menu-line 'ruby-mode-abbrev-table "rns"))
  ([rails snip render sk-rp]  (snippet-menu-line 'ruby-mode-abbrev-table "rp"))
  ([rails snip render sk-rpc] (snippet-menu-line 'ruby-mode-abbrev-table "rpc"))
  ([rails snip render sk-rpl] (snippet-menu-line 'ruby-mode-abbrev-table "rpl"))
  ([rails snip render sk-rpo] (snippet-menu-line 'ruby-mode-abbrev-table "rpo"))
  ([rails snip render sk-rps] (snippet-menu-line 'ruby-mode-abbrev-table "rps"))
  ([rails snip render sk-rt] (snippet-menu-line 'ruby-mode-abbrev-table "rt"))
  ([rails snip render sk-rtl] (snippet-menu-line 'ruby-mode-abbrev-table "rtl"))
  ([rails snip render sk-rtlt] (snippet-menu-line 'ruby-mode-abbrev-table "rtlt"))
  ([rails snip render sk-rcea] (snippet-menu-line 'ruby-mode-abbrev-table "rcea"))
  ([rails snip render sk-rcec] (snippet-menu-line 'ruby-mode-abbrev-table "rcec"))
  ([rails snip render sk-rceca] (snippet-menu-line 'ruby-mode-abbrev-table "rceca"))

  ([rails snip redirect_to] (cons "redirect_to" (make-sparse-keymap "redirect_to")))
  ([rails snip redirect_to sk-rea] (snippet-menu-line 'ruby-mode-abbrev-table "rea"))
  ([rails snip redirect_to sk-reai] (snippet-menu-line 'ruby-mode-abbrev-table "reai"))
  ([rails snip redirect_to sk-rec] (snippet-menu-line 'ruby-mode-abbrev-table "rec"))
  ([rails snip redirect_to sk-reca] (snippet-menu-line 'ruby-mode-abbrev-table "reca"))
  ([rails snip redirect_to sk-recai] (snippet-menu-line 'ruby-mode-abbrev-table "recai"))

  ([rails snip controller] (cons "controller" (make-sparse-keymap "controller")))
  ([rails snip controller sk-flash] (snippet-menu-line 'ruby-mode-abbrev-table "flash"))
  ([rails snip controller sk-logi] (snippet-menu-line 'ruby-mode-abbrev-table "logi"))
  ([rails snip controller sk-params] (snippet-menu-line 'ruby-mode-abbrev-table "par"))
  ([rails snip controller sk-session] (snippet-menu-line 'ruby-mode-abbrev-table "ses"))

  ([rails snip model] (cons "model" (make-sparse-keymap "model")))
  ([rails snip model sk-belongs_to] (snippet-menu-line 'ruby-mode-abbrev-table "belongs"))
  ([rails snip model sk-has_many] (snippet-menu-line 'ruby-mode-abbrev-table "many"))
  ([rails snip model sk-has_one] (snippet-menu-line 'ruby-mode-abbrev-table "one"))
  ([rails snip model sk-val_pres] (snippet-menu-line 'ruby-mode-abbrev-table "valpres"))
  ([rails snip model sk-val_uniq] (snippet-menu-line 'ruby-mode-abbrev-table "valuniq"))
  ([rails snip model sk-val_num] (snippet-menu-line 'ruby-mode-abbrev-table "valnum"))
  ([rails snip migrations] (cons "migrations" (make-sparse-keymap "model")))
  ([rails snip migrations mct] (snippet-menu-line 'ruby-mode-abbrev-table "mct"))
  ([rails snip migrations mctf] (snippet-menu-line 'ruby-mode-abbrev-table "mctf"))
  ([rails snip migrations mdt] (snippet-menu-line 'ruby-mode-abbrev-table "mdt"))
  ([rails snip migrations mtcl] (snippet-menu-line 'ruby-mode-abbrev-table "mtcl"))
  ([rails snip migrations mac] (snippet-menu-line 'ruby-mode-abbrev-table "mac"))
  ([rails snip migrations mcc] (snippet-menu-line 'ruby-mode-abbrev-table "mcc"))
  ([rails snip migrations mrec] (snippet-menu-line 'ruby-mode-abbrev-table "mrec"))
  ([rails snip migrations mrmc] (snippet-menu-line 'ruby-mode-abbrev-table "mrmc"))
  ([rails snip migrations mai] (snippet-menu-line 'ruby-mode-abbrev-table "mai"))
  ([rails snip migrations mait] (snippet-menu-line 'ruby-mode-abbrev-table "mait"))
  ([rails snip migrations mrmi] (snippet-menu-line 'ruby-mode-abbrev-table "mrmi"))

  ([rails snip rhtml] (cons "rhtml" (make-sparse-keymap "rhtml")))
  ([rails snip rhtml sk-erb-ft] (snippet-menu-line 'html-mode-abbrev-table "ft"))
  ([rails snip rhtml sk-erb-lia] (snippet-menu-line 'html-mode-abbrev-table "lia"))
  ([rails snip rhtml sk-erb-liai] (snippet-menu-line 'html-mode-abbrev-table "liai"))
  ([rails snip rhtml sk-erb-lic] (snippet-menu-line 'html-mode-abbrev-table "lic"))
  ([rails snip rhtml sk-erb-lica] (snippet-menu-line 'html-mode-abbrev-table "lica"))
  ([rails snip rhtml sk-erb-licai] (snippet-menu-line 'html-mode-abbrev-table "licai"))
  ([rails snip rhtml sk-erb-h] (snippet-menu-line 'html-mode-abbrev-table "%h"))
  ([rails snip rhtml sk-erb-if] (snippet-menu-line 'html-mode-abbrev-table "%if"))
  ([rails snip rhtml sk-erb-unless] (snippet-menu-line 'html-mode-abbrev-table "%unless"))
  ([rails snip rhtml sk-erb-ifel] (snippet-menu-line 'html-mode-abbrev-table "%ifel"))
  ([rails snip rhtml sk-erb-block] (snippet-menu-line 'html-mode-abbrev-table "%"))
  ([rails snip rhtml sk-erb-echo-block] (snippet-menu-line 'html-mode-abbrev-table "%%"))

  ([rails log] (cons "Open log" (make-sparse-keymap "Open log")))

  ([rails log test]
   '("test.log" . (lambda() (interactive) (rails-open-log "test"))))
  ([rails log pro]
   '("production.log" . (lambda() (interactive) (rails-open-log "production"))))
  ([rails log dev]
   '("development.log" . (lambda() (interactive) (rails-open-log "development"))))
  ([rails log log] '("open log..." . rails-open-log))

  ([rails config] (cons "Configuration" (make-sparse-keymap "Configuration")))

  ([rails config routes]
   '("routes.rb" . (lambda ()
		     (interactive)
		     (rails-open-config "routes.rb"))))
  ([rails config environment]
   '("environment.rb" .
     (lambda()
       (interactive)
       (rails-open-config "environment.rb"))))
  ([rails config database]
   '("database.yml" .
     (lambda()
       (interactive)
       (rails-open-config "database.yml"))))
  ([rails config boot]
   '("boot.rb" .
     (lambda()
       (interactive)
       (rails-open-config "boot.rb"))))

  ([rails config env] (cons "environments" (make-sparse-keymap "environments")))
  ([rails config env test]
   '("test.rb" .
     (lambda()
       (interactive)
       (rails-open-config "environments/test.rb"))))
  ([rails config env production]
   '("production.rb" .
     (lambda()
       (interactive)
       (rails-open-config "environments/production.rb"))))
  ([rails config env development]
   '("development.rb" .
     (lambda()
       (interactive)
       (rails-open-config "environments/development.rb"))))
  ([rails config config] '("open config..." . rails-open-config))

  ([rails webrick] (cons "WEBrick" (make-sparse-keymap "WEBrick")))

  ([rails webrick mongrel]
   '(menu-item "Use Mongrel" rails-toggle-use-mongrel
	       :enable (not (rails-webrick-process-status))
	       :button (:toggle
			. (and (boundp 'rails-use-mongrel)
			       rails-use-mongrel))))

  ([rails webrick separator] '("--"))

  ([rails webrick buffer]
   '(menu-item "Show buffer"
	       rails-webrick-open-buffer
	       :enable (rails-webrick-process-status)))
  ([rails webrick url]
   '(menu-item "Open browser"
	       rails-webrick-open-browser
	       :enable (rails-webrick-process-status)))
  ([rails webrick stop]
   '(menu-item "Stop"
	       rails-webrick-process-stop
	       :enable (rails-webrick-process-status)))
  ([rails webrick test]
   '(menu-item "Start test"
	       (lambda() (interactive)
		 (rails-webrick-process "test"))
	       :enable (not (rails-webrick-process-status))))
  ([rails webrick production]
   '(menu-item "Start production"
	       (lambda() (interactive)
		 (rails-webrick-process "production"))
	       :enable (not (rails-webrick-process-status))))
  ([rails webrick development]
   '(menu-item "Start development"
	       (lambda() (interactive)
		 (rails-webrick-process "development"))
	       :enable (not (rails-webrick-process-status))))

  ([rails create-helper]
   '(menu-item "Create helper function"
	       rails-create-helper-from-block
	       :enable (rails-is-current-buffer-rhtml)))
    
  ([rails create-partial]
   '(menu-item "Create partial from selection"
	       rails-create-partial-from-selection
	       :enable (rails-is-current-buffer-rhtml)))

  ([rails goto-file-by-line] '("Goto file by line" . rails-goto-file-on-current-line))
  ([rails switch-file-menu] '("Switch file menu..." . rails-goto-file-from-file-with-menu))
  ([rails switch-file] '("Switch file" . rails-goto-file-from-file)))



(define-keys rails-minor-mode-map
  ([menu-bar] rails-minor-mode-menu-bar-map)
  ((kbd "\C-c p") 'rails-create-partial-from-selection)
  ((kbd "\C-c b") 'rails-create-helper-from-block)
  ((kbd "<M-S-down>")  'rails-goto-file-from-file-with-menu)
  ((kbd "\C-c t")  'rails-goto-file-from-file)
;;   ((kbd "\C-c t m") 'rails-goto-model)
;;   ((kbd "\C-c t c") 'rails-goto-controller)
  ((kbd "\C-c <f4> m") 'rails-goto-model)
  ((kbd "\C-c <f4> c") 'rails-goto-controller)
  ((kbd "\C-c <f5>") 'rails-auto-open-browser)
  ((kbd "\C-c \C-x <f5>") 'rails-open-browser-on-controller)
  
  ((kbd "\C-c v") 'rails-svn-status-into-root)
  ((kbd "\C-c l") 'rails-open-log)
  ((kbd "\C-c o") 'rails-open-config)
  ((kbd "\C-c \C-t") 'rails-create-tags)
  ((kbd "\C-c \C-z") 'rails-run-sql)
  
  ;; Scripts
  ((kbd "\C-c g c") 'rails-generate-controller)
  ((kbd "\C-c g m") 'rails-generate-model)
  ((kbd "\C-c g s") 'rails-generate-scaffold)
  ((kbd "\C-c g i") 'rails-generate-migration)
  ((kbd "\C-c d c") 'rails-destroy-controller)
  ((kbd "\C-c d m") 'rails-destroy-model)
  ((kbd "\C-c d s") 'rails-destroy-scaffold)
  ((kbd "\C-c z")   'rails-run-console)
  ((kbd "\C-c \C-b") 'rails-run-breakpointer)
  ;; Rails finds
  ((kbd "\C-c \C-f c") 'rails-find-controller)
  ((kbd "\C-c \C-f v") 'rails-find-view)
  ((kbd "\C-c \C-f l") 'rails-find-layout)
  ((kbd "\C-c \C-f d") 'rails-find-db)
  ((kbd "\C-c \C-f p") 'rails-find-public)
  ((kbd "\C-c \C-f h") 'rails-find-helpers)
  ((kbd "\C-c \C-f m") 'rails-find-models)
  ((kbd "\C-c \C-f o") 'rails-find-config)
  ((kbd "<f2> c") 'rails-find-controller)
  ((kbd "<f2> v") 'rails-find-view)
  ((kbd "<f2> l") 'rails-find-layout)
  ((kbd "<f2> d") 'rails-find-db)
  ((kbd "<f2> p") 'rails-find-public)
  ((kbd "<f2> h") 'rails-find-helpers)
  ((kbd "<f2> m") 'rails-find-models)
  ((kbd "<f2> o") 'rails-find-config)
  ((kbd "<C-return>") 'rails-goto-file-on-current-line)
  ;;; Doc
  ([f1]  'rails-search-doc))

(provide 'rails-ui)