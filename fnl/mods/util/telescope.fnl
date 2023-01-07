(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<c-p> "<cmd>Telescope find_files hidden=true<cr>"
         {:desc "Telescope find files"})
    (map :n :<a-p> "<cmd>Telescope builtin include_extensions=true<cr>"
         {:desc :Telescope})))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup : load_extension} (require :telescope)]
    (setup {:defaults {:file_ignore_patterns [:^.git/
                                              :/.git/
                                              :^node_modules/
                                              :/node_modules/]}
            :extensions {:fzf {:fuzzy true
                               :override_generic_sorter true
                               :override_file_sorter true
                               :case_mode :smart_case}}})
    (load_extension :fzf)
    (load_extension :luasnip)
    (load_extension :projects)
    (load_extension :todo-comments)
    (load_extension :notify)))

{: config : setup}
