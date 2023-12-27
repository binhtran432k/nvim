local helper = require("user.helper")

local indent_exclude_fts = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "NvimTree", "noice" }

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPre", "CursorMoved" },
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = false,
    },
    exclude = {
      filetypes = indent_exclude_fts,
    },
  },
  config = function(_, opts)
    helper.on_clean(function()
      vim.cmd("silent! IndentBlanklineRefresh")
    end)
    require("ibl").setup(opts)
  end,
}
