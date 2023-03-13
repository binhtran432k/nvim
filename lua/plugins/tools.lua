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

  -- browser
  {
    "ray-x/web-tools.nvim",
    ft = { "html", "css", "scss", "hurl", "http" },
    cmd = { "BrowserSync", "BrowserOpen", "BrowserPreview", "TagRename", "HurlRun" },
    opts = {
      keymaps = {
        rename = nil, -- by default use same setup of lspconfig
        repeat_rename = ".", -- . to repeat
      },
      hurl = { -- hurl default
        show_headers = false, -- do not show http headers
        floating = false, -- use floating windows (need guihua.lua)
        formatters = { -- format the result by filetype
          json = { "jq" },
          html = { "prettier", "--parser", "html" },
        },
      },
    },
    config = function(_, opts)
      require("web-tools").setup(opts)
    end,
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
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = {
        html = { css = true, tailwind = true },
        javascriptreact = { tailwind = true },
        typescriptreact = { tailwind = true },
        css = { css = true },
        scss = { css = true, sass = { enable = true } },
        noice = { names = false, always_update = true },
        cmp_menu = { names = false, always_update = true },
        cmp_docs = { names = false, always_update = true },
      },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = true, -- "Name" codes like Blue or blue
        RRGGBBAA = false, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = false, -- CSS rgb() and rgba() functions
        hsl_fn = false, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        -- Available methods are false / true / "normal" / "lsp" / "both"
        -- True is same as normal
        tailwind = false, -- Enable tailwind colors
        -- parsers can contain values used in |user_default_options|
        sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
        virtualtext = "■",
        -- update color values even if buffer is not focused
        -- example use: cmp_menu, cmp_docs
        always_update = false,
      },
      -- all the sub-options of filetypes apply to buftypes
      buftypes = {},
    },
    config = function(_, opts)
      require("colorizer").setup(opts)
    end,
  },

  -- fun effect
  {
    "Eandrju/cellular-automaton.nvim",
    keys = {
      { "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>" },
    },
  },
}
