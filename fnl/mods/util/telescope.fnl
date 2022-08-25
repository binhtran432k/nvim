(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<c-p> "<cmd>Telescope find_files<cr>")
    (map :n :<a-p> "<cmd>Telescope builtin include_extensions=true<cr>")))

(fn config []
  (let [{: setup : load_extension} (require :telescope)]
    (setup {:extensions {:fzf {:fuzzy true
                               :override_generic_sorter true
                               :override_file_sorter true
                               :case_mode :smart_case}}})
    (load_extension :fzf)
    (load_extension :luasnip)
    (load_extension :projects)
    (load_extension :todo-comments))
  (mapping))

{: config}
