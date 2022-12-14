(local {: opt
        : opt_global
        : g
        : cmd
        : bo
        :api {: nvim_create_augroup
              : nvim_create_autocmd
              : nvim_create_user_command}
        :keymap {:set map}} vim)

(local format string.format)

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
               :colorcolumn [80 100 120]
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
               :list true
               :fillchars "eob: ,fold: ,foldopen:???,foldsep: ,foldclose:???"
               :foldmethod :manual
               :foldlevel 99
               :foldlevelstart -1
               :foldcolumn :1}]
  (each [key value (pairs options)]
    (tset opt key value)))

;; Make tab, trail more visible
(opt.listchars:append "tab:??????")
(opt.listchars:append "trail:???")

;; Extend keyword for css, fennel, ...
(opt.iskeyword:append "-")

;; Make file save position when leave
(opt.viewoptions:remove :options)

;; [[ Autocmd ]]
;; remove options from mkview
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

(let [gid (nvim_create_augroup :auto_reload {})]
  (nvim_create_autocmd [:FocusGained :BufEnter]
                       {:callback (fn []
                                    (when (not= (vim.fn.mode) :c)
                                      (cmd :checktime)))
                        :group gid})
  (nvim_create_autocmd :FileChangedShellPost
                       {:callback (fn []
                                    (vim.notify "File changed on disk. Buffer reloaded."
                                                vim.log.levels.WARN))
                        :group gid}))

(let [gid (nvim_create_augroup :smartindent {})
      {: auto-indent} (require :helpers)]
  (nvim_create_user_command :AutoIndent auto-indent {})
  (nvim_create_autocmd :BufWinEnter {:callback auto-indent :group gid}))

;; Ibus
(set g.ibus_default_engine :BambooUs)

(fn trigger-ibus [im]
  (vim.cmd (string.format "silent! execute '!ibus engine ' . g:%s" im)))

(var ibus-on? false)

(fn trigger-ibus-off []
  (when (not ibus-on?)
    (set ibus-on? true)
    (let [current-engine (vim.fn.system "ibus engine")]
      (when (not= current-engine g.ibus_default_engine)
        (trigger-ibus :ibus_default_engine))
      (when (not= current-engine g.ibus_prev_engine)
        (set g.ibus_prev_engine current-engine)))))

(fn trigger-ibus-on []
  (when ibus-on?
    (set ibus-on? false)
    (let [current-engine (vim.fn.system "ibus engine")]
      (when (not= current-engine g.ibus_prev_engine)
        (trigger-ibus :ibus_prev_engine)
        (set g.ibus_prev_engine current-engine)))))

(let [gid (nvim_create_augroup :smart_ibus {})]
  (nvim_create_autocmd [:InsertEnter :CmdlineEnter]
                       {:callback trigger-ibus-on :group gid})
  (nvim_create_autocmd [:CursorHold :InsertLeave :CmdlineLeave]
                       {:callback trigger-ibus-off :group gid}))

;; [[ Mapping ]]
(map :n :<c-l> (fn []
                 (cmd :nohlsearch|diffupdate)
                 (cmd :AutoIndent)
                 (match (pcall require :notify)
                   (true {: dismiss}) (dismiss {:silent true :pending true}))
                 (match (pcall require :indent_blankline)
                   true (cmd :IndentBlanklineRefresh))
                 (cmd "TSDisable rainbow|TSEnable rainbow|TSDisable matchup|TSEnable matchup"))
     {:desc "Clear screen"})

(macro noresilent [mode lhs rhs opts]
  (fn set! [k v]
    (when (= (. opts k) nil)
      (tset opts k v)))

  (set! :noremap true)
  (set! :silent true)
  `(values ,mode ,lhs ,rhs ,opts))

;; simple text objects
(map (noresilent [:x :o] :ae ":<c-u>norm! mzggV'zG<cr>" {:desc "all file"}))
(map (noresilent [:x :o] :il ":<c-u>norm! _vg$h<cr>"
                 {:desc "line without indent"}))

(map (noresilent [:x :o] :al ":<c-u>norm! 0vg$h<cr>" {:desc :line}))

(map :n :<a-j> ":<c-u>resize -4<cr>" {})
(map :n :<a-k> ":<c-u>resize +4<cr>" {})
(map :n :<a-h> ":<c-u>vertical resize -4<cr>" {})
(map :n :<a-l> ":<c-u>vertical resize +4<cr>" {})

{}
