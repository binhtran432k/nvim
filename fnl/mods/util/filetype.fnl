(fn config []
  (let [{: setup} (require :filetype)]
    (setup {:overrides {:extensions {:scm :query :conf :config}
                        :literal {:tsconfig.json :jsonc}}})))

{: config}
