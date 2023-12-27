local function install_lazy(lazypath)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    -- "--branch=stable",
    lazypath,
  })
  vim.cmd("quit")
end

local function setup_lazy(lazypath)
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
  require("lazy").setup({
    spec = { { import = "user.plugins" }, { import = "user.plugins.lsp" } },
    defaults = { lazy = true },
    install = { colorscheme = { "dracula", "habamax" } },
    checker = { enabled = true, frequency = 43200 },
    change_detection = { enabled = false },
    performance = {
      rtp = {
        disabled_plugins = {
          "2html_plugin",
          "getscriptPlugin",
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "vimballPlugin",
          "zipPlugin",
        },
      },
    },
  })
end

local function setup()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.api.nvim_create_user_command("InstallLazy", function()
      install_lazy(lazypath)
    end, {})
  else
    setup_lazy(lazypath)
  end
end

return {
  setup = setup,
}
