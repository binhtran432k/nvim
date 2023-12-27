return {
  "numToStr/Comment.nvim",
  dependencies = {
    { "JoosepAlviste/nvim-ts-context-commentstring" },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        context_commentstring = { enable = true, enable_autocmd = false, disable = "default" },
      },
    },
  },
  keys = {
    { "gc", desc = "+comment line", mode = { "n", "x" } },
    { "gb", desc = "+comment block", mode = { "n", "x" } },
  },
  opts = function()
    return {
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,
  config = function(_, opts)
    require("Comment").setup(opts)
  end,
}
