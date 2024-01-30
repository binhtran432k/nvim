return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "LazyFile" },
  config = function()
    vim.g.rainbow_delimiters = {
      blacklist = {
        "zig",
      },
      query = {
        javascript = "rainbow-delimiters-react",
        query = "rainbow-blocks",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
    }
  end,
}
