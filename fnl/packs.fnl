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

(let [{: float} (require :packer.util)
         ts_name :nvim-treesitter
         packs [
                ;; bootstrap
                (use! :wbthomason/packer.nvim)
                (use! :rktjmp/hotpot.nvim)

                ;; ui
                (use! :Mofiqul/dracula.nvim {:mod :ui.dracula :config true})

                ;; util
                (use! :nvim-treesitter/nvim-treesitter {:mod :util.treesitter
                      :run ":TSUpdate"
                      :config true
                      :requires [
                                 (use!
                                   :nvim-treesitter/nvim-treesitter-textobjects
                                   {:after ts_name})
                                 (use!
                                   :nvim-treesitter/nvim-treesitter-refactor
                                   {:after ts_name})
                                 (use!
                                   :JoosepAlviste/nvim-ts-context-commentstring
                                   {:after ts_name})
                                 (use! :p00f/nvim-ts-rainbow
                                       {:after ts_name})
                                 (use! :windwp/nvim-ts-autotag
                                       {:after ts_name})
                                 (use! :nvim-treesitter/playground
                                       {:cmd :TSPlaygroundToggle})
                                 ]})
                (use! :gpanders/editorconfig.nvim)
                (use! :kylechui/nvim-surround {:mod :util.surround
                      :config true})
                (use! :numToStr/Comment.nvim {:mod :util.comment
                      :config true})

                ;; lsp

                ;; completion

                ;; tree-sitter

                ;; lang

                ]]
  (startup {1 (fn [use]
                (each [_ opts (ipairs packs)]
                  (use opts)))
           :config {:profile {:enable true}
           :display {:open_fn float}
           : compile_path}}))

;; make sure packer is all ready to go
(let [compiled? (= (vim.fn.filereadable compile_path) 1)]
  (if compiled?
      (require :packer_compiled)
      (sync)))

{}
