return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "typst" },
    })
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "typst" } },
  },
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>cp",
        function()
          if vim.g.tinymist then
            -- unpin the main file
            vim.lsp.buf.execute_command({ command = "tinymist.pinMain", arguments = { nil } })
            vim.g.tinymist = nil
          else
            -- pin the main file
            vim.lsp.buf.execute_command({ command = "tinymist.pinMain", arguments = { vim.api.nvim_buf_get_name(0) } })
            vim.g.tinymist = true
          end
        end,
        ft = "typst",
        desc = "Typst Pin",
      },
    },
    opts = {
      servers = {
        tinymist = {
          root_dir = function(...)
            local util = require("lspconfig.util")
            return util.root_pattern("typst.toml", "main.typ")(...)
          end,
          settings = {
            formatterMode = "typstyle",
            formatterPrintWidth = 80,
          },
        },
      },
    },
  },
  -- Typst preview
  -- {
  --   "chomosuke/typst-preview.nvim",
  --   ft = "typst",
  --   build = function()
  --     require("typst-preview").update()
  --   end,
  --   keys = {
  --     {
  --       "<leader>cp",
  --       ft = "typst",
  --       "<cmd>TypstPreviewToggle<cr>",
  --       desc = "Typst Preview",
  --     },
  --   },
  -- },
}
