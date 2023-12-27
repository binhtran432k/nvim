return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = true,
    on_attach = function(buffer)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
      end

      -- stylua: ignore start
      map("n", "]h", gs.next_hunk, "Next Hunk")
      map("n", "[h", gs.prev_hunk, "Prev Hunk")
      map("n", "gh", gs.preview_hunk, "Prev Hunk}")
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
    end,
  },
  config = function(_, opts)
    vim.api.nvim_create_autocmd({ "MenuPopup" }, {
      callback = function(event)
        print(vim.inspect(event))
        -- if vim.w.gitsigns_preview then
        --   vim.bo[event.buf].ft = "gitsigns_preview"
        -- end
      end,
    })
    vim.api.nvim_create_autocmd({ "OptionSet" }, {
      pattern = { "eventignore" },
      callback = function(event)
        if vim.w.gitsigns_preview then
          vim.bo[event.buf].ft = "gitsigns_preview"
        end
      end,
    })
    require("gitsigns").setup(opts)
  end,
}
