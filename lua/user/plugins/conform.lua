local function format()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end

return {
  "stevearc/conform.nvim",
  keys = {
    { "<leader>cf", format, desc = "Format", mode = { "n", "v" } },
  },
  cmd = { "Format" },
  config = function()
    vim.api.nvim_create_user_command("Format", format, {})
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        lua = { "stylua" },
        python = { "isort", "ruff_format" },
      },
      format_on_save = false,
    })
  end,
}
