(fn setup []
  (let [{: g} vim]
    (set g.mkdp_browser :brave-popup)
    (set g.vim_markdown_no_default_key_mappings 1)
    (set g.vim_markdown_folding_disabled 1)
    (set g.mkdp_auto_close 0)
    (set g.mkdp_filetypes [:markdown])))

{: setup}
