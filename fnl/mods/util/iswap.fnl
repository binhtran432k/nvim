(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n "<leader>a" :<cmd>ISwapWith<cr>)
    (map :n "<leader>A" :<cmd>ISwapNodeWith<cr>)
    (map :n "]a" :<cmd>ISwapNodeWithRight<cr>)
    (map :n "[a" :<cmd>ISwapNodeWithLeft<cr>)))

(fn config []
  (let [{: setup} (require :iswap)]
    (setup)
    (mapping)))

{: config}
