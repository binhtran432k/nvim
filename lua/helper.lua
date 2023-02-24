local M = {}

M.root_patterns = { ".git", "/lua" }

function M.is_directory()
  return vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1
end

function M.is_directory_or_nil()
  local buf_path = vim.api.nvim_buf_get_name(0)
  return buf_path == "" or vim.fn.isdirectory(buf_path) == 1
end

---@param on_attach fun(client, buffer)
function M.on_lsp_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

---get fg from vim
---@param name string
---@return function
function M.get_fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

---@param option string
---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  return function()
    if values then
      if vim.opt_local[option]:get() == values[1] then
        vim.opt_local[option] = values[2]
      else
        vim.opt_local[option] = values[1]
      end
      vim.notify("Set " .. option .. " to " .. vim.opt_local[option]:get(), vim.log.levels.INFO, { title = "Option" })
    else
      vim.opt_local[option] = not vim.opt_local[option]:get()
      if not silent then
        vim.notify(
          (vim.opt_local[option]:get() and "Enabled" or "Disabled") .. " " .. option,
          vim.log.levels.INFO,
          { title = "Option" }
        )
      end
    end
  end
end

local diagnostics_enabled = true
function M.toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  local msg
  if diagnostics_enabled then
    vim.diagnostic.enable()
    msg = "Enabled diagnostics"
  else
    vim.diagnostic.disable()
    msg = "Disabled diagnostics"
  end
  vim.notify(msg, vim.log.levels.INFO, { title = "Diagnostics" })
end


function M.setup_filetype_column(opts)
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(event)
      local length = opts[vim.bo[event.buf].filetype]
      if not length then
        length = 80
      end
      vim.wo.colorcolumn = tostring(length)
      vim.bo[event.buf].textwidth = length - 1
    end,
  })
end
return M
