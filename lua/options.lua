vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- vim.opt.colorcolumn = "80,100,120"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 3 -- Hide * markup for bold and italic
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldclose:"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = -1
vim.opt.foldmethod = "manual"
vim.opt.formatoptions = "jcroqlnt" -- tcqj
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "Cascadia Code:h11"
vim.opt.hidden = true
vim.opt.ignorecase = true -- Ignore case
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.joinspaces = false -- No double spaces with join after a dot
vim.opt.laststatus = 0
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.listchars:append({ tab = "▸▸", trail = "•" }) -- Make tab, trail more visible
vim.opt.mouse = "a"
vim.opt.nrformats = "alpha,bin,hex"
vim.opt.number = true -- Print line number
vim.opt.pumblend = 0 -- Popup blend
vim.opt.pumheight = 0 -- Maximum number of entries in a popup
vim.opt.relativenumber = false -- Relative line numbers
vim.opt.scrolloff = 3 -- Lines of context
vim.opt.sessionoptions = { "buffers", "curdir", "folds", "help", "winpos", "winsize", "tabpages" }
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.smartcase = true
vim.opt.softtabstop = 4
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.tabstop = 4 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support
vim.opt.timeoutlen = 300
-- vim.opt.undofile = true
-- vim.opt.undolevels = 1000 -- Number of undo saved
vim.opt.updatetime = 200 -- save swap file and trigger CursorHold
-- vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.o.shortmess = "filnxtToOFWIcC"
end

-- fix markdown indentation settings
vim.g.markdown_recommended_style = 0
