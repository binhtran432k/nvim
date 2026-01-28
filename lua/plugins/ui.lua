-- local beanx_header = [[
--  
--  ████
--  ]]
-- local bean_sitter_header = [[
--      
--  ██
--  ████
--  ██
--       ]]
local neovim_header = [[
███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄  
███▀▀▀██▄   ███    █▀  ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███
 ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀ ]]
local lazyvim_header = [[
                                                           Z
      █████                      ████     ██         z  
     █████                        ████                   
     ███   ███ ███████████████████ ██  █████ 
    ███    ████     ██  ███████████ ███ ████████ 
   ███    ████   ██    ████████████ ███ ███ ██ ███ 
 █████████     ██ ██         ██ █████ ███ ███ ██ ███ 
███████████████████████████████  ███ ███ ███ ██ ███]]

return {
  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      picker = {
        sources = { files = { hidden = true }, explorer = { hidden = true } },
        win = {
          input = {
            keys = {
              ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
            },
          },
        },
      },
      dashboard = {
        preset = {
          header = neovim_header,
        },
      },
    },
  },
  {
    "noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
    },
  },
  {
    "lualine.nvim",
    opts = {
      options = {
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
    },
  },
  {
    "hiphish/rainbow-delimiters.nvim",
    event = { "VeryLazy" },
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      ---@type rainbow_delimiters.config
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
          query = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterCyan",
          "RainbowDelimiterBlue",
          "RainbowDelimiterViolet",
        },
      }
    end,
  },
}
