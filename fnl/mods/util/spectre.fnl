(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<leader>S "<cmd>lua require('spectre').open()<cr>"
         {:desc "Open Spectre" :silent true})))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup} (require :spectre)]
    (setup)))

{: config : setup}
