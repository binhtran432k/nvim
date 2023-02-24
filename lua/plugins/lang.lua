return {
  -- typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {},
      },
      setup = {
        tsserver = function(_, opts)
          require("helper").on_lsp_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { desc = "Organize Imports", buffer = buffer })
              vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
            end
          end)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },

  -- json
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },

  -- java
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {
      servers = {
        jdtls = {},
      },
      setup = {
        jdtls = function(_, user_config)
          local lspgroup = vim.api.nvim_create_augroup("lspconfig", { clear = false })
          local default_config = require("lspconfig.server_configurations.jdtls").default_config
          local config = vim.tbl_extend("keep", user_config, default_config)
          config.root_dir = default_config.root_dir(vim.loop.cwd())
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              require("jdtls").start_or_attach(config)
            end,
            group = lspgroup,
          })
        end,
      },
    },
  },
}
