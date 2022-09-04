(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map [:x :o] :m ":<c-u>lua require('tsht').nodes()<cr>"
         {:silent true :desc "Treehopper nodes"})
    (map :n :<leader>s ":lua require('tsht').move()<cr>"
         {:silent true :desc "Treehopper move"})))

(fn setup []
  (mapping))

{: setup}
