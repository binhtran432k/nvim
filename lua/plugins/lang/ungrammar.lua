return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.filetype.add({
        extension = {
          ungram = "ungrammar",
        },
      })
    end,
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
      require("lspconfig.configs").ungrammar_languageserver = {
        default_config = {
          -- replace it with true path
          cmd = { "ungrammar-languageserver", "--stdio" },
          filetypes = { "ungrammar" },
          single_file_support = true,
          root_dir = lspconfig.util.root_pattern(".git"),
          settings = {
            ungrammar = {
              validate = {
                enable = true,
              },
            },
          },
        },
      }
      opts.servers = vim.tbl_deep_extend("keep", opts.servers or {}, {
        ungrammar_languageserver = {},
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ungrammar" })
      end
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {
      lang = {
        ungrammar = "// %s",
      },
    },
  },
}
