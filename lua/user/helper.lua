-- OS detect
local is_windows = vim.loop.os_uname().version:match 'Windows' and true or false
local is_unix = not is_windows
local is_wsl = vim.loop.os_uname().release:lower():match 'microsoft' and true or false
local is_mac = vim.loop.os_uname().sysname:match 'Darwin' and true or false
local is_linux = is_unix and not (is_wsl or is_mac)

-- autocmd helpers
local function do_clean()
  vim.cmd("doautocmd User Clean")
end
local function on_clean(callback)
  vim.api.nvim_create_autocmd("User", {
    pattern = "Clean",
    callback = callback,
  })
end

local function on_lsp_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

return {
  is_windows = is_windows,
  is_unix = is_unix,
  is_wsl = is_wsl,
  is_mac = is_mac,
  is_linux = is_linux,

  do_clean = do_clean,
  on_clean = on_clean,
  on_lsp_attach = on_lsp_attach,
}
