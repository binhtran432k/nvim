return {
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim", name = "catppuccin", enabled = false },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
      install = {
        colorscheme = { "dracula", "tokyonight", "habamax" },
      },
    },
  },
  {
    "binhtran432k/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      on_highlights = function(highlights, colors)
        highlights["@tag.attribute"] = { fg = colors.bright_green, italic = true }
      end,
    },
  },
}
