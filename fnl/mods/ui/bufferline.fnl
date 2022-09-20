(fn disabled-filetype []
  "fix visiblity in alpha"
  (when (= vim.bo.filetype :alpha)
    (set vim.opt.showtabline 0)))

(fn commands []
  (let [{: cmd :api {: nvim_create_user_command}} vim]
    (nvim_create_user_command :OnlyBuffer
                              (fn []
                                (cmd :BufferLineCloseRight)
                                (cmd :BufferLineCloseLeft))
                              {})))

(fn mappings []
  (let [{:keymap {:set map}} vim]
    (map :n "[b" :<cmd>BufferLineCyclePrev<cr> {:desc "Previous buffer"})
    (map :n "]b" :<cmd>BufferLineCycleNext<cr> {:desc "Next buffer"})
    (map :n "[B" :<cmd>BufferLineMovePrev<cr> {:desc "Move buffer previous"})
    (map :n "]B" :<cmd>BufferLineMoveNext<cr> {:desc "Move buffer next"})
    (map :n :<localleader>b :<cmd>BufferLinePick<cr> {:desc "Pick buffer"})
    (map :n :<localleader>B :<cmd>OnlyBuffer<cr> {:desc "Only current buffer"})))

(fn setup []
  (mappings)
  (commands))

(fn config []
  (let [{: setup} (require :bufferline)]
    (setup {:options {:indicator {:style :underline}
                      :offsets [{:filetype :NvimTree
                                 :text "File Explorer"
                                 :highlight :Directory
                                 :text_align :left}]}}))
  (disabled-filetype))

{: config : setup}
