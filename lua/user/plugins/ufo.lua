local function open_all_folds(...)
  return require("ufo").openAllFolds(...)
end

local function close_all_folds(...)
  return require("ufo").closeAllFolds(...)
end

local function open_folds_except_kinds(...)
  return require("ufo").openFoldsExceptKinds(...)
end

local function close_folds_with(...)
  return require("ufo").closeFoldsWith(...)
end

local function fold_preview_or_hover()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end

local function fold_handler(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = (" |-> %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- text width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

local function provider_selector(_, filetype, _)
  local ft_map = {
    vim = "indent",
    python = "indent",
    git = "",
    _ = { "treesitter", "indent" },
  }
  return ft_map[filetype] or ft_map["_"]
end

return {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  event = "BufReadPost",
  keys = {
    { "zR", open_all_folds },
    { "zM", close_all_folds },
    { "zr", open_folds_except_kinds },
    { "zm", close_folds_with },
    { "K", fold_preview_or_hover, desc = "Preview fold or hover" },
  },
  opts = {
    open_fold_hl_timeout = 0,
    close_fold_kinds = { "imports", "comment" },
    preview = {
      win_config = {
        border = { "", "─", "", "", "", "─", "", "" },
        winhighlight = "Normal:NormalFloat",
        winblend = 0,
      },
      mappings = {
        scrollU = "<C-u>",
        scrollD = "<C-d>",
      },
    },
    provider_selector = provider_selector,
    fold_virt_text_handler = fold_handler,
  },
}
