local helper = require("helper")

vim.filetype.add {
  extension = { conf = "config" },
  filename = { ["binding.gyp"] = "jsonc" },
  pattern = { [".*/test/corpus/.*%.txt"] = "query" },
}

-- Extend keyword for css, fennel, ...
helper.setup_filetype({ "css", "scss", "fennel" }, function()
  vim.opt_local.iskeyword:append("-")
end)

helper.setup_filetype_column({
  lua = 120,
})
