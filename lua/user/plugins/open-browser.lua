return {
  "tyru/open-browser.vim",
  dependencies = { "itchyny/vim-highlighturl", event = "BufReadPre" },
  keys = {
    { "gx", "<plug>(openbrowser-smart-search)", desc = "Open Browser", mode = { "n", "x" } },
  },
  init = function()
    vim.g.netrw_nogx = 1
    vim.g.openbrowser_default_search = "duckduckgo"
  end,
}
