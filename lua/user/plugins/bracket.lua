return {
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
    opts = {
      buffer = { suffix = "" },
      file = { suffix = "" },
      treesitter = { suffix = "n" },
    },
    config = function(_, opts)
      require("mini.bracketed").setup(opts)
    end,
  },
}
