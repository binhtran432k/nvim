-- toggle ibus when insert and search mode
vim.g.ibus_default_engine = vim.env.DEFAULT_IBUS_INPUT_METHOD or "xkb:us::eng"
local is_ibus_on = false

---Trigger ibus by global name
---@param im string
local function trigger_ibus(im)
  vim.cmd(string.format("silent! execute '!ibus engine ' . g:%s", im))
end

local function trigger_ibus_on()
  if is_ibus_on then
    is_ibus_on = false
    local current_engine = vim.fn.system("ibus engine")
    if current_engine ~= vim.g.ibus_prev_engine then
      trigger_ibus("ibus_prev_engine")
      vim.g.ibus_prev_engine = current_engine
    end
  end
end

local function trigger_ibus_off()
  if not is_ibus_on then
    is_ibus_on = true
    local current_engine = vim.fn.system("ibus engine")
    if current_engine ~= vim.g.ibus_default_engine then
      trigger_ibus("ibus_default_engine")
    end
    if current_engine ~= vim.g.ibus_prev_engine then
      vim.g.ibus_prev_engine = current_engine
    end
  end
end

local function load_last_position()
  local mark = vim.api.nvim_buf_get_mark(0, '"')
  local lcount = vim.api.nvim_buf_line_count(0)
  if mark[1] > 0 and mark[1] <= lcount then
    pcall(vim.api.nvim_win_set_cursor, 0, mark)
  end
end

local smart_ibus_gid = vim.api.nvim_create_augroup("smart_ibus", {})
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = trigger_ibus_on,
  group = smart_ibus_gid,
})
vim.api.nvim_create_autocmd({ "VimEnter", "InsertLeave", "CmdlineLeave" }, {
  callback = trigger_ibus_off,
  group = smart_ibus_gid,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, { command = "checktime" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = load_last_position,
})

-- fix directory buffer is view in buf list
vim.api.nvim_create_autocmd({ "BufAdd" }, {
  callback = function(event)
    if vim.fn.isdirectory(vim.fn.bufname(event.buf)) == 1 then
      vim.bo[event.buf].buflisted = false
    end
  end,
})

-- HACK: load these function because this file is VeryLazy
trigger_ibus_off()
load_last_position()
