return {
  -- Configure LazyVim to load gruvbox
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
    ---@type DraculaConfig
    opts = {
      on_highlights = function(highlights, colors)
        highlights["@tag.attribute"] = { fg = colors.bright_green, style = { italic = true } }
      end,
    },
  },
}
