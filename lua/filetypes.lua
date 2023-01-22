vim.filetype.add {
  extension = { conf = "config" },
  filename = { ["binding.gyp"] = "jsonc" },
  pattern = { [".*/test/corpus/.*%.txt"] = "query" },
}
