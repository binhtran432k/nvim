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
    dev = true,
    ---@type DraculaConfig
    opts = {
      on_highlights = function(highlights, colors)
        highlights.Statement = { fg = colors.pink, style = { italic = true } }
        highlights.PreProc = { fg = colors.pink, style = { italic = true } }
        highlights["@tag.attribute"] = { fg = colors.green, style = { italic = true } }
      end,
    },
  },
}
