local indent_exclude_fts = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "NvimTree", "noice" }

return {
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = { "BufReadPre", "CursorMoved" },
    opts = {
      draw = { animation = function() return 0 end },
      symbol = "│",
      options = {
        border = "top",
        try_as_border = true,
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = indent_exclude_fts,
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },
}
