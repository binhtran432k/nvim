-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

local root_pattern = {
  "Makefile",
  "makefile",
  "package.json",
  "Cargo.toml",
  ".git",
}

vim.g.root_spec = { root_pattern, "lsp", "cwd" }

vim.opt.clipboard = ""

vim.opt.formatexpr = "1"
