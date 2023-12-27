local helper = require("user.helper")

local function setup()
  -- Clear search, diff update and redraw
  vim.keymap.set("n", "<leader>r", function()
    vim.cmd("nohlsearch|diffupdate")
    helper.do_clean()
    vim.cmd("normal! <c-l>")
  end, { desc = "Redraw and clear hlsearch" })

  -- highlight word
  vim.keymap.set({ "n", "x" }, "gw", "*N")

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

  -- Add undo break-points
  vim.keymap.set("i", ",", ",<c-g>u")
  vim.keymap.set("i", ".", ".<c-g>u")
  vim.keymap.set("i", ";", ";<c-g>u")

  vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank clipboard" })
  vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste clipboard" })

  vim.keymap.set({ "n" }, "<leader><space>", "<cmd>e#<cr>", { desc = "Switch Alternative" })

  vim.keymap.set({ "n" }, "<leader>q", "<cmd>close<cr>", { desc = "Quick Switch" })

  vim.keymap.set({ "n" }, "<leader>w", "<cmd>normal <c-w><c-w><cr>", { desc = "Quick Close" })
end

return {
  setup = setup,
}
