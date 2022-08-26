(fn setup [timeout]
  (set vim.opt.timeoutlen (or timeout 0)))

(fn autocmd []
  (let [{:api {: nvim_create_autocmd}} vim]
    (vim.api.nvim_create_autocmd :InsertEnter {:callback #(setup 1000)})
    (vim.api.nvim_create_autocmd :InsertLeave {:callback #(setup)})))

(fn config []
  (let [{: setup : register} (require :which-key)]
    (setup {:window {:border ["" "─" "" "" "" "─" "" ""]}})
    (register {:<leader> {:name :Action
                          :a "ISwap with"
                          :A "ISwap node with"
                          :rr "TS Smart rename"
                          :w "Word motion w"
                          :b "Word motion b"
                          :e "Word motion e"
                          :ge "Word motion ge"}
               :<localleader> {:name "Local action"
                               :e {:name "Conjure Eval"
                                   :c {:name "Eval Comments"}}
                               :l {:name "Conjure Log"}
                               :r {:name "Conjure Reset"}
                               :h :Gitsigns
                               :t {:name :Toggle}
                               :gd "Conjure definition"
                               :K "Conjure doc"}
               "]" {:name "Go to next"
                    :a "Move ISwap node next"
                    :c "Next class start"
                    :C "Next class end"
                    :f "Next function start"
                    :F "Next function end"}
               "[" {:name "Go to previous"
                    :a "Move ISwap node previous"
                    :c "Previous class start"
                    :C "Previous class end"
                    :f "Previous function start"
                    :F "Previous function end"}
               ;; lazy load fix label
               :gb "Comment toggle blockwise"
               :<c-n> "Toggle Tree"
               :<a-n> "Toggle Tree find file"
               :<c-p> "Telescope find files"
               :<a-p> :Telescope
               :<a-1> "Toggle term 1"
               :<a-2> "Toggle term 2"
               :<a-3> "Toggle term 3"
               :<a-4> "Toggle term lazygit"
               :<a-5> "Toggle term ranger"
               :gc "Comment toggle linewise"}))
  (autocmd))

{: config : setup}
