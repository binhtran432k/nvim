local function setup()
  -- Check if we need to reload the file when it changed
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- Spell auto make
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*/spell/*.utf-8.add" },
    callback = function()
      vim.cmd("mkspell! %")
    end,
  })
  -- Spell quit easier
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*/spell/*.utf-8.add" },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>bd<cr>", { buffer = event.buf, silent = true })
    end,
  })

  -- fix directory buffer is view in buf list
  vim.api.nvim_create_autocmd({ "BufAdd" }, {
    callback = function(event)
      if vim.fn.isdirectory(vim.fn.bufname(event.buf)) == 1 then
        vim.bo[event.buf].buflisted = false
      end
    end,
  })

  -- remember folds
  vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
    pattern = { "*.*" },
    desc = "save view (folds), when closing file",
    command = "mkview",
  })
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    pattern = { "*.*" },
    desc = "load view (folds), when opening file",
    command = "silent! loadview",
  })
end

return {
  setup = setup,
}
