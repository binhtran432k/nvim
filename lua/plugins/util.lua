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
      before_save = function ()
        -- HACK: make sure persisted follow cwd
        vim.g.persisting_session = nil
      end,
      should_autosave = function()
        -- do not autosave if the alpha dashboard is the current filetype
        if vim.tbl_contains({ "alpha", "dashboard", "gitcommit", "" }, vim.bo.filetype) then
          return false
        end
        return true
      end,
      telescope = {
        after_source = function(session)
          vim.notify("Loaded session " .. session.name)
        end,
      },
    },
    config = function(_, opts)
      local group = vim.api.nvim_create_augroup("PersistedHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "PersistedTelescopeLoadPre",
        group = group,
        callback = function(_)
          -- Close all open buffers
          -- Thanks to https://github.com/avently
          vim.api.nvim_input("<ESC>:%bd<CR>")
        end,
      })

      require("persisted").setup(opts)
      require("telescope").load_extension("persisted") -- To load the telescope extension
    end,
  },

  -- library used by other plugins
  "nvim-lua/plenary.nvim",

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
