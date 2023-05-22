local settings = require("settings")

local cmp_plugins = {
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "CursorMoved",
    },
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-under-comparator",
      {
        "neovim/nvim-lspconfig",
        ---@type PluginLspOpts
        opts = {
          get_cmp_capabilities = function()
            return require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
          end,
        },
      },
    },
    opts = function()
      local cmp = require("cmp")
      local maxline = 50
      local ellipsis = "..."
      local menu = {
        luasnip = "Snip",
        nvim_lsp = "Lsp",
        buffer = "Buf",
        path = "Path",
        cmdline = "Cmd",
      }
      local function toggle_cmp()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end
      local function close_and_fallback(fallback)
        if cmp.visible() then
          cmp.close()
        end
        fallback()
      end
      return {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = { i = toggle_cmp, c = toggle_cmp },
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = {
            i = close_and_fallback,
            c = close_and_fallback,
          },
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = {
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "path", group_index = 1 },
          { name = "buffer", group_index = 1 },
        },
        formatting = {
          format = function(entry, item)
            local source_name = menu[entry.source.name]
            if source_name then
              item.menu = "⎧" .. source_name .. "⎭"
            end
            local icons = settings.icons.kinds[item.kind]
            if icons then
              item.kind = icons .. item.kind
            end
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, maxline)
            if truncated_label ~= label then
              item.abbr = truncated_label .. ellipsis
            end
            return item
          end,
        },
        window = {
          -- completion = { border = "rounded" },
          -- documentation = { border = "rounded" },
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            -- cmp.config.compare.scopes,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            -- cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = {
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path", group_index = 1 },
          { name = "cmdline", group_index = 2 },
          { name = "buffer", group_index = 3 },
        },
      })
      for _, cmd_type in ipairs({ "/", "?" }) do
        cmp.setup.cmdline(cmd_type, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer", group_index = 1 },
          },
        })
      end

      require("cmp-editorconfig").setup()
      -- Set configuration for specific filetype.
      cmp.setup.filetype("editorconfig", {
        sources = {
          { name = "editorconfig", group_index = 1 },
          { name = "buffer", group_index = 2 },
        },
      })
    end,
  },
}

return cmp_plugins
