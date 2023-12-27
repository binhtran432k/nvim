local function run_alpha(opts)
  local buf = vim.api.nvim_get_current_buf()
  local buf_name = vim.api.nvim_buf_get_name(buf)
  local is_dir = vim.fn.isdirectory(buf_name) == 1
  if is_dir then
    vim.api.nvim_set_current_dir(buf_name)
  end
  if buf_name == "" or is_dir then
    vim.bo[buf].buflisted = false
    require("alpha").start(false, opts)
  end
end

return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = function()
    local opts = require("alpha.themes.startify").config
    local local_opts = {
      opts = {
        autostart = false,
      },
    }
    return vim.tbl_extend("force", opts, local_opts)
  end,
  config = function(_, opts)
    require("alpha").setup(opts)
    run_alpha(opts)
  end,
}
