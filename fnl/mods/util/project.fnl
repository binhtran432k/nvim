(fn config []
  (let [{: setup} (require :project_nvim)]
    (setup {:detection_methods [:pattern :lsp]})))

{: config}
