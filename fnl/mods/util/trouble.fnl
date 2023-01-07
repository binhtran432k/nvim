(fn mapping []
  (let [{:keymap {:set map}} vim]
    (map :n :<leader>xx :<cmd>TroubleToggle<cr>
         {:desc "Toggle Trouble" :silent true})
    (map :n :<leader>xw "<cmd>TroubleToggle workspace_diagnostics<cr>"
         {:desc "Toggle Trouble Workspace" :silent true})
    (map :n :<leader>xf "<cmd>TroubleToggle document_diagnostics<cr>"
         {:desc "Toggle Trouble Document" :silent true})
    (map :n :<leader>xq "<cmd>TroubleToggle quickfix<cr>"
         {:desc "Toggle Trouble Quickfix" :silent true})
    (map :n :<leader>xl "<cmd>TroubleToggle loclist<cr>"
         {:desc "Toggle Trouble Loclist" :silent true})
    (map :n :<leader>xd "<cmd>TroubleToggle lsp_definitions<cr>"
         {:desc "Toggle Trouble Lsp Definition" :silent true})
    (map :n :gr "<cmd>TroubleToggle lsp_references<cr>"
         {:desc "Toggle Trouble Lsp Reference" :silent true})
    (map :n :gI "<cmd>TroubleToggle lsp_implementations<cr>"
         {:desc "Toggle Trouble Lsp Implementation" :silent true})
    ))

(fn setup []
  (mapping))

(fn config []
  (let [{: setup} (require :trouble)]
    (setup)))

{: config : setup}
