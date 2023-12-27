return {
  "andymass/vim-matchup",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      matchup = { enable = true },
    },
  },
  config = function()
    vim.g.matchup_delim_noskips = 1
    vim.g.matchup_enabled = 1
    vim.g.matchup_matchparen_deferred = 1
    vim.g.matchup_matchparen_deferred_show_delay = 100
    vim.g.matchup_matchparen_offscreen = { method = nil }
    vim.g.matchup_matchparen_stopline = 100
    vim.g.matchup_matchparen_timeout = 100
    vim.g.matchup_matchpref = { html = { nolists = 1 } }
    vim.g.matchup_motion_enabled = 1
    vim.g.matchup_text_obj_enabled = 1
  end,
}
