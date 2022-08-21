(local {: directory-or-nil?} (require :helpers))
(local compile_path (.. (vim.fn.stdpath :config) :/lua/packer_compiled.lua))

(macro use! [pack opts]
  (if opts
      (let [{: config : setup : mod} opts
            load-module (fn [mod func]
                          (string.format "require('mods.%s').%s()" mod func))]
        (tset opts 1 pack)
        (when mod
          (when config
            (tset opts :config (load-module mod :config)))
          (when setup
            (tset opts :setup (load-module mod :setup))))
        opts)
      [pack]))

(fn setup [action]
  (vim.cmd "packadd packer.nvim")
  (let [{: startup action action-fn} (require :packer)
        {: float} (require :packer.util)
        ts-name :nvim-treesitter
        notify-name :nvim-notify
        colorscheme-name :dracula.nvim
        lspconfig-name :nvim-lspconfig
        cmp-name :nvim-cmp
        snip-name :LuaSnip
        telescope-name :telescope.nvim
        conjure-name :conjure
        tag-fts [:html :xml :javascriptreact :typescriptreact]
        packs [;; bootstrap
               (use! :wbthomason/packer.nvim {:opt true})
               (use! :rktjmp/hotpot.nvim)
               ;; ui
               (use! :Mofiqul/dracula.nvim {:mod :ui.dracula :config true})
               ;(use! :RRethy/nvim-base16 {:mod :ui.base16 :config true})
               (use! :brenoprata10/nvim-highlight-colors
                     {:mod :ui.colors :event [:BufRead] :config true})
               (use! :nvim-lualine/lualine.nvim
                     {:mod :ui.lualine :event [:BufRead] :config true})
               (use! :rcarriga/nvim-notify
                     {:mod :ui.notify :event [:BufRead] :config true})
               (use! :kyazdani42/nvim-web-devicons
                     {:mod :ui.web-devicons
                      :module :nvim-web-devicons
                      :config true})
               (use! :xiyaowong/nvim-transparent
                     {:mod :ui.transparent
                      :after colorscheme-name
                      :config true})
               (use! :goolord/alpha-nvim
                     {:mod :ui.alpha :cond directory-or-nil? :config true})
               (use! :stevearc/dressing.nvim
                     {:mod :ui.dressing :event [:BufRead] :config true})
               (use! :akinsho/bufferline.nvim
                     {:mod :ui.bufferline :event [:BufRead] :config true})
               ;; util
               (use! :gpanders/editorconfig.nvim {:event :BufRead})
               (use! :kylechui/nvim-surround
                     {:mod :util.surround :keys [:y :z :Z :d :c] :config true})
               (use! :numToStr/Comment.nvim
                     {:mod :util.comment :keys [:gc :gb] :config true})
               (use! :windwp/nvim-autopairs
                     {:mod :util.autopairs :event [:InsertEnter] :config true})
               (use! :dstein64/vim-startuptime {:cmd :StartupTime})
               (use! :andymass/vim-matchup
                     {:mod :util.matchup :event [:BufRead] :setup true})
               (use! :nvim-lua/plenary.nvim {:module :plenary})
               (use! :ggandor/leap.nvim
                     {:mod :util.leap :keys [:s :S :gs] :config true})
               (use! :kyazdani42/nvim-tree.lua
                     {:mod :util.tree
                      :tag :nightly
                      :cmd [:NvimTreeToggle :NvimTreeFindFileToggle]
                      :keys [:<c-n> :<a-n>]
                      :config true})
               (use! :nvim-telescope/telescope.nvim
                     {:mod :util.telescope
                      :cmd [:Telescope]
                      :keys [:<c-p> :<a-p>]
                      :requires [(use! :nvim-telescope/telescope-fzf-native.nvim
                                       {:run :make
                                        :module :telescope._extensions.fzf})
                                 (use! :benfowler/telescope-luasnip.nvim
                                       {:module :telescope._extensions.luasnip})]
                      :config true})
               (use! :akinsho/toggleterm.nvim
                     {:mod :util.toggleterm
                      :cmd [:ToggleTerm]
                      :keys [:<a-1> :<a-2> :<a-3> :<a-4> :<a-5>]
                      :config true})
               (use! :Olical/conjure
                     {:mod :util.conjure :ft [:fennel :lua] :setup true})
               ;; lsp
               (use! :neovim/nvim-lspconfig
                     {:mod :lsp.lspconfig :event [:BufRead] :config true})
               (use! :williamboman/mason-lspconfig.nvim
                     {:module :mason-lspconfig})
               (use! :williamboman/mason.nvim
                     {:mod :lsp.mason :after lspconfig-name :config true})
               (use! :jose-elias-alvarez/null-ls.nvim
                     {:mod :lsp.null-ls :after lspconfig-name :config true})
               ;; completion
               (use! :hrsh7th/nvim-cmp
                     {:mod :util.cmp
                      :config true
                      :commit :b1ebdb0a17daaad13606b802780313a32e59781b
                      :event [:InsertEnter :CmdlineEnter]
                      :requires [(use! :hrsh7th/cmp-buffer {:after cmp-name})
                                 (use! :hrsh7th/cmp-path {:after cmp-name})
                                 (use! :hrsh7th/cmp-cmdline {:after cmp-name})
                                 (use! :hrsh7th/cmp-nvim-lsp {:after cmp-name})
                                 (use! :PaterJason/cmp-conjure
                                       {:after conjure-name})
                                 (use! :onsails/lspkind-nvim {:module :lspkind})
                                 (use! :L3MON4D3/LuaSnip {:module :luasnip})
                                 (use! :saadparwaiz1/cmp_luasnip
                                       {:after snip-name})
                                 (use! :rafamadriz/friendly-snippets
                                       {:after snip-name})]})
               ;; tree-sitter
               (use! :nvim-treesitter/nvim-treesitter
                     {:mod :ui.treesitter
                      :run ":TSUpdate"
                      :event [:BufRead]
                      :config true
                      :requires [(use! :nvim-treesitter/nvim-treesitter-textobjects
                                       {:after ts-name})
                                 (use! :nvim-treesitter/nvim-treesitter-refactor
                                       {:after ts-name})
                                 (use! :JoosepAlviste/nvim-ts-context-commentstring
                                       {:module :ts_context_commentstring})
                                 (use! :p00f/nvim-ts-rainbow {:after ts-name})
                                 (use! :windwp/nvim-ts-autotag {:ft tag-fts})
                                 (use! :nvim-treesitter/playground
                                       {:cmd :TSPlaygroundToggle})]})
               ;; lang
               (use! :folke/lua-dev.nvim {:module :lua-dev})
               (use! :b0o/schemastore.nvim {:module :schemastore})]]
    (startup {1 (fn [use]
                  (each [_ opts (ipairs packs)]
                    (use opts)))
              :config {:profile {:enable true}
                       :display {:open_fn float}
                       : compile_path}})
    (action-fn)))

;; Make sure packer is all ready to go
(let [compiled? (= (vim.fn.filereadable compile_path) 1)]
  (if compiled?
      (require :packer_compiled)
      (setup :sync)))

;; User command fallback for packer
(let [{:api {: nvim_create_user_command}} vim]
  (nvim_create_user_command :PackerSync #(setup :sync) {})
  (nvim_create_user_command :PackerStatus #(setup :status) {})
  (nvim_create_user_command :PackerCompile #(setup :compile) {}))

{}
