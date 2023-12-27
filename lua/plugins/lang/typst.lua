return {
  {
    "neovim/nvim-lspconfig",
    ---@type PluginLspOpts
    opts = {
      servers = {
        typst_lsp = {
          settings = {
            exportPdf = "never", -- Choose onType, onSave or never.
          },
        },
      },
    },
  },

  {
    "kaarmu/typst.vim",
    ft = "typst",
    lazy = false,
  },
}
