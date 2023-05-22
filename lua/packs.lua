local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    -- "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- If opening from inside neovim terminal then do not load all the other plugins
if os.getenv("NVIM") ~= nil then
  require("lazy").setup({
    { "willothy/flatten.nvim", config = true },
  })
  return
end

-- Otherwise proceed as normal
require("lazy").setup({
  spec = "plugins",
  ui = {
    border = "rounded",
  },
  defaults = { lazy = true },
  install = { colorscheme = { "dracula", "habamax" } },
  checker = { enabled = true },
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
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>")
