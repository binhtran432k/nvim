(local {: directory-or-nil?} (require :helpers))
(local compile-path (.. (vim.fn.stdpath :config) :/lua/packer_compiled.lua))

(fn testplugins [path]
  (.. (vim.fn.stdpath :config) :/testplugins/ path))

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
                     {:mod :ui.notify
                      :event [:BufRead]
                      :module :telescope._extensions.notify
                      :config true})
               (use! :kyazdani42/nvim-web-devicons
                     {:mod :ui.web-devicons
                      :module :nvim-web-devicons
                      :config true})
               ;; (use! :xiyaowong/nvim-transparent
               ;;       {:mod :ui.transparent
               ;;        :after colorscheme-name
               ;;        :config true})
               (use! :goolord/alpha-nvim
                     {:mod :ui.alpha :cond directory-or-nil? :config true})
               (use! :stevearc/dressing.nvim
                     {:mod :ui.dressing :event [:BufRead] :config true})
               (use! :akinsho/bufferline.nvim
                     {:mod :ui.bufferline
                      :event [:BufRead]
                      :setup true
                      :config true})
               (use! :lewis6991/gitsigns.nvim
                     {:mod :ui.gitsigns :event [:BufRead] :config true})
               (use! :lukas-reineke/indent-blankline.nvim
                     {:mod :ui.indent-blankline :event [:BufRead] :config true})
               (use! :kevinhwang91/nvim-ufo
                     {:mod :ui.ufo
                      :event [:BufRead]
                      :requires [(use! :kevinhwang91/promise-async
                                       {:module :promise})]
                      :config true})
               ;; util
               (use! :gpanders/editorconfig.nvim {:event :BufRead})
               (use! :kylechui/nvim-surround
                     {:mod :util.surround :event [:BufRead] :config true})
               (use! :numToStr/Comment.nvim
                     {:mod :util.comment :keys [:gc :gb] :config true})
               (use! :windwp/nvim-autopairs
                     {:mod :util.autopairs :event [:InsertEnter] :config true})
               (use! :dstein64/vim-startuptime {:cmd :StartupTime})
               (use! :andymass/vim-matchup
                     {:mod :util.matchup :event [:BufRead] :setup true})
               (use! :nvim-lua/plenary.nvim {:module :plenary})
               ;; (use! :ggandor/leap.nvim
               ;;       {:mod :util.leap :keys [:s :S :gs] :config true})
               (use! :phaazon/hop.nvim
                     {:mod :util.hop
                      :cmd [:HopChar1 :HopWord]
                      :module :hop
                      :setup true
                      :config true})
               (use! :mfussenegger/nvim-treehopper
                     {:mod :util.treehopper :module :tsht :setup true})
               (use! :kyazdani42/nvim-tree.lua
                     {:mod :util.tree
                      :tag :nightly
                      :cmd [:NvimTreeToggle :NvimTreeFindFileToggle]
                      :setup true
                      :config true})
               (use! :nvim-telescope/telescope.nvim
                     {:mod :util.telescope
                      :cmd [:Telescope]
                      :requires [(use! :nvim-telescope/telescope-fzf-native.nvim
                                       {:run :make
                                        :module :telescope._extensions.fzf})
                                 (use! :benfowler/telescope-luasnip.nvim
                                       {:module :telescope._extensions.luasnip})
                                 (use! :nvim-telescope/telescope-symbols.nvim
                                       {:after telescope-name})]
                      :setup true
                      :config true})
               (use! :akinsho/toggleterm.nvim
                     {:mod :util.toggleterm
                      :cmd [:ToggleTerm :ToggleTermLazygit :ToggleTermRanger]
                      :setup true
                      :config true})
               (use! :Olical/conjure
                     {:mod :util.conjure :ft [:fennel :lua] :setup true})
               (use! :ahmedkhalf/project.nvim
                     {:mod :util.project
                      :event [:BufRead]
                      :module :telescope._extensions.project
                      :config true})
               (use! :chaoren/vim-wordmotion
                     {:mod :util.wordmotion :event [:BufRead] :setup true})
               (use! :folke/todo-comments.nvim
                     {:mod :util.todo-comments
                      :event [:BufRead]
                      :module :telescope._extensions.todo-comments
                      :config true})
               (use! :tyru/open-browser.vim
                     {:mod :util.open-browser
                      :event [:BufRead]
                      :requires [(use! :itchyny/vim-highlighturl
                                       {:event [:BufRead]})]
                      :setup true})
               (use! :mizlan/iswap.nvim
                     {:mod :util.iswap
                      :cmd [:ISwap :ISwapWith :ISwapNode :ISwapNodeWith]
                      :setup true
                      :config true})
               (use! :folke/which-key.nvim
                     {:mod :util.which-key
                      :event [:BufRead]
                      :setup true
                      :config true})
               (use! :nathom/filetype.nvim
                     {:mod :util.filetype :event [:BufRead] :config true})
               (use! :antoinemadec/FixCursorHold.nvim {:event [:BufRead]})
               ;; lsp
               (use! :neovim/nvim-lspconfig
                     {:mod :lsp.lspconfig :event [:BufRead] :config true})
               (use! :williamboman/mason-lspconfig.nvim
                     {:module :mason-lspconfig})
               (use! :williamboman/mason.nvim
                     {:mod :lsp.mason :after lspconfig-name :config true})
               (use! :jose-elias-alvarez/null-ls.nvim
                     {:mod :lsp.null-ls :after lspconfig-name :config true})
               (use! :kosayoda/nvim-lightbulb
                     {:mod :lsp.lightbulb
                      :event [:CursorHold :CursorHoldI]
                      :config true})
               (use! :ray-x/lsp_signature.nvim {:module :lsp_signature})
               ;; completion
               (use! :hrsh7th/nvim-cmp
                     {:mod :util.cmp
                      :config true
                      :event [:InsertEnter :CmdlineEnter]
                      :module :cmp
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
                      :setup true
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
                                       {:cmd [:TSPlaygroundToggle
                                              :TSCaptureUnderCursor
                                              :TSHighlightCapturesUnderCursor
                                              :TSNodeUnderCursor]})]})
               ;; lang
               (use! :folke/lua-dev.nvim {:module :lua-dev})
               (use! :b0o/schemastore.nvim {:module :schemastore})
               (use! :iamcco/markdown-preview.nvim
                     {:mod :lang.markdown-preview
                      :run "cd app && npm install"
                      :setup true
                      :ft [:markdown]})
               (use! :jose-elias-alvarez/typescript.nvim
                     {:mod :lang.typescript
                      :ft [:javascript
                           :typescript
                           :javascriptreact
                           :typescriptreact]
                      :config true})
               (use! :mfussenegger/nvim-jdtls
                     {:mod :lang.jdtls :ft [:java] :config true})]]
    (startup {1 (fn [use]
                  (each [_ opts (ipairs packs)]
                    (use opts)))
              :config {:profile {:enable true}
                       :display {:open_fn float}
                       :compile_path compile-path}})
    (action-fn)))

;; Make sure packer is all ready to go
(let [compiled? (= (vim.fn.filereadable compile-path) 1)]
  (if compiled?
      (require :packer_compiled)
      (setup :sync)))

;; User command fallback for packer
(let [{:api {: nvim_create_user_command}} vim]
  (nvim_create_user_command :PackerSync #(setup :sync) {})
  (nvim_create_user_command :PackerStatus #(setup :status) {})
  (nvim_create_user_command :PackerCompile #(setup :compile) {})
  (nvim_create_user_command :PackerProfile #(setup :profile_output) {}))

{}
