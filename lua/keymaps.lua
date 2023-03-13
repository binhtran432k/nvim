local helper = require("helper")

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set({ "n", "t" }, "<a-k>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set({ "n", "t" }, "<a-j>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set({ "n", "t" }, "<a-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set({ "n", "t" }, "<a-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- buffers
if not helper.has("nvim-bufferline.lua") then
  vim.keymap.set({ "i", "n" }, "<c-,>", "<esc><cmd>bprevious<cr>", { desc = "Previous Buffer" })
  vim.keymap.set({ "i", "n" }, "<c-.>", "<esc><cmd>bnext<cr>", { desc = "Next Buffer" })
end
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
vim.keymap.set("n", "<leader>r", function()
  vim.cmd("nohlsearch|diffupdate")
  vim.cmd("silent! IndentBlanklineRefresh")
  vim.cmd("silent! TSDisable rainbow|TSEnable rainbow|TSDisable matchup|TSEnable matchup")
  vim.cmd("normal! <c-l>")
end, { desc = "Redraw and clear hlsearch" })

-- highlight word
vim.keymap.set("n", "gw", "*N")
vim.keymap.set("x", "gw", "*N")

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- save file
vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
-- vim.keymap.set("v", "<", "<gv")
-- vim.keymap.set("v", ">", ">gv")

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- open location/quickfix
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open Quickfix List" })

-- toggle options
vim.keymap.set("n", "<leader>ts", helper.toggle("spell"), { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>tw", helper.toggle("wrap"), { desc = "Toggle Word Wrap" })
vim.keymap.set("n", "<leader>tn", function()
  helper.toggle("number")()
  if vim.opt_local.number:get() then
    vim.opt_local.relativenumber = vim.b.relativenumber
  else
    vim.b.relativenumber = vim.opt_local.relativenumber:get()
    vim.opt_local.relativenumber = false
  end
end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>td", helper.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set(
  "n",
  "<leader>tc",
  helper.toggle("conceallevel", false, { 0, conceallevel }),
  { desc = "Toggle Conceal" }
)

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.keymap.set("n", "<leader>i", vim.show_pos, { desc = "Highlight Groups at cursor" })
end

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "other-window" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "delete-window" })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "split-window-below" })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "split-window-right" })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous" })

-- clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste clipboard" })
