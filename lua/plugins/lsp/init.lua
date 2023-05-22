local helper = require("helper")
local settings = require("settings")
local format = require("plugins.lsp.format")
local keymaps = require("plugins.lsp.keymaps")

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      get_cmp_capabilities = nil,
      capabilities = {},
      servers = {
        bashls = {},
        clangd = {},
        cssls = {},
        cucumber_language_server = {
          cmd = { "npx", "cucumber-language-server", "--stdio" },
          root_dir = function(fname)
            local root_files = {
              { "*.sln", "*.csproj", "node_modules/", "cucumber.json" },
              { "Makefile", "makefile", ".git" },
            }
            local util = require("lspconfig.util")
            for _, patterns in ipairs(root_files) do
              local root = util.root_pattern(unpack(patterns))(fname)
              if root then
                return root
              end
            end
          end,
          capabilities = { textDocument = { formatting = true } },
          settings = {
            cucumber = {
              features = {
                -- Cucumber-JVM
                "src/test/**/*.feature",
                -- Cucumber-Ruby Cucumber-Js, Behat, Behave
                "features/**/*.feature",
                -- Pytest-BDD
                "tests/**/*.feature",
                -- SpecFlow
                "*specs*/**/.feature",
                "**/Features/**/*.feature",
                -- Cypress
                "cypress/e2e/**/*.feature",
              },
              glue = {
                -- Cucumber-JVM
                "src/test/**/*.java",
                -- Cucumber-Js
                "features/**/*.ts",
                "features/**/*.tsx",
                -- Behave
                "features/**/*.php",
                -- Behat
                "features/**/*.py",
                -- Pytest-BDD
                "tests/**/*.py",
                -- Cucumber Rust
                "tests/**/*.rs",
                "features/**/*.rs",
                -- Cucumber-Ruby
                "features/**/*.rb",
                -- SpecFlow
                "*specs*/**/.cs",
                "**/Steps/**/*.cs",
                -- Cypress
                "cypress/e2e/**/*{.js,.ts}",
                "cypress/support/step_definitions/**/*{.js,.ts}",
              },
            },
          },
        },
        docker_compose_language_service = {},
        dockerls = {},
        gradle_ls = {},
        hls = {},
        html = {},
        kotlin_language_server = {},
        lemminx = {},
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = true,
              },
            },
          },
        },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts: table):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup formatting and keymaps
      keymaps.always_attach()
      helper.on_lsp_attach(function(client, buffer)
        format.on_attach(client, buffer)
      end)

      -- diagnostics
      for name, icon in pairs(settings.icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)
      -- lspconfig
      local servers = opts.servers
      local capabilities = type(opts.get_cmp_capabilities) == "function" and opts.get_cmp_capabilities() or {}
      capabilities = vim.tbl_deep_extend("force", opts.capabilities, capabilities)
      require("lspconfig.ui.windows").default_options.border = "rounded"

      for server, server_opts in pairs(servers) do
        server_opts = vim.tbl_deep_extend("force", {
          capabilities = capabilities,
        }, server_opts)

        if type(opts.setup[server]) == "function" then
          opts.setup[server](server, server_opts)
        else
          require("lspconfig")[server].setup(server_opts)
        end
      end
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
      local nls = require("null-ls")
      nls.setup({
        sources = {
          nls.builtins.formatting.yapf,
          nls.builtins.formatting.prettierd,
          nls.builtins.formatting.sql_formatter,
          nls.builtins.formatting.stylua.with({
            condition = function(utils)
              return utils.root_has_file({ ".stylua.toml", "stylua.toml" })
            end,
          }),
        },
      })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  -- lightbulb
  {
    "kosayoda/nvim-lightbulb",
    event = "CursorHold",
    config = function()
      require("nvim-lightbulb").setup({ autocmd = { enabled = true }, sign = { priority = 99 } })
      vim.fn.sign_define("LightBulbSign", { text = "", texthl = "", linehl = "", numhl = "" })
    end,
  },
}
