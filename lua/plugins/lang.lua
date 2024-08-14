return {
  { import = "plugins.lang.langium" },
  { import = "plugins.lang.ungrammar" },
  { import = "plugins.lang.zig" },
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.g.lazyvim_python_lsp = "basedpyright"
    end,
    opts = {
      servers = {
        dartls = {},
        basedpyright = {
          settings = {
            -- Using Ruff's import organizer
            basedpyright = {
              disableOrganizeImports = true,
              typeCheckingMode = "off",
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dart", "elm", "kdl", "make", "css", "scss" })
      end
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      jdtls = function(opts)
        local install_path = require("mason-registry").get_package("jdtls"):get_install_path()
        local jvmArg = "-javaagent:" .. install_path .. "/lombok.jar"
        table.insert(opts.cmd, "--jvm-arg=" .. jvmArg)
        return opts
      end,
    },
  },
}
