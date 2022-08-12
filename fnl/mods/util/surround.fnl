(fn config []
  (let [{: setup} (require :nvim-surround)]
    (setup {:keymaps {:visual :z :visual_line :Z}})))

{: config}
