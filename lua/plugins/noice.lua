return {
  "folke/noice.nvim",
  opts = {
    ---@type NoicePresets
    presets = {
      lsp_doc_border = true,
    },
    lsp = {
      hover = {
        silent = true,
      },
      progress = {
        throttle = 300,
      },
    },
    throttle = 300,
  },
}
