(fn config []
  (let [{: setup} (require :dressing)]
    (setup {:input {:insert_only false :win_options {:winblend 0}}})))

{: config}
