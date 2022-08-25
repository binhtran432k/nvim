(fn setup []
  (let [{: g :keymap {:set map}} vim]
    (set g.netrw_nogx 1)
    (set g.openbrowser_default_search :duckduckgo)
    (map [:n :x] :gx "<plug>(openbrowser-smart-search)")))

{: setup}
