(fn config []
  (let [{: setup : add_rules} (require :nvim-autopairs)
        Rule (require :nvim-autopairs.rule)]
    (setup {:check_ts true
            :ts_config {:lua [:string :source]
                        :javascript [:string :template_string]}
            :disable_filetype [:TelescopePrompt :spectre_panel]
            :enable_check_bracket_line false
            :fast_wrap {:map :<M-e>
                        :chars ["{" "[" "(" "\"" "'"]
                        :pattern (string.gsub " [%'%\"%)%>%]%)%}%,] " "%s+" "")
                        :offset 0
                        :end_key "$"
                        :keys :qwertyuiopzxcvbnmasdfghjkl
                        :check_comma true
                        :highlight :Search
                        :highlight_grey :Comment}})
    (add_rules [(-> (Rule " " " ")
                    (: :with_pair
                       (fn [{: col : line}]
                         (let [pair (line:sub (- col 1) col)]
                           (vim.tbl_contains ["()" "[]" "{}"] pair)))))
                (-> (Rule "( " " )")
                    (: :with_pair #false)
                    (: :with_move
                       (fn [opts]
                         (not= (opts.prev_char:match ".%)") nil)))
                    (: :use_key ")"))
                (-> (Rule "[ " " ]")
                    (: :with_pair #false)
                    (: :with_move
                       (fn [opts]
                         (not= (opts.prev_char:match ".%]") nil)))
                    (: :use_key "]"))
                (-> (Rule "{ " " }")
                    (: :with_pair #false)
                    (: :with_move
                       (fn [opts]
                         (not= (opts.prev_char:match ".%}") nil)))
                    (: :use_key "}"))])))

{: config}
