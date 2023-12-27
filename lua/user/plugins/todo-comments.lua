return {
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "CursorMoved" },
  keys = {
    {
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "Next todo comment",
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "Previous todo comment",
    },
  },
  config = true,
}
