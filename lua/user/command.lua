local function set_indent(opts)
  local indent = opts.args ~= "" and tonumber(opts.args) or 4
  vim.bo.shiftwidth = indent
  vim.bo.softtabstop = indent
  vim.bo.tabstop = indent
end

local function setup()
  vim.api.nvim_create_user_command("SpellVi", "e $XDG_CONFIG_HOME/nvim/spell/vi.utf-8.add", {})
  vim.api.nvim_create_user_command("SpellEn", "e $XDG_CONFIG_HOME/nvim/spell/en.utf-8.add", {})
  vim.api.nvim_create_user_command("IndentTab", function(opts)
    vim.bo.expandtab = false
    set_indent(opts)
  end, {
    nargs = "?",
  })
  vim.api.nvim_create_user_command("IndentSpace", function(opts)
    vim.bo.expandtab = true
    set_indent(opts)
  end, {
    nargs = "?",
  })
end

return {
  setup = setup,
}
