return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  keys = {
    { "<leader>cc", "<cmd>Neogen<cr>", desc = "Neogen document" },
  },
  cmd = "Neogen",
  opts = {
    -- input_after_comment = false,
    enable_placeholders = false,
    snippet_engine = nil, -- "luasnip"
  },
}
