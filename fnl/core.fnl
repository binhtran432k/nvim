(local {: opt
        : g
        : cmd
        : bo
        :api {: nvim_create_augroup : nvim_create_autocmd}} vim)

;; Disable some built-in Neovim plugins and unneeded providers
(let [built-ins [:gzip
                 :zip
                 :zipPlugin
                 :tar
                 :tarPlugin
                 :getscript
                 :getscriptPlugin
                 :vimball
                 :vimballPlugin
                 :2html_plugin
                 :matchit
                 :matchparen
                 :logiPat
                 :rrhelper
                 :spec
                 :netrw
                 :netrwPlugin
                 :netrwSettings
                 :netrwFileHandlers]
      providers [:perl :node :ruby :python :python3]]
  (each [_ v (ipairs built-ins)]
    (let [plugin (.. :loaded_ v)]
      (tset vim.g plugin 1)))
  (each [_ v (ipairs providers)]
    (let [provider (.. :loaded_ v :_provider)]
      (tset vim.g provider 0))))

;; Default key leader
(tset g :mapleader ",")
(tset g :maplocalleader ";")

;; Load common options
(let [options {:termguicolors true
               :background :dark
               :colorcolumn [80]
               :ignorecase true
               :smartcase true
               :cursorline true
               :mouse :a
               :tabstop 4
               :softtabstop 4
               :shiftwidth 4
               :expandtab true
               :smarttab true
               :nrformats [:alpha :bin :hex]
               :number true
               :relativenumber false
               :encoding :utf-8
               :hidden true
               :backup false
               :writebackup false
               :updatetime 250
               :splitbelow true
               :splitright true
               :signcolumn :yes
               :wrap false
               :scrolloff 3
               :sidescrolloff 8
               :completeopt "menu,menuone,noinsert"
               :cmdheight 2
               :list true}]
  (each [key value (pairs options)]
    (tset opt key value)))

;; Make tab, trail more visible
(opt.listchars:append "tab:▸▸")
(opt.listchars:append "trail:•")

;; Extend keyword for css, fennel, ...
(opt.iskeyword:append "-")

;; Make file save position when leave
(opt.viewoptions:remove :options)

; remove options from mkview
(let [gid (nvim_create_augroup :remember_last_jump {})]
  (nvim_create_autocmd [:BufWinLeave :BufWritePost]
                       {:callback (fn []
                                    (when (and (= bo.modifiable true)
                                               (not= (vim.fn.bufname) "")
                                               (not= bo.filetype :help))
                                      (cmd :mkview)))
                        :group gid})
  (nvim_create_autocmd :BufWinEnter
                       {:callback (fn []
                                    (when (not= bo.filetype :help)
                                      (cmd "silent! loadview")))
                        :group gid}))

{}
