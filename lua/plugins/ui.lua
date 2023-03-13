local settings = require("settings")
local helper = require("helper")

local indent_exclude_fts = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "NvimTree" }

return {
  -- better vim.notify
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>snd",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      background_color = "#000000",
      stages = "static",
      level = 0,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = { input = { insert_only = false, win_options = { winblend = 0 } } },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },

  -- bufferline
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    keys = {
      { "[b", "<esc><cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },
      { "]b", "<esc><cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<c-,>", "<esc><cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer", mode = { "n", "i" } },
      { "<c-.>", "<esc><cmd>BufferLineCycleNext<cr>", desc = "Next Buffer", mode = { "n", "i" } },
      { "<a-,>", "<esc><cmd>BufferLineMovePrev<cr>", desc = "Previous", mode = { "n", "i" } },
      { "<a-.>", "<esc><cmd>BufferLineMoveNext<cr>", desc = "Next", mode = { "n", "i" } },
      { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick" },
      { "<leader>ba", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", desc = "Only" },
    },
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = settings.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        indicator = {
          -- style = "underline",
        },
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local symbols = settings.icons
      local winbar_opt = {
        lualine_b = {
          { "filename", file_status = false },
        },
        lualine_c = {
          {
            function()
              local msg = "No Active Lsp"
              local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
              local clients = vim.lsp.get_active_clients()
              local ignore_sv = { ["null-ls"] = true, emmet_ls = true }
              for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                  if ignore_sv[client.name] then
                    msg = client.name
                  else
                    return client.name
                  end
                end
              end
              return msg
            end,
            icon = " ",
          },
          -- stylua: ignore
          {
            function (...) return require("nvim-navic").get_location(...) end,
            cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
          },
        },
      }
      local local_opts = {
        options = {
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "lazy", "alpha" },
            winbar = { "lazy", "alpha", "toggleterm", "NvimTree", "Trouble", "neo-tree" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            -- { "branch" },
            { "b:gitsigns_head", icon = "" },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = symbols.diagnostics.Error,
                warn = symbols.diagnostics.Warn,
                info = symbols.diagnostics.Info,
                hint = symbols.diagnostics.Hint,
              },
            },
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = " " } },
          },
          lualine_x = {
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = helper.get_fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = helper.get_fg("Constant"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = helper.get_fg("Special"),
            },
            {
              "diff",
              source = function()
                ---@diagnostic disable-next-line: undefined-field
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              symbols = {
                added = symbols.git.added,
                modified = symbols.git.modified,
                removed = symbols.git.removed,
              }, -- changes diff symbols
            },
          },
        },
        winbar = winbar_opt,
        inactive_winbar = winbar_opt,
        extensions = { "nvim-tree" },
      }

      return vim.tbl_deep_extend("force", local_opts, opts)
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = {
      char = "│",
      filetype_exclude = indent_exclude_fts,
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufReadPre",
    opts = {
      draw = {
        animation = function()
          return 0
        end,
      },
      symbol = "│",
      options = {
        border = "top",
        try_as_border = true,
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = indent_exclude_fts,
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
      require("mini.indentscope").setup(opts)
    end,
  },

  -- noicer ui
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@type NoiceConfig
    opts = {
      lsp = {
        progress = {
          throttle = 1000 / 3,
        },
        documentation = {
          ---@type NoiceViewOptions
          opts = {
            border = "rounded",
            relative = "cursor",
            position = {
              row = 2,
            },
          },
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = false,
      },
      ---@type NoiceConfigViews
      views = {
        -- mini = { win_options = { winblend = 0 } },
      }, ---@see section on views
    },
    -- stylua: ignore
    keys = {
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    },
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    cond = helper.is_directory_or_nil,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = {
        "                                                                   ",
        "      ████ ██████           █████      ██                    ",
        "     ███████████             █████                            ",
        "     █████████ ███████████████████ ███   ███████████  ",
        "    █████████  ███    █████████████ █████ ██████████████  ",
        "   █████████ ██████████ █████████ █████ █████ ████ █████  ",
        " ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
        "██████  █████████████████████ ████ █████ █████ ████ ██████",
      }

      local header_logo = {}
      for i, line in ipairs(logo) do
        header_logo[i] = { type = "text", val = line, opts = { hl = "StartLogo" .. i, position = "center" } }
      end

      dashboard.section.header.type = "group"
      dashboard.section.header.val = header_logo
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", " " .. " New file", "<cmd>ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files", "<cmd>Telescope oldfiles <cr>"),
        dashboard.button("g", " " .. " Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("c", " " .. " Config", "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("s", "勒" .. " Restore Session", "<cmd>SessionLoad<cr>"),
        dashboard.button("l", "鈴" .. " Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.config.layout[1].val = 8

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      dashboard.config.opts.autostart = false

      return dashboard.config
    end,
    config = function(_, opts)
      require("alpha").setup(opts)

      local function run_alpha()
        local buf = vim.api.nvim_get_current_buf()
        if helper.is_directory() then
          vim.api.nvim_set_current_dir(vim.api.nvim_buf_get_name(buf))
        end
        require("alpha").start(false, opts)
        vim.api.nvim_buf_delete(buf, {})
      end

      run_alpha()
    end,
  },

  -- folding
  -- add folding range to capabilities
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    --stylua: ignore
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, },
      { "zM", function() require("ufo").closeAllFolds() end, },
      { "zr", function(...) require("ufo").openFoldsExceptKinds(...) end, },
      { "zm", function(...) require("ufo").closeFoldsWith(...) end, },
      {
        'K',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Preview fold or hover"
      }
    },
    opts = function()
      local ts_indent = { "treesitter", "indent" }
      local ft_map = {
        vim = "indent",
        python = "indent",
        git = "",
      }
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
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
            -- str width returned from truncate() may less than 2nd argument, need padding
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
      return {
        open_fold_hl_timeout = 0,
        close_fold_kinds = { "imports", "comment" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
          },
        },
        provider_selector = function(_, filetype, _)
          return ft_map[filetype] or ts_indent
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },

  -- lsp symbol navigation for lualine
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.g.navic_silence = true
      helper.on_lsp_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider == true then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = {
      icons = settings.icons.kinds,
      separator = " ",
      highlight = true,
      depth_limit = 5,
    },
  },

  -- icons
  "nvim-tree/nvim-web-devicons",

  -- ui components
  "MunifTanjim/nui.nvim",
}
