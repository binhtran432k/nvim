(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<c-n> :<cmd>NvimTreeToggle<cr>)
    (map :n :<a-n> :<cmd>NvimTreeFindFileToggle<cr>)))

(fn config []
  (let [{: setup} (require :nvim-tree)]
    (setup {:ignore_ft_on_setup [:startify :dashboard :alpha]
            :renderer {:group_empty true :indent_markers {:enable true}}
            :filters {:dotfiles true}}))
  (mapping))

{: config}
