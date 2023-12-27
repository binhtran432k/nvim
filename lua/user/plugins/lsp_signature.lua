return {
  "ray-x/lsp_signature.nvim",
  event = "VeryLazy",
  opts = {
    floating_window = false,
    hint_prefix = "💪 ",
    handler_opts = {
      border = "none", -- double, rounded, single, shadow, none, or a table of borders
    },
  },
  config = function(_, opts)
    require("lsp_signature").setup(opts)
  end,
}
