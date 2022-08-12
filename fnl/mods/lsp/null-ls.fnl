(fn config []
  (let [{: setup :builtins {: formatting}} (require :null-ls)]
    (setup {:debug false
            :sources [formatting.fnlfmt]
            :fallback_severity vim.diagnostic.severity.HINT})))

{: config}
