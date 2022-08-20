(fn commands []
  (let [{: cmd :api {: nvim_create_user_command}} vim]
    (nvim_create_user_command :OnlyBuffer #(cmd "execute '%bd|e#|bd#'") {})))

(fn mappings []
  (let [{:keymap {:set map}} vim]
    (map :n "[b" :<cmd>BufferLineCyclePrev<cr>)
    (map :n "]b" :<cmd>BufferLineCycleNext<cr>)
    (map :n "[B" :<cmd>BufferLineMovePrev<cr>)
    (map :n "]B" :<cmd>BufferLineMoveNext<cr>)
    (map :n :gb :<cmd>BufferLinePick<cr>)))

(fn config []
  (let [{: setup} (require :bufferline)]
    (setup {:options {:offsets [{:filetype :NvimTree
                                 :text "File Explorer"
                                 :highlight :Directory
                                 :text_align :left}]}})
    (mappings)
    (commands)))

{: config}
