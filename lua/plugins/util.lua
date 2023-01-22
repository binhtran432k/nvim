local ignore_list = { "alpha", "dashboard", "" }

return {
  -- measure startuptime
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "olimorris/persisted.nvim",
    cmd = "SessionLoad",
    keys = {
      { "<leader>qs", "<cmd>SessionLoad<cr>", desc = "Load current directory session" },
      { "<leader>ql", "<cmd>SessionLoadLast<cr>", desc = "Load last session" },
      { "<leader>qp", "<cmd>Telescope persisted<cr>", desc = "Telescope session" },
      { "<leader>qd", "<cmd>SessionDelete<cr>", desc = "Delete current session" },
    },
    opts = {
      on_autoload_no_session = function()
        vim.cmd("Telescope find_files")
      end,
      should_autosave = function()
        -- do not autosave if the alpha dashboard is the current filetype
        if vim.tbl_contains(ignore_list, vim.bo.filetype) then
          return false
        end
        return true
      end,
      telescope = {
        before_source = function()
          -- Close all open buffers
          -- Thanks to https://github.com/avently
          vim.api.nvim_input("<ESC>:%bd<CR>")
        end,
        after_source = function(session)
          vim.notify("Loaded session " .. session.name)
        end,
      },
    },
    config = function(_, opts)
      require("persisted").setup(opts)
      require("telescope").load_extension("persisted") -- To load the telescope extension
    end,
  },

  -- library used by other plugins
  "nvim-lua/plenary.nvim",

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
