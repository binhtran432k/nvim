--- @param trunc_width number? trunctates component when screen width is less then trunc_width
--- @param trunc_len number? truncates component to trunc_len number of chars
--- @param hide_width number? hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean? whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local function get_mode()
  return { 'mode', fmt = trunc(80, 4, 60, true) }
end

local function get_filename()
  return { 'filename' }
end

local function get_diagnostics()
  return {
    "diagnostics",
    symbols = { error = "E", warn = "W", info = "I", hint = "H" },
    fmt = trunc(nil, nil, 60)
  }
end

local function get_branch()
  return { 'b:gitsigns_head', icon = '' }
end

local function get_diff()
  return { 'diff', source = diff_source, fmt = trunc(nil, nil, 60) }
end

local function get_encoding()
  return { 'encoding', fmt = trunc(nil, nil, 80) }
end

local function get_fileformat()
  return {
    'fileformat',
    icons_enabled = true,
    symbols = { unix = 'LF', dos = 'CRLF', mac = 'CR' },
    fmt = trunc(nil, nil, 80),
  }
end

local function get_progress_location()
  return function()
    return "%P ☰ %3l/%L:%3c"
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = { "VeryLazy" },
  config = {
    options = {
      icons_enabled = true,
      component_separators = { left = '|', right = '|' },
      section_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = false,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { get_mode() },
      lualine_b = { get_branch(), get_diff(), get_diagnostics() },
      lualine_c = { get_filename() },
      lualine_x = { get_encoding(), get_fileformat(), 'filetype' },
      lualine_y = { "progress" },
      lualine_z = { "location" }
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "nvim-tree", "lazy", "man", "quickfix" }
  },
}
