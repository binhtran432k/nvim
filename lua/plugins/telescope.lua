local cmp_keys = {
  next = "<tab>",
  prev = "<s-tab>",
}

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-symbols.nvim" },
    { "benfowler/telescope-luasnip.nvim" },
  },
  opts = function(_, opts)
    require('telescope').load_extension('luasnip')

    local actions = require("telescope.actions")
    opts.defaults.mappings = vim.tbl_extend("force", opts.defaults.mappings, {
      n = {
        [cmp_keys.next] = actions.move_selection_next,
        [cmp_keys.prev] = actions.move_selection_previous,
      },
      i = {
        [cmp_keys.next] = actions.move_selection_next,
        [cmp_keys.prev] = actions.move_selection_previous,
      },
    })
  end,
}
