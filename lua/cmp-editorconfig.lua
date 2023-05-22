local M = {}
local source = {}

function source:is_available()
  return true
end
function source:get_debug_name()
  return "editorconfig"
end
function source:get_keyword_pattern()
  return [[\k\+]]
end
function source:get_trigger_characters()
  return { "." }
end

-- stylua: ignore
local editorconfig_table = {
  { label = "indent_style" }, { label = "tab" }, { label = "space" },
  { label = "indent_size" },
  { label = "tab_width" },
  { label = "max_line_length" },
  { label = "end_of_line" }, { label = "lf" }, { label = "cr" }, { label = "crlf" },
  { label = "charset" }, { label = "latin1" }, { label = "utf-8" }, { label = "utf-8-bom" }, { label = "utf-16be" }, { label = "utf-16le" },
  { label = "trim_trailing_whitespace" }, { label = "true" }, { label = "false" },
  { label = "insert_final_newline" },
  { label = "root" },
}

function source:complete(_, callback)
  callback(editorconfig_table)
end
function source:resolve(completion, callback)
  callback(completion)
end
function source:execute(completion, callback)
  callback(completion)
end

M.setup = function()
  require("cmp").register_source("editorconfig", source)
end

return M
