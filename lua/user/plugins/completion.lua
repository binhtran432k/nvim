local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function get_next_complete_or_jump_mapping(cmp, luasnip)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
      -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
      -- they way you will only jump inside the snippet region
    elseif luasnip.expand_or_locally_jumpable() then
      luasnip.expand_or_jump()
    elseif has_words_before() then
      cmp.complete()
    else
      fallback()
    end
  end, { "i", "s" })
end

local function get_prev_complete_or_jump_mapping(cmp, luasnip)
  return cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" })
end

local function get_toggle_mapping(cmp, _)
  return cmp.mapping(function(_)
    if cmp.visible() then
      cmp.close()
    else
      cmp.complete()
    end
  end, { "i", "c" })
end

local function get_default_sources(cmp, _)
  return cmp.config.sources({
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
  }, {
    {
      name = "spell",
      max_item_count = 10,
      keyword_length = 3,
      option = { keep_all_entries = true },
    },
    { name = "path" },
  })
end

local function get_format(_, _)
  local menu = {
    luasnip = "Snip",
    nvim_lsp = "Lsp",
    buffer = "Buf",
    path = "Path",
    cmdline = "Cmd",
    spell = "Spl",
  }
  return function(entry, item)
    local source_name = menu[entry.source.name]
    if source_name then
      item.menu = "[" .. source_name .. "]"
    end
    local label = item.abbr
    local truncated_label = vim.fn.strcharpart(label, 0, 50)
    if truncated_label ~= label then
      item.abbr = truncated_label .. "..."
    end
    return item
  end
end

local function get_comparators(cmp, _)
  return {
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
  }
end

local function get_normal_option(cmp, luasnip)
  return {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    performance = {
      debounce = 300,
      throttle = 60,
      fetching_timeout = 200,
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<Tab>"] = get_next_complete_or_jump_mapping(cmp, luasnip),
      ["<S-Tab>"] = get_prev_complete_or_jump_mapping(cmp, luasnip),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-space>"] = get_toggle_mapping(cmp, luasnip),
      ["<C-y>"] = cmp.mapping.confirm(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = get_default_sources(cmp, luasnip),
    formatting = { format = get_format(cmp, luasnip) },
    sorting = { comparators = get_comparators(cmp, luasnip) },
    experimental = { ghost_text = { hl_group = "LspCodeLens" } },
  }
end

local function get_cmdline_option(cmp, _)
  return {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "cmdline" }, { name = "buffer", group_index = 2 } },
  }
end

local function get_search_option(cmp, _)
  return {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = "buffer" } },
  }
end

return {
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "f3fora/cmp-spell",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-under-comparator",
      {
        "neovim/nvim-lspconfig",
        opts = {
          get_completion = function()
            return require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
          end,
        },
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup(get_normal_option(cmp, luasnip))
      cmp.setup.cmdline(":", get_cmdline_option(cmp, luasnip))
      cmp.setup.cmdline("/", get_search_option(cmp, luasnip))
      cmp.setup.cmdline("?", get_search_option(cmp, luasnip))
    end,
  },
}
