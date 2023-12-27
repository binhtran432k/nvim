local function setup_ft(pattern, callback)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = callback,
  })
end

local function setup_ft_textwidth(opts)
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(event)
      local length
      if vim.b["editorconfig"] and vim.b["editorconfig"].max_line_length then
        length = vim.b["editorconfig"].max_line_length
      else
        length = opts[vim.bo[event.buf].filetype]
      end
      if length then
        vim.wo.colorcolumn = tostring(length)
      end
    end,
  })
end

local function setup_fast_quit(event)
  vim.bo[event.buf].buflisted = false
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
end

local function setup()
  -- Close some filetypes with <q>
  setup_ft({
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  }, setup_fast_quit)

  setup_ft_textwidth({
    lua = 120,
    java = 100,
    rust = 100,
  })

  vim.filetype.add({
    extension = { conf = "config" },
    filename = { ["binding.gyp"] = "jsonc" },
    pattern = { [".*/test/corpus/.*%.txt"] = "treesitter-test" },
  })
end

return {
  setup = setup,
}
