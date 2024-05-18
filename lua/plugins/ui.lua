return {
  -- noice
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      lsp = {
        hover = {
          silent = true,
        },
        progress = {
          throttle = 300,
        },
      },
      throttle = 300,
    },
  },
  -- rainbow delimiters
  {
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
  },
  -- colorizer
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
  },
  -- better input
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        insert_only = false,
      },
    },
  },
  -- status bar
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
    },
  },
}
