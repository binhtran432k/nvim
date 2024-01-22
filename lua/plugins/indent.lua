local function set_indent(opts)
  local indent = opts.args ~= "" and tonumber(opts.args) or 4
  vim.bo.shiftwidth = indent
  vim.bo.softtabstop = indent
  vim.bo.tabstop = indent
end

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

return {
  {
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
  },
  {
    "echasnovski/mini.indentscope",
    opts = function(_, opts)
      opts.draw = vim.tbl_deep_extend("force", opts.draw or {}, {
        delay = 300,
        animation = require("mini.indentscope").gen_animation.none(),
      })
    end,
  },
}
