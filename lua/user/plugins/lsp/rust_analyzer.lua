return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "simrat39/rust-tools.nvim",
  },
  opts = {
    servers = {
      rust_analyzer = {
        settings = {
          cargo = {
            allFeatures = true,
          },
        },
      },
    },
    setup = {
      rust_analyzer = function(_, server_opts)
        local tools_opts = {}

        require("rust-tools").setup({
          server = vim.tbl_extend("force", server_opts, tools_opts),
        })
      end,
    },
  },
}
