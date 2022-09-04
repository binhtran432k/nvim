(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :s :<cmd>HopChar1<cr> {:desc "Hop 1 char" :silent true})
    (map :n :S :<cmd>HopWord<cr> {:desc "Hop word" :silent true})))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup} (require :hop)]
    (setup)))

{: config : setup}
