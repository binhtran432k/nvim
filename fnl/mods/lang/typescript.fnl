(fn config []
  (let [{: setup} (require :typescript)
        {: capabilities} (require :mods.lsp.lspconfig)]
    (setup {:server {:capabilities (capabilities)}})))

{: config}
