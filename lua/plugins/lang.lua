return {
  -- { import = "plugins.lang.gherkin" },
  { import = "plugins.lang.json" },
  { import = "plugins.lang.rust" },
  { import = "plugins.lang.moonbit" },
  {
    "nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "editorconfig",
        "html",
        "make",
        "kdl",
        "mermaid",
        -- "superhtml",
        -- "ziggy",
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = {
      diagnostics = {
        float = {
          border = "rounded",
        },
      },
      servers = {
        cssls = {},
        html = {},
        unocss = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("uno.config.ts")(fname)
          end,
        },
      },
    },
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      if opts.servers and opts.servers["*"] and opts.servers["*"].keys then
        opts.servers["*"].keys = vim.tbl_filter(function(key)
          return key[1] ~= "<c-k>"
        end, opts.servers["*"].keys)
      end
    end,
  },
  {
    "conform.nvim",
    opts = {
      -- formatters_by_ft = {
      --   nix = { "alejandra" },
      -- },
    },
  },
  {
    "nvim-lint",
    optional = true,
    opts = function(_, opts)
      if opts.linters_by_ft and opts.linters_by_ft.markdown then
        opts.linters_by_ft.markdown = {}
      end
    end,
  },
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      local ensure_installed = {
        -- astro = true,
        -- tailwindcss = true,
        -- unocss = true,
        -- volar = true,
        -- vtsls = true,
      }
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and not ensure_installed[server] then
          server_opts.mason = false
        end
      end

      -- local disabled_method_map = {
      --   ["textDocument/formatting"] = true,
      --   ["textDocument/rangeFormatting"] = true,
      -- }
      -- local origin_supports_method = vim.lsp.client.supports_method
      -- vim.lsp.client.supports_method = function(self_client, method, ...)
      --   if disabled_method_map[method] then
      --     return false
      --   end
      --   return origin_supports_method(self_client, method, ...)
      -- end
    end,
  },
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {
        -- "markdown-toc",
      }
    end,
  },
}
