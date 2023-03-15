require("options")
require("filetypes")
require("os")
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("autocmds")
    require("keymaps")
  end
})
require("packs")
