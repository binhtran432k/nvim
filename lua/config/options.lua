-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false

local root_pattern = {
  "Makefile",
  "makefile",
  "package.json",
  "pom.xml",
  "Cargo.toml",
  "CMakeLists.txt",
  "build.gradle",
  ".git",
}

vim.g.root_spec = { root_pattern, "lsp", "cwd" }

vim.o.spelloptions = "camel,noplainbuffer"

vim.opt.clipboard = ""

vim.opt.formatexpr = "1"

vim.filetype.add({
  filename = {
    ["language-configuration.json"] = "jsonc",
  },
  pattern = {
    ["%.env%..*"] = "sh",
    [".*%.vscode/.*%.json"] = "jsonc",
  },
})
