local prettier = "prettierd"

local function biome_lsp_or_prettier(bufnr)
  local has_biome_lsp = vim.lsp.get_clients({
    bufnr = bufnr,
    name = "biome",
  })[1]
  if has_biome_lsp then
    return { "biome" }
  end
  local has_prettier = vim.fs.find({
    -- https://prettier.io/docs/en/configuration.html
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
  }, { upward = true })[1]
  if has_prettier then
    return { prettier }
  end
  return { "biome" }
end

return {
  {
    "stevearc/conform.nvim",
    ---@class ConformOpts
    opts = {
      default_format_opts = {
        timeout_ms = 10000,
      },
      formatters_by_ft = {
        javascript = biome_lsp_or_prettier,
        typescript = biome_lsp_or_prettier,
        javascriptreact = biome_lsp_or_prettier,
        typescriptreact = biome_lsp_or_prettier,
        json = biome_lsp_or_prettier,
        jsonc = biome_lsp_or_prettier,
        svelte = biome_lsp_or_prettier,
        astro = biome_lsp_or_prettier,
        vue = biome_lsp_or_prettier,
        css = { prettier },
        html = { prettier },
        yaml = { prettier },
        markdown = { prettier },
        graphql = { prettier },
        python = { "ruff_format" },
      },
    },
  },
}
