(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :s :<cmd>HopChar1<cr> {:silent true})))

(fn config []
  (let [{: setup} (require :hop)]
    (setup))
  (mapping))

{: config}
