return {
  {
    'kaarmu/typst.vim',
    ft = 'typst',
    lazy = false,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typst_lsp = {
          settings = {
            exportPdf = "never",
          },
        },
      },
    },
  },
}
