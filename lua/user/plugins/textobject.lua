local function get_ts_textobjects()
  return {
    move = {
      enable = true,
      disable = "default",
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
    },
  }
end

return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    dependencies = {
      {
        { "nvim-treesitter/nvim-treesitter-textobjects" },
        {
          "nvim-treesitter/nvim-treesitter",
          opts = {
            textobjects = get_ts_textobjects(),
          },
        },
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
}
