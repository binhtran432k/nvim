(fn mapping [force?]
  (each [_ [mode lhs rhs] (ipairs [[:n :s "<Plug>(leap-forward)"]
                                   [:n :S "<Plug>(leap-backward)"]
                                   [:n :gs "<Plug>(leap-cross-window)"]])]
    (vim.keymap.set mode lhs rhs {:silent true})))

(fn config []
  (mapping))

{: config}
