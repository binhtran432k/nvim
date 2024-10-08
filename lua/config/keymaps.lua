-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function set_indent(opts)
  local indent = opts.args ~= "" and tonumber(opts.args) or 4
  vim.bo.shiftwidth = indent
  vim.bo.softtabstop = indent
  vim.bo.tabstop = indent
end

vim.api.nvim_create_user_command("IndentTab", function(opts)
  vim.bo.expandtab = false
  set_indent(opts)
end, {
  nargs = "?",
})

vim.api.nvim_create_user_command("IndentSpace", function(opts)
  vim.bo.expandtab = true
  set_indent(opts)
end, {
  nargs = "?",
})

vim.keymap.set("n", "<leader>y", '"+yy', { desc = "Yank to clipboard" })
vim.keymap.set({ "x", "o", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set({ "n", "x", "o", "v" }, "<leader>p", '"+p', { desc = "Paste to clipboard" })
