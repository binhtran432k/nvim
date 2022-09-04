(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<leader>a :<cmd>ISwapWith<cr> {:desc "ISwap with"})
    (map :n :<leader>A :<cmd>ISwapNodeWith<cr> {:desc "ISwap node with"})
    (map :n "]a" :<cmd>ISwapNodeWithRight<cr> {:desc "Next ISwap node"})
    (map :n "[a" :<cmd>ISwapNodeWithLeft<cr> {:desc "Previous ISwap node"})))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup} (require :iswap)]
    (setup)))

{: config : setup}
