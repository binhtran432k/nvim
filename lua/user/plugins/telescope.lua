return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  version = false, -- telescope did only one release, so use HEAD for now
  dependencies = { "nvim-telescope/telescope-symbols.nvim", "benfowler/telescope-luasnip.nvim" },
  keys = {
    { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Find in Files (Grep)" },
    { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
  },
  opts = {
    defaults = {
      mappings = {
        n = {
          q = function(...)
            require("telescope.actions").close(...)
          end,
          ["<Tab>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<S-Tab>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
        },
        i = {
          ["<Tab>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end,
          ["<S-Tab>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end,
        },
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      buffers = {
        mappings = {
          n = {
            x = function(...)
              local actions = require("telescope.actions")
              return (actions.delete_buffer + actions.move_to_top)(...)
            end,
          },
        },
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("luasnip")
  end,
}
