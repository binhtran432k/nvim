(fn config []
  (let [{: setup :builtins {: formatting}} (require :null-ls)]
    (setup {:debug false
            :sources [formatting.fnlfmt formatting.autopep8 formatting.prettier]
            :fallback_severity vim.diagnostic.severity.HINT})))

{: config}
