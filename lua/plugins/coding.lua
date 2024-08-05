local cmp_keys = {
  next = "<c-j>",
  prev = "<c-k>",
}

return {
  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = {"InsertEnter", "CmdlineEnter"},
    dependencies = { "hrsh7th/cmp-cmdline", "hrsh7th/cmp-calc", "windwp/nvim-autopairs" },
    opts = function(_, opts)
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      opts.performance = vim.tbl_extend("force", opts.performance or {}, {
        debounce = 300,
        throttle = 60,
        fetching_timeout = 200,
      })

      table.insert(opts.sources, { name = "calc" })

      local cmp_window_opts = {
        winhighlight = "CursorLine:Visual,Search:None",
      }

      local function toggle_cmp()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end

      opts.window = {
        completion = cmp.config.window.bordered(cmp_window_opts),
        documentation = cmp.config.window.bordered(cmp_window_opts),
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        [cmp_keys.next] = cmp.mapping.select_next_item(),
        [cmp_keys.prev] = cmp.mapping.select_prev_item(),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = toggle_cmp,
      })

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      local mapping = vim.tbl_extend("force", cmp.mapping.preset.cmdline(), {
        [cmp_keys.next] = { c = cmp.mapping.select_next_item() },
        [cmp_keys.prev] = { c = cmp.mapping.select_prev_item() },

        ["<C-Space>"] = { c = toggle_cmp },
      })

      cmp.setup.cmdline(":", {
        mapping = mapping,
        sources = {
          { name = "cmdline", group_index = 1 },
          { name = "buffer", group_index = 2 },
        },
      })
      for _, cmd_type in ipairs({ "/", "?" }) do
        cmp.setup.cmdline(cmd_type, {
          mapping = mapping,
          sources = {
            { name = "buffer", group_index = 1 },
          },
        })
      end
    end,
  },
  -- auto pair
  { "echasnovski/mini.pairs", enabled = false },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        autopairs = { enable = true },
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
    end,
  },
  -- auto tag
  {
    "windwp/nvim-ts-autotag",
    opts = {
      enable_close_on_slash = false,
    },
  },
  -- generate documentation
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = "Neogen",
    opts = {
      -- input_after_comment = false,
      enable_placeholders = false,
      snippet_engine = nil, -- "luasnip"
    },
  },
  -- better match paren
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        matchup = { enable = true },
      },
    },
    config = function()
      vim.g.matchup_delim_noskips = 1
      vim.g.matchup_enabled = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 200
      vim.g.matchup_matchparen_offscreen = { method = nil }
      vim.g.matchup_matchparen_stopline = 100
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchpref = { html = { nolists = 1 } }
      vim.g.matchup_motion_enabled = 1
      vim.g.matchup_text_obj_enabled = 1
    end,
  },
  -- swap item
  {
    "mizlan/iswap.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = {
      "ISwap",
      "ISwapWith",
      "ISwapNodeWith",
      "ISwapNode",
      "ISwapNodeWithRight",
      "ISwapNodeWithLeft",
    },
    keys = {
      { "<leader>ci", "<cmd>ISwapWith<cr>", desc = "ISwap" },
      { "<leader>cn", "<cmd>ISwapNodeWith<cr>", desc = "ISwap Node" },
    },
    config = true,
  },
  -- easier split/join code
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>cj", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
  },
  -- auto detect indent
  {
    "nmac427/guess-indent.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      auto_cmd = true, -- Set to false to disable automatic execution
      override_editorconfig = false, -- Set to true to override settings set by .editorconfig
      filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
        "netrw",
        "tutor",
      },
      buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
    },
  },
}
