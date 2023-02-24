local helper = require("helper")

vim.filetype.add {
  extension = { conf = "config" },
  filename = { ["binding.gyp"] = "jsonc" },
  pattern = { [".*/test/corpus/.*%.txt"] = "query" },
}

helper.setup_filetype_column({
  lua = 120,
})
