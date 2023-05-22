return {
  -- lua
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neodev.nvim",
        opts = {
          library = {
            enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
            -- these settings will be used for your Neovim config directory
            runtime = true, -- runtime path
            types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
            plugins = false, -- installed opt or start plugins in packpath
            -- you can also specify the list of plugins to make available as a workspace library
            -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
          },
          lspconfig = false,
        },
      },
    },
    opts = {
      servers = {
        lua_ls = {
          before_init = function(...)
            require("neodev.lsp").before_init(...)
          end,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
  },

  -- csharp
  {
    "neovim/nvim-lspconfig",
    dependencies = { "Hoffs/omnisharp-extended-lsp.nvim" },
    opts = {
      servers = {
        omnisharp = {
          cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          capabilities = { textDocument = { formatting = true } },
          on_attach = function(client, bufnr)
            -- stylua: ignore
            vim.keymap.set("n", "gd", "<cmd>lua require('omnisharp_extended').telescope_lsp_definitions()<cr>", { desc = "Goto definition (omnisharp)", buffer = bufnr })

            local function toSnakeCase(str)
              return string.gsub(str, "%s*[- ]%s*", "_")
            end

            local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
            for i, v in ipairs(tokenModifiers) do
              tokenModifiers[i] = toSnakeCase(v)
            end
            local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
            for i, v in ipairs(tokenTypes) do
              tokenTypes[i] = toSnakeCase(v)
            end
          end,
          handlers = {
            ["textDocument/definition"] = function(...)
              return require("omnisharp_extended").handler(...)
            end,
          },
        },
      },
    },
  },

  -- python
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          on_attach = function(_, bufnr)
            -- stylua: ignore
            vim.keymap.set("n", "<leader>co", "<cmd>PyrightOrganizeImports<cr>", { desc = "Organize Imports", buffer = bufnr })
          end,
          settings = {
            python = {
              analysis = {
                -- diagnosticMode = 'workspace', -- ["openFilesOnly", "workspace"]
                -- typeCheckingMode = 'off', -- ["off", "basic", "strict"]
                useLibraryCodeForTypes = true,
                completeFunctionParens = true,
              },
            },
          },
          on_init = function(client)
            local path = require("lspconfig/util").path

            local function get_python_dir(workspace)
              if vim.env.VIRTUAL_ENV then
                return vim.env.VIRTUAL_ENV
              end

              local poetry_match = vim.fn.glob(path.join(workspace, "poetry.lock"))
              if poetry_match ~= "" then
                return vim.fn.trim(vim.fn.system(string.format("cd %s && poetry env info -p", workspace)))
              end

              local pipenv_match = vim.fn.glob(path.join(workspace, "Pipfile.lock"))
              if pipenv_match ~= "" then
                return vim.fn.trim(vim.fn.system(string.format("cd %s && pipenv --venv", workspace)))
              end

              -- Find and use virtualenv in workspace directory.
              for _, pattern in ipairs({ "*", ".*" }) do
                local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
                if match ~= "" then
                  return tostring(path.dirname(match))
                end
              end

              return ""
            end

            local function get_pdm_extras_path(workspace)
              local pdm_match = vim.fn.glob(path.join(workspace, "pdm.lock"))
              if pdm_match ~= "" then
                local package = vim.fn.trim(vim.fn.system(string.format("cd %s && pdm info --packages", workspace)))
                if package ~= "" then
                  return path.join(package, "lib")
                end
              end

              return ""
            end

            local function py_bin_dir(venv)
              if _G.is_windows then
                return path.join(venv, "Scripts;")
              else
                return path.join(venv, "bin:")
              end
            end

            local root_dir = client.config.root_dir
            local venv = ""

            if not vim.env.VIRTUAL_ENV or vim.env.VIRTUAL_ENV == "" then
              venv = get_python_dir(root_dir)
            end

            if venv ~= "" then
              vim.env.VIRTUAL_ENV = venv
              vim.env.PATH = py_bin_dir(venv) .. vim.env.PATH

              if vim.env.PYTHONHOME then
                vim.env.old_PYTHONHOME = vim.env.PYTHONHOME
                vim.env.PYTHONHOME = ""
              end
            end

            client.config.settings.python.pythonPath = vim.fn.exepath("python")
            client.config.settings.python.analysis.extraPaths = { get_pdm_extras_path(root_dir) }
          end,
        },
      },
    },
  },

  -- typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          on_attach = function(_, bufnr)
            -- stylua: ignore
            vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize Imports", buffer = bufnr })
            -- stylua: ignore
            vim.keymap.set("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<cr>", { desc = "Remove Unused", buffer = bufnr })
            -- stylua: ignore
            vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<cr>", { desc = "Rename File", buffer = bufnr })
          end,
        },
      },
      setup = {
        tsserver = function(_, config)
          require("typescript").setup({ server = config })
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
        jdtls = {
          settings = {
            java = {
              configuration = {
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- And search for `interface RuntimeOption`
                -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {
                  {
                    name = "JavaSE-1.8",
                    path = "/usr/lib/jvm/java-8-openjdk/",
                  },
                  {
                    name = "JavaSE-11",
                    path = "/usr/lib/jvm/java-11-openjdk/",
                  },
                  {
                    name = "JavaSE-17",
                    path = "/usr/lib/jvm/java-17-openjdk/",
                  },
                  {
                    name = "JavaSE-19",
                    path = "/usr/lib/jvm/java-19-openjdk/",
                  },
                },
              },
            },
          },
        },
      },
      setup = {
        jdtls = function(_, user_config)
          local lspgroup = vim.api.nvim_create_augroup("lspconfig", { clear = false })
          local default_config = require("lspconfig.server_configurations.jdtls").default_config
          local config = vim.tbl_extend("keep", user_config, {
            cmd = default_config.cmd,
            root_dir = default_config.root_dir(vim.loop.cwd()),
            filetypes = default_config.filetypes,
            single_file_support = default_config.single_file_support,
            init_options = default_config.init_options,
            on_attach = function()
              require("jdtls.setup").add_commands()
            end,
          })
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
