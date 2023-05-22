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
      before_save = function()
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

  {
    "willothy/flatten.nvim",
    opts = {
      window = {
        open = "alternate",
      },
      callbacks = {
        should_block = function(argv)
          -- Note that argv contains all the parts of the CLI command, including
          -- Neovim's path, commands, options and files.
          -- See: :help v:argv

          -- In this case, we would block if we find the `-b` flag
          -- This allows you to use `nvim -b file1` instead of `nvim --cmd 'let g:flatten_wait=1' file1`
          return vim.tbl_contains(argv, "-b")

          -- Alternatively, we can block if we find the diff-mode option
          -- return vim.tbl_contains(argv, "-d")
        end,
        post_open = function(bufnr, winnr, ft, is_blocking)
          vim.notify(vim.api.nvim_buf_get_name(bufnr))
          if is_blocking then
            -- Hide the terminal while it's blocking
            require("toggleterm").toggle(0)
          else
            -- If it's a normal file, just switch to its window
            vim.api.nvim_set_current_win(winnr)
          end

          -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
          -- If you just want the toggleable terminal integration, ignore this bit
          if ft == "gitcommit" then
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = function()
                -- This is a bit of a hack, but if you run bufdelete immediately
                -- the shell can occasionally freeze
                vim.defer_fn(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end, 50)
              end,
            })
          end
        end,
        block_end = function()
          -- After blocking ends (for a git commit, etc), reopen the terminal
          -- require("toggleterm").toggle(0)
        end,
      },
    },
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },

  -- library used by other plugins
  "nvim-lua/plenary.nvim",

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
