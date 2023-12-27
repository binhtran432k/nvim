return {
  "kyazdani42/nvim-tree.lua",
  dependencies = {
    {
      "antosha417/nvim-lsp-file-operations",
      config = function()
        require("lsp-file-operations").setup()
      end,
    },
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Tree" },
  },
  opts = {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    renderer = {
      group_empty = true,
      indent_markers = {
        enable = true,
      },
    },
  },
}
