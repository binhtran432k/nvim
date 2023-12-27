return {
  "mizlan/iswap.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  cmd = {
    "ISwap",
    "ISwapWith",
    "ISwapNodeWith",
    "ISwapNode",
    "ISwapNodeWithRight",
    "ISwapNodeWithLeft",
  },
  keys = {
    { "<leader>ii", "<cmd>ISwapWith<cr>", desc = "ISwap" },
    { "<leader>in", "<cmd>ISwapNodeWith<cr>", desc = "ISwap Node" },
  },
  config = true,
}
