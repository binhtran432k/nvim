(fn config []
  (let [{: setup} (require :mason)
        {:setup lsp-setup} (require :mason-lspconfig)]
    (setup {:ui {:border :rounded
                 :icons {:package_installed "✓"
                         :package_pending "➜"
                         :package_uninstalled "✗"}}})
    (lsp-setup)))

{: config}
