(fn config []
  (let [{: setup} (require :typescript)
        {: on-attach : get-capabilities} (require :mods.lsp.lspconfig)]
    (setup {:server {:on_attach on-attach :capabilities (get-capabilities)}})))

{: config}
