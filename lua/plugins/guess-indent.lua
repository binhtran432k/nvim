local function set_indent(opts)
  local indent = opts.args ~= "" and tonumber(opts.args) or 4
  vim.bo.shiftwidth = indent
  vim.bo.softtabstop = indent
  vim.bo.tabstop = indent
end

return {
  "nmac427/guess-indent.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    auto_cmd = true, -- Set to false to disable automatic execution
    override_editorconfig = false, -- Set to true to override settings set by .editorconfig
    filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
      "netrw",
      "tutor",
    },
    buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
      "help",
      "nofile",
      "terminal",
      "prompt",
    },
  },
  init = function()
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
  end,
}
