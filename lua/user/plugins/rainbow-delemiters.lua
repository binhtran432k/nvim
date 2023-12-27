local function get_strategy()
  local errors = 200
  for _, tree in ipairs(vim.treesitter.get_parser():trees()) do
    if tree:root():has_error() and errors >= 0 then
      errors = errors - 1
    else
      return nil
    end
  end
  return require("rainbow-delimiters.strategy.hack")
end

return {
  "HiPhish/rainbow-delimiters.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    vim.g.rainbow_delimiters = {
      strategy = {
        [""] = get_strategy,
      },
      query = {
        [""] = "rainbow-delimiters",
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
