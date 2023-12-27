local helper = require("user.helper")

local function refresh_ts_plug(ts_plug)
  vim.cmd(string.format("TSDisable %s|TSEnable %s", ts_plug, ts_plug))
end

local function get_languages()
  return {
    bibtex = true,
    bash = true,
    c = true,
    c_sharp = true,
    cpp = true,
    css = true,
    diff = true,
    dockerfile = true,
    fennel = true,
    haskell = true,
    html = true,
    hurl = true,
    ini = true,
    java = true,
    javascript = true,
    jsdoc = true,
    json = true,
    jsonc = true,
    latex = true,
    kotlin = true,
    lua = true,
    make = true,
    markdown = true,
    markdown_inline = true,
    mermaid = true,
    nix = true,
    python = true,
    query = true,
    regex = true,
    rust = true,
    scss = true,
    teal = true,
    toml = true,
    tsx = true,
    typescript = true,
    ungrammar = true,
    vue = true,
    vim = true,
    vimdoc = true,
    yaml = true,
  }
end

return {
  {
    "nvim-treesitter/playground",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        playground = { enable = true },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      },
    },
    cmd = "TSPlaygroundToggle",
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        autotag = { enable = true },
      },
    },
    config = function()
      helper.on_clean(function()
        refresh_ts_plug("autotag")
      end)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = false,
    event = { "BufReadPre", "BufNewFile" },
    config = true,
  },

  {
    "mizlan/iswap.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = {
      "ISwapNodeWith",
      "ISwapNode",
      "ISwapNodeWithRight",
      "ISwapNodeWithLeft",
    },
    config = true,
  },

  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    cmd = { "Neogen" },
    opts = { snippet_engine = "luasnip" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      sync_install = false,
      highlight = { enable = true },
      languages = get_languages(),
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      opts.ensure_installed = vim.tbl_keys(opts.languages)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
