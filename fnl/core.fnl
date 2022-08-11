(local {: opt : cmd : bo :api {: nvim_create_augroup : nvim_create_autocmd}} vim)

;; load common options
(let [options {:termguicolors true
              :background :dark
              :colorcolumn [80]
              :ignorecase true
              :smartcase true
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
(opt.viewoptions:remove :options) ; remove options from mkview
(let [gid (nvim_create_augroup :remember_last_jump {})]
  (nvim_create_autocmd
    [:BufWinLeave :BufWritePost]
    {:callback (fn []
                 (when (and
                         (= bo.modifiable true)
                         (not= (vim.fn.bufname) "")
                         (not= bo.filetype :help))
                   (cmd :mkview)))})
  (nvim_create_autocmd
    :BufWinEnter
    {:callback (fn []
                 (when (not= bo.filetype :help)
                   (cmd "silent! loadview")))}))
