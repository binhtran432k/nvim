
return {
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
