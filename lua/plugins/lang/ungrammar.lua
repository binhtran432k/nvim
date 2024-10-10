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
