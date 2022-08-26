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
    (map :n :<space> :<cmd>BufferLinePick<cr> {:desc "Pick buffer"})
    (map :n :<leader><space> :<cmd>OnlyBuffer<cr> {:desc "Leave Only buffer"})))

(fn config []
  (let [{: setup} (require :bufferline)]
    (setup {:options {:offsets [{:filetype :NvimTree
                                 :text "File Explorer"
                                 :highlight :Directory
                                 :text_align :left}]}}))
  (mappings)
  (commands)
  (disabled-filetype))

{: config}
