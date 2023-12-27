local cmp_keys = {
  next = "<tab>",
  prev = "<s-tab>",
}

local function has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function get_supertab_next(cmp, luasnip)
  return function(fallback)
    if cmp.visible() then
      -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
      cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      -- this way you will only jump inside the snippet region
    elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end
end

local function get_supertab_prev(cmp, luasnip)
  return function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end
end

local function get_toggle_cmp(cmp)
  return function()
    if cmp.visible() then
      cmp.close()
    else
      cmp.complete()
    end
  end
end

return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-calc",
      "nat-418/cmp-color-names.nvim",
      "windwp/nvim-autopairs",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "path" },
        { name = "buffer" },
        { name = "emoji" },
        { name = "calc" },
        { name = "color_names" },
      })

      local cmp_window_opts = {
        winhighlight = "CursorLine:Visual,Search:None",
      }

      opts.window = {
        completion = cmp.config.window.bordered(cmp_window_opts),
        documentation = cmp.config.window.bordered(cmp_window_opts),
      }

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        [cmp_keys.next] = cmp.mapping(get_supertab_next(cmp, luasnip), { "i", "s" }),
        [cmp_keys.prev] = cmp.mapping(get_supertab_prev(cmp, luasnip), { "i", "s" }),

        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),

        ["<C-Space>"] = get_toggle_cmp(cmp),
      })

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "hrsh7th/cmp-cmdline",
    config = function()
      local cmp = require("cmp")

      local mapping = vim.tbl_extend("force", cmp.mapping.preset.cmdline(), {
        [cmp_keys.next] = { c = cmp.mapping.select_next_item() },
        [cmp_keys.prev] = { c = cmp.mapping.select_prev_item() },

        ["<C-Space>"] = { c = get_toggle_cmp(cmp) },
      })

      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        mapping = mapping,
        sources = {
          { name = "cmdline", group_index = 1 },
          { name = "buffer", group_index = 2 },
        },
      })
      for _, cmd_type in ipairs({ "/", "?" }) do
        ---@diagnostic disable-next-line: missing-fields
        cmp.setup.cmdline(cmd_type, {
          mapping = mapping,
          sources = {
            { name = "buffer", group_index = 1 },
          },
        })
      end
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    config = function(_, opts)
      if opts then
        require("luasnip").config.setup(opts)
      end

      -- friendly-snippets - enable standardized comments snippets
      require("luasnip").filetype_extend("javascript", { "javascriptreact" })

      require("luasnip.loaders.from_vscode").lazy_load()

      require("luasnip.loaders.from_lua").lazy_load({
        paths = {
          -- Load local snippets if present.
          vim.fn.getcwd() .. "/.luasnippets",
          -- Global snippets.
          vim.fn.stdpath("config") .. "/luasnippets",
        },
      })
    end,
  },
}
