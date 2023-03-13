local helper = require("helper")

vim.filetype.add({
  extension = { conf = "config" },
  filename = { ["binding.gyp"] = "jsonc" },
  pattern = { [".*/test/corpus/.*%.txt"] = "query" },
})

-- Extend keyword for css, fennel, ...
helper.setup_filetype({ "css", "scss", "fennel" }, function()
  vim.opt_local.iskeyword:append("-")
end)

helper.setup_filetype({ "markdown", "latex" }, function()
  vim.opt_local.spell = true
end)

-- Close some filetypes with <q>
helper.setup_filetype({
  "qf",
  "help",
  "man",
  "notify",
  "lspinfo",
  "spectre_panel",
  "startuptime",
  "tsplayground",
  "PlenaryTestPopup",
}, function(event)
  vim.bo[event.buf].buflisted = false
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
end)

helper.setup_filetype_column({
  lua = 120,
  java = 100,
})
