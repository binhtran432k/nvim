return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      vim.treesitter.language.register("langium", { "langium" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        extension = {
          langium = "langium",
        },
      })
    end,
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      require("lspconfig.configs").langiumls = {
        default_config = {
          -- replace it with true path
          cmd = { "langiumls", "--stdio" },
          filetypes = { "langium" },
          single_file_support = true,
          root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
          settings = {
            langium = {
              build = {
                ignorePatterns = "node_modules, out",
              },
            },
          },
        },
      }
      opts.servers = vim.tbl_deep_extend("keep", opts.servers or {}, {
        langiumls = {},
      })
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        langium = { "// %s", "/* %s */" },
      },
    },
  },
}
