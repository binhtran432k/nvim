return {
  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    ft = { "markdown" },
    init = function()
      vim.g.mkdp_browser = "brave-popup"
      vim.g.vim_markdown_no_default_key_mappings = 1
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" } },
  },

  -- remap open browser
  {
    "tyru/open-browser.vim",
    dependencies = { { "itchyny/vim-highlighturl", event = "BufReadPre" } },
    keys = {
      { "gx", "<plug>(openbrowser-smart-search)", desc = "Open Browser", mode = { "n", "x" } },
    },
    init = function()
      vim.g.netrw_nogx = 1
      vim.g.openbrowser_default_search = "duckduckgo"
    end,
  },

  -- highlight colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    opts = {
      render = "background",
    },
    config = function(_, opts)
      require("nvim-highlight-colors").setup(opts)
    end,
  },
}
