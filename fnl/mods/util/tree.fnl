(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<c-n> :<cmd>NvimTreeToggle<cr> {:desc "Toggle Tree"})
    (map :n :<a-n> :<cmd>NvimTreeFindFileToggle<cr> {:desc "Toggle Tree Focus"})))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup} (require :nvim-tree)]
    (setup {:sync_root_with_cwd true
            :git {:ignore false}
            :respect_buf_cwd true
            :ignore_ft_on_setup [:startify :dashboard :alpha]
            :renderer {:group_empty true :indent_markers {:enable true}}})))

{: config : setup}
