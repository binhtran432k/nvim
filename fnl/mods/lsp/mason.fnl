(fn config []
  (let [{: setup} (require :mason)
        {:setup lsp-setup} (require :mason-lspconfig)]
    (setup)
    (lsp-setup)))

{: config}
