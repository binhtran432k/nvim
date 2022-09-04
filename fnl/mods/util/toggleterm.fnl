(fn custom-mapterms [map mode opts]
  (let [{: Terminal} (require :toggleterm.terminal)
        lazygit (: Terminal :new {:cmd :lazygit :direction :float :id 1000})
        ranger (: Terminal :new {:cmd :ranger :direction :float :id 1001})]
    (set opts.desc "Toggle Lazygit")
    (map mode :<a-4> #(: lazygit :toggle) opts)
    (set opts.desc "Toggle Ranger")
    (map mode :<a-5> #(: ranger :toggle) opts)))

(fn mapterms [map mode opts]
  (for [i 1 3]
    (set opts.desc (string.format "Toggle Term %d" i))
    (map mode (string.format "<a-%d>" i)
         (string.format "<cmd>%dToggleTerm<cr>" i) opts))
  (custom-mapterms map mode opts))

(fn mapping-term []
  (let [{:keymap {:set map}} vim
        opts {:buffer 0}]
    (map :t :<c-w> "<c-\\><c-n><c-w>" opts)
    (map :t :<a-j> "<c-\\><c-n><cmd>resize -4<cr>" {})
    (map :t :<a-k> "<c-\\><c-n><cmd>resize +4<cr>" {})
    (map :t :<a-h> "<c-\\><c-n><cmd>vertical resize -4<cr>" {})
    (map :t :<a-l> "<c-\\><c-n><cmd>vertical resize +4<cr>" {})
    (mapterms map :t opts)))

(fn autocmd-term []
  (vim.api.nvim_create_autocmd :TermOpen
                               {:pattern "term://*" :callback mapping-term}))

(fn mapping []
  (let [{:keymap {:set map}} vim]
    (mapterms map :n {})))

(fn setup []
  (mapping)
  (autocmd-term))

(fn config []
  (let [{: setup} (require :toggleterm)
        direction :horizontal] ; vertical horizontal tab float
    (setup {: direction
            :size (match direction
                    :horizontal 15
                    :vertical (* vim.o.columns 0.4)
                    _ 20)
            :open_mapping "<c-\\>"})))

{: config : setup}
