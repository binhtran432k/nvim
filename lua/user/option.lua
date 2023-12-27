local function setup()
  vim.g.mapleader = " "
  vim.g.maplocalleader = " "

  vim.opt.ignorecase = true
  vim.opt.colorcolumn = "80" -- make ruler base on text width
  -- Make whitespace more visible
  vim.opt.list = true -- show some invisible characters (tabs, ...)
  vim.opt.listchars:append({ tab = "> ", trail = "$" })
  vim.opt.nrformats = "alpha,bin,hex" -- order of increment <C-a>/<C-x>
  vim.opt.splitbelow = true -- Put new windows below current
  vim.opt.splitright = true -- Put new windows right of current
  vim.opt.smartcase = true -- smart case when searching
  vim.opt.scrolloff = 5 -- view text easier when scrolling
  vim.opt.sidescrolloff = 5 -- view text easier when side(horizontal) scrolling
  vim.opt.wrap = false -- wrap text when exceeding
  --{{{ fold
  vim.opt.foldmethod = "manual"
  vim.opt.foldcolumn = "0"
  vim.opt.foldlevel = 99
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true
  --}}}
  -- {{{ spell
  vim.opt.spell = true
  vim.opt.spelllang = "en,vi"
  vim.opt.spelloptions = "camel"
  -- }}}
  -- {{{ indent
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4
  vim.opt.tabstop = 4
  -- }}}
  vim.opt.number = true -- show line number
  vim.opt.signcolumn = "yes" -- show status in column
  vim.opt.termguicolors = true -- show status in column
end

return {
  setup = setup,
}
