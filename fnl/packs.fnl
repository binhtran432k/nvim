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
         comment_name :Comment.nvim
         tag_fts [:html :xml :javascriptreact :typescriptreact]
         packs [
                ;; bootstrap
                (use! :wbthomason/packer.nvim)
                (use! :rktjmp/hotpot.nvim)

                ;; ui
                (use! :Mofiqul/dracula.nvim {:mod :ui.dracula :config true})
                (use! :norcalli/nvim-colorizer.lua {:mod :ui.colorizer
                      :event [:BufRead]
                      :config true})

                ;; util
                (use! :gpanders/editorconfig.nvim {:event :BufRead})
                (use! :kylechui/nvim-surround {:mod :util.surround
                      :keys [:ys :yS :S :gS :d :c]
                      :config true})
                (use! :numToStr/Comment.nvim {:mod :util.comment
                      :keys [:gc :gb]
                      :config true})
                (use! :windwp/nvim-autopairs {:mod :util.autopairs
                      :event [:InsertEnter]
                      :config true})
                (use! :dstein64/vim-startuptime {:cmd :StartupTime})

                ;; lsp

                ;; completion

                ;; tree-sitter
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
                                   {:after comment_name})
                                 (use! :p00f/nvim-ts-rainbow
                                       {:after ts_name})
                                 (use! :windwp/nvim-ts-autotag
                                       {:ft tag_fts})
                                 (use! :nvim-treesitter/playground
                                       {:cmd :TSPlaygroundToggle})
                                 ]})

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
