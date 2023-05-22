local helper = require("helper")

return {
  {
    "nvim-treesitter/playground",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        playground = { enable = true, disable = "default" },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
          disable = "default",
        },
      },
    },
    cmd = "TSPlaygroundToggle",
    keys = {
      { "<leader>tp", "<cmd>TSPlaygroundToggle<cr>", desc = "Toggle Tree-sitter Playground" },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        autotag = { enable = true, disable = "default" },
      },
    },
    config = function()
      helper.on_clean(function()
        helper.refreshTSPlugin("autotag")
      end)
    end,
  },

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
      { "<leader>aw", "<cmd>ISwapNodeWith<cr>", desc = "ISwap node with" },
      { "<leader>aa", "<cmd>ISwapNode<cr>", desc = "ISwap node" },
      { "<leader>an", "<cmd>ISwapNodeWithRight<cr>", desc = "ISwap node with right" },
      { "<leader>ap", "<cmd>ISwapNodeWithLeft<cr>", desc = "ISwap node with left" },
    },
    config = true,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "HiPhish/nvim-ts-rainbow2" },
      {
        "pfeiferj/nvim-hurl",
        ft = { "hurl" },
        config = true,
      },
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      sync_install = false,
      ensure_installed = {
        bibtex = true,
        bash = true,
        c = true,
        c_sharp = true,
        cpp = true,
        css = true,
        diff = true,
        dockerfile = true,
        fennel = true,
        help = true,
        html = true,
        hurl = true,
        java = true,
        javascript = true,
        jsdoc = true,
        json = true,
        jsonc = true,
        latex = true,
        lua = true,
        make = true,
        markdown = true,
        markdown_inline = true,
        mermaid = true,
        python = true,
        query = true,
        regex = true,
        scss = true,
        teal = true,
        toml = true,
        tsx = true,
        typescript = true,
        vue = true,
        vim = true,
        yaml = true,
      },
      highlight = { enable = true, disable = "default" },
      indent = { enable = false, disable = "default" },
      rainbow = { enable = true, disable = "default" },
      incremental_selection = {
        enable = true,
        disable = "default",
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      local function is_disable(_, bufnr)
        return bufnr and vim.api.nvim_buf_line_count(bufnr) > 5000
      end

      local function pass_disable(o)
        for key, value in pairs(o) do
          if type(value) == "table" then
            if value.disable then
              if value.disable == "default" then
                o[key].disable = is_disable
              end
            else
              pass_disable(o[key])
            end
          end
        end
      end

      pass_disable(opts)

      opts.ensure_installed = vim.tbl_keys(opts.ensure_installed)

      vim.treesitter.language.register("html", "xml")
      require("nvim-treesitter.configs").setup(opts)

      helper.on_clean(function()
        helper.refreshTSPlugin("rainbow")
      end)
    end,
  },
}
