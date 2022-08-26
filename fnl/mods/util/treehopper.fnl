(local tsht (require :tsht))

(fn mapping []
  (let [{:keymap {:set map}} vim
        {: move} tsht]
    (map :o :m ":<c-u>lua require('tsht').nodes()<cr>"
         {:silent true :desc "Select nodes"})
    (map :x :m ":lua require('tsht').nodes()<cr>"
         {:silent true :desc "Select nodes"})
    (map :n :S move {:silent true})))

(fn config []
  (mapping))

{: config}
