(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<leader>xt :<cmd>TodoTrouble<cr>
         {:desc "Toggle Trouble Todo" :silent true})))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup} (require :todo-comments)]
    (setup)))

{: config : setup}
