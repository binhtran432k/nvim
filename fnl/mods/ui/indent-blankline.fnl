(fn config []
  (let [{: setup} (require :indent_blankline)]
    (setup {:char_list ["┃" "║" "╬"]
            ; "┃" "║" "╬" "█"
            :show_trailing_blankline_indent false
            :filetype_exclude [:NvimTree]})))

{: config}
