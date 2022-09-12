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
                    :c "Next class start"
                    :C "Next class end"
                    :f "Next function start"
                    :F "Next function end"}
               "[" {:name "Go to previous"
                    :c "Previous class start"
                    :C "Previous class end"
                    :f "Previous function start"
                    :F "Previous function end"}
               ;; lazy load fix label
               :g {:b "Comment toggle blockwise" :c "Comment toggle linewise"}}))
  (autocmd))

{: config : setup}
