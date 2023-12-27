return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {},
    },
  },
  {
    "neovim/nvim-lspconfig",
    ---@param opts PluginLspOpts
    opts = function(_, opts)
      for _, server in pairs(opts.servers) do
        if not server.mason then
          server.mason = false
        end
      end
    end,
  },
}
