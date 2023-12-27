return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    opts = {
      servers = { tsserver = {} },
      setup = {
        tsserver = function(_, server_opts)
          local api = require("typescript-tools.api")
          local tools_opts = {
            handlers = {
              ["textDocument/publishDiagnostics"] = api.filter_diagnostics({ 80001 }),
            },
          }
          require("typescript-tools").setup(vim.tbl_extend("force", server_opts, tools_opts))
        end,
      },
    },
  },
}
