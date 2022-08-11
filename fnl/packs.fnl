(local {: startup : sync} (require :packer))
(local compile_path (.. (vim.fn.stdpath :config) "/lua/packer_compiled.lua"))

(macro use! [pack opts]
  (if opts
      (let [{: config : setup : mod} opts
	       load-module (fn [mod func]
			     (string.format
			       "require('mods.%s').%s()"
			       mod
			       func))]
	(tset opts 1 pack)
	(when mod
	  (when config
	    (tset opts :config (load-module mod :config)))
	  (when setup
	    (tset opts :setup (load-module mod :setup))))
	opts)
      [pack]))

(fn packer-load [packs]
  (let [{: float} (require :packer.util)]
    (startup {1 (fn [use]
		  (each [_ opts (ipairs packs)]
		    (use opts)))
	     :config {:profile {:enable true}
	     :display {:open_fn float}
	     : compile_path}})))

(packer-load [
	      ;; bootstrap
	      (use! :wbthomason/packer.nvim)
	      (use! :rktjmp/hotpot.nvim)

	      ;; ui
	      (use! :Mofiqul/dracula.nvim {:mod :ui.dracula :config true})

	      ;; util

	      ;; lsp

	      ;; completion

	      ;; tree-sitter

	      ;; lang

	      ])

;; make sure packer is all ready to go
(let [compiled? (= (vim.fn.filereadable compile_path) 1)]
  (if compiled?
      (require :packer_compiled)
      (sync)))
