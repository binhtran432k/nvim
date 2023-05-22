local helper = require("helper")

return {
  -- file explorer
  {
    "kyazdani42/nvim-tree.lua",
    dependencies = {
      {
        "antosha417/nvim-lsp-file-operations",
        config = function()
          require("lsp-file-operations").setup()
        end,
      },
    },
    keys = {
      { "<leader>fo", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Tree" },
      { "<leader>fO", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Toggle Tree Focus" },
      { "<c-n>", "<leader>fo", desc = "Toggle Tree", remap = true },
    },
    opts = {
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      ignore_ft_on_setup = { "alpha", "dashboard", "startify" },
      renderer = {
        group_empty = true,
        indent_markers = {
          enable = true,
        },
      },
    },
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- search/replace in treesitter
  {
    "cshuaimin/ssr.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>sR", function() require("ssr").open() end, desc = "Structural Replace", mode = { "n", "x" } },
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = { "nvim-telescope/telescope-symbols.nvim" },
    keys = {
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sC", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sl", "<cmd>Telescope symbols<cr>", desc = "Symbols" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Find in Files (Grep)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>st", "<cmd>Telescope builtin include_extensions=true<cr>", desc = "Telescope" },
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>/", "<leader>sg", desc = "Find in Files (Grep)", remap = true },
      { "<leader>:", "<leader>sc", desc = "Commands", remap = true },
      { "<c-p>", "<leader>ff", desc = "Find Files", remap = true },
    },
    opts = {
      pickers = {
        find_files = {
          hidden = true,
        },
      },
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<C-i>"] = { "<cmd>Telescope find_files no_ignore=true<cr>", type = "command" },
            ["<C-h>"] = { "<cmd>Telescope find_files hidden=true<cr>", type = "command" },
            ["<C-Down>"] = function(...)
              return require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-Up>"] = function(...)
              return require("telescope.actions").cycle_history_prev(...)
            end,
          },
        },
      },
    },
  },

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "phaazon/hop.nvim",
    keys = {
      { "s", "<cmd>HopChar1<cr>", desc = "Hop Char 1" },
      { "S", "<cmd>HopWord<cr>", desc = "Hop Word" },
      { "x", "<cmd>HopChar1<cr>", desc = "Hop Char 1", mode = { "x", "o" } },
      { "X", "<cmd>HopWord<cr>", desc = "Hop Word", mode = { "x", "o" } },
      {
        "f",
        function()
          require("hop").hint_char1({
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
          })
        end,
        mode = { "n", "x", "o" },
      },
      {
        "F",
        function()
          require("hop").hint_char1({
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
          })
        end,
        mode = { "n", "x", "o" },
      },
      {
        "t",
        function()
          require("hop").hint_char1({
            direction = require("hop.hint").HintDirection.AFTER_CURSOR,
            current_line_only = true,
            hint_offset = -1,
          })
        end,
        mode = { "n", "x", "o" },
      },
      {
        "T",
        function()
          require("hop").hint_char1({
            direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
            current_line_only = true,
            hint_offset = -1,
          })
        end,
        mode = { "n", "x", "o" },
      },
    },
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
  },

  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
      window = { border = "rounded" },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>sn"] = { name = "+noice" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
      wk.register({
        mode = { "n", "v", "i" },
        ["<C-y>"] = { name = "+emmet" },
      })
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          illuminate = { disable = "default" },
        },
      },
    },
    event = "BufReadPost",
    -- -- stylua: ignore
    -- keys = {
    --   { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
    --   { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
    -- },
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo Trouble" },
      { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
    },
    config = true,
  },

  -- match parenthesis and tag
  {
    "andymass/vim-matchup",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = {
        matchup = { enable = true, disable = "default" },
      },
    },
    init = function()
      vim.g.matchup_delim_noskips = 1
      vim.g.matchup_enabled = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_show_delay = 100
      vim.g.matchup_matchparen_offscreen = { method = nil }
      vim.g.matchup_matchparen_stopline = 100
      vim.g.matchup_matchparen_timeout = 100
      vim.g.matchup_matchpref = { html = { nolists = 1 } }
      vim.g.matchup_motion_enabled = 1
      vim.g.matchup_text_obj_enabled = 1
    end,
    config = function()
      helper.on_clean(function()
        helper.refreshTSPlugin("matchup")
      end)
    end,
  },

  -- toggle terminal
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<c-w>", "<c-\\><c-n>", desc = "Normal in Terminal", mode = "t" },
      { "<a-1>", "<cmd>1ToggleTerm<cr>", desc = "Toggle Term 1", mode = { "n", "t" } },
      { "<a-2>", "<cmd>2ToggleTerm<cr>", desc = "Toggle Term 2", mode = { "n", "t" } },
      { "<a-3>", "<cmd>3ToggleTerm<cr>", desc = "Toggle Term 3", mode = { "n", "t" } },
      {
        "<a-i>",
        function()
          require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", direction = "float", id = 1000 }):toggle()
        end,
        desc = "Toggle lazygit",
        mode = { "n", "t" },
      },
      {
        "<a-o>",
        function()
          require("toggleterm.terminal").Terminal:new({ cmd = "ranger", direction = "float", id = 1001 }):toggle()
        end,
        desc = "Toggle ranger",
        mode = { "n", "t" },
      },
    },
    opts = {
      direction = "horizontal",
      size = 15,
      open_mapping = "<c-\\>",
      shade_terminals = false,
    },
  },

  -- automatic detect indent
  {
    "Darazaki/indent-o-matic",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Number of lines without indentation before giving up (use -1 for infinite)
      max_lines = 2048,
      -- Space indentations that should be detected
      standard_widths = { 2, 4, 8 },
      -- Skip multi-line comments and strings (more accurate detection but less performant)
      skip_multiline = true,
    },
    config = function(_, opts)
      require("indent-o-matic").setup(opts)
      vim.cmd("autocmd! indent_o_matic")
      local function smart_indent()
        if not vim.b["editorconfig"] or not vim.b["editorconfig"].indent_size then
          -- vim.notify("Indent O Matic")
          vim.cmd.IndentOMatic()
        end
      end
      local smart_indent_augroup = vim.api.nvim_create_augroup("smart_indent", {})
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = smart_indent,
        group = smart_indent_augroup,
      })
      helper.on_clean(smart_indent)
    end,
  },
}
