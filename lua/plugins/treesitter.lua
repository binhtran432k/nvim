return {
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    keys = {
      { "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", desc = "Toggle Tree-sitter Playground" },
    },
  },

  { "windwp/nvim-ts-autotag", ft = { "html", "xml", "javascriptreact", "typescriptreact" } },

  {
    "mfussenegger/nvim-treehopper",
    keys = { { "m", mode = { "o", "x" } } },
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },

  -- swap node
  {
    "mizlan/iswap.nvim",
    keys = {
      { "<leader>a", "<cmd>ISwapNodeWith<cr>", desc = "ISwap node with" },
      { "]a", "<cmd>ISwapNodeWithRight<cr>", desc = "ISwap node with right" },
      { "[a", "<cmd>ISwapNodeWithLeft<cr>", desc = "ISwap node with left" },
    },
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "mrjones2014/nvim-ts-rainbow" },
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local function is_disable(_, bufnr)
        return bufnr and vim.api.nvim_buf_line_count(bufnr) > 5000
      end

      return {
        sync_install = false,
        ensure_installed = {
          "bibtex",
          "bash",
          "c",
          "c_sharp",
          "cpp",
          "css",
          "diff",
          "dockerfile",
          "fennel",
          "help",
          "html",
          "java",
          "javascript",
          "json",
          "jsonc",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "scss",
          "teal",
          "toml",
          "tsx",
          "typescript",
          "vue",
          "vim",
          "yaml",
        },
        highlight = { enable = true, disable = is_disable },
        indent = { enable = true, disable = is_disable },
        context_commentstring = { enable = true, enable_autocmd = false, disable = is_disable },
        autopairs = { enable = true, disable = is_disable },
        autotag = { enable = true, disable = is_disable },
        playground = { enable = true, disable = is_disable },
        rainbow = { enable = true, disable = is_disable },
        matchup = { enable = true, disable = is_disable },
        incremental_selection = {
          enable = true,
          disable = is_disable,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<nop>",
            node_decremental = "<bs>",
          },
        },
      }
    end,
    config = function(_, opts)
      local parsers = require("nvim-treesitter.parsers")
      parsers.filetype_to_parsername.xml = "html"
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
