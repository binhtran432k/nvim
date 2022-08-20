(fn config []
  (let [{: setup} (require :Comment)
        {: create_pre_hook} (require :ts_context_commentstring.integrations.comment_nvim)]
    (setup {:pre_hook (create_pre_hook)})))

{: config}
