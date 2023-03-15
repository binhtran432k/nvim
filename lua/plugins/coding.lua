local settings = require("settings")

return {
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
    },
    opts = function()
      local cmp = require("cmp")
      local maxline = 50
      local ellipsis = "..."
      local menu = {
        luasnip = "[Snip]",
        nvim_lsp = "[Lsp]",
        buffer = "[Buf]",
        path = "[Path]",
        cmdline = "[Cmd]",
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
          ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = {
          { name = "nvim_lsp", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "path", group_index = 1 },
          { name = "buffer", group_index = 1 },
        },
        formatting = {
          format = function(entry, item)
            item.menu = menu[entry.source.name]
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

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        autopairs = { enable = true, disable = "default" },
      },
    },
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      enable_check_bracket_line = false,
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, plugin_opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(plugin_opts)

      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      -- auto add space
      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        Rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return vim.tbl_contains({
              brackets[1][1] .. brackets[1][2],
              brackets[2][1] .. brackets[2][2],
              brackets[3][1] .. brackets[3][2],
            }, pair)
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({
              brackets[1][1] .. "  " .. brackets[1][2],
              brackets[2][1] .. "  " .. brackets[2][2],
              brackets[3][1] .. "  " .. brackets[3][2],
            }, context)
          end),
      })
      for _, bracket in pairs(brackets) do
        Rule("", " " .. bracket[2])
          :with_pair(cond.none())
          :with_move(function(opts)
            return opts.char == bracket[2]
          end)
          :with_cr(cond.none())
          :with_del(cond.none())
          :use_key(bracket[2])
      end

      -- javascript arrow key
      npairs.add_rules({
        Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
          :use_regex(true)
          :set_end_pair_length(2),
      })

      -- c style comment block
      npairs.add_rules({
        Rule(
          "%s*/%*%*$",
          "*/",
          { "typescript", "typescriptreact", "javascript", "javascriptreact", "c", "cpp", "csharp", "java" }
        ):use_regex(true),
      })
    end,
  },

  -- surround
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },

  -- comments
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        context_commentstring = { enable = true, enable_autocmd = false, disable = "default" },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", desc = "+comment line", mode = { "n", "x" } },
      { "gb", desc = "+comment block", mode = { "n", "x" } },
    },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          opts = {
            textobjects = {
              move = {
                enable = true,
                disable = "default",
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                  ["]m"] = "@function.outer",
                  ["]]"] = "@class.outer",
                },
                goto_next_end = {
                  ["]M"] = "@function.outer",
                  ["]["] = "@class.outer",
                },
                goto_previous_start = {
                  ["[m"] = "@function.outer",
                  ["[["] = "@class.outer",
                },
                goto_previous_end = {
                  ["[M"] = "@function.outer",
                  ["[]"] = "@class.outer",
                },
              },
            },
          },
        },
        -- init = function()
        --   -- no need to load the plugin, since we only need its queries
        --   require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        -- end,
      },
    },
    opts = function()
      local ai = require("mini.ai")
      ---@param func function
      local function wrap_mark(func)
        return function(...)
          vim.cmd("normal! m'")
          return func(...)
        end
      end
      return {
        n_lines = 500,
        custom_textobjects = {
          o = wrap_mark(ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {})),
          f = wrap_mark(ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {})),
          c = wrap_mark(ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {})),
          -- Whole buffer
          e = wrap_mark(function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },
  -- bracket
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
    opts = {
      buffer = { suffix = "" },
      treesitter = { suffix = "n" },
    },
    config = function(_, opts)
      require("mini.bracketed").setup(opts)
    end,
  },

  -- emmet
  {
    "mattn/emmet-vim",
    event = "VeryLazy",
    init = function()
      -- vim.g.user_emmet_mode = "nv"
      -- vim.g.user_emmet_leader_key = "<C-y>"
    end,
  },
}
