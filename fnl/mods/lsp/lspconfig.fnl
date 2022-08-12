(fn mapping []
  (let [{:keymap {:set map}
                 :diagnostic {: open_float
                 : goto_prev
                 : goto_next}
                 :lsp {:buf {
                 ;; : type_definition
                 ;; : add_workspace_folder
                 ;; : remove_workspace_folder
                 ;; : list_workspace_folders
                 : references ; TODO: use trouser
                 : definition
                 : declaration
                 : implementation
                 : hover
                 : signature_help
                 : rename
                 : code_action
                 : range_code_action
                 }}} vim]
    (map :n :gl open_float)
    (map :n "]d" goto_next)
    (map :n "[d" goto_prev)
    (map :n :gr references)
    (map :n :gD declaration)
    (map :n :gd definition)
    (map :n :gI implementation)
    (map :n :K hover)
    (map :n :gs signature_help)
    (map :n :<leader>rn rename)
    (map :n :<leader>ca code_action)
    (map :v :<leader>ca range_code_action)))

(fn config []
  (let [{: diagnostic
           :fn {: sign_define}
           :lsp {: handlers : with}} vim
           signs {:Error "" :Warn "" :Hint "" :Info ""}
           config {:virtual_text true
           :signs {:active signs}
           :update_in_insert true
           :underline true
           :severity_sort true
           :float {:focusable true
           :style :minimal
           :border :rounded
           :source :always
           :header ""
           :prefix ""}}]
    (each [typ icon (pairs signs)]
      (let [hl (.. :DiagnosticSign typ)]
        (sign_define hl {:text icon :texthl hl :numhl hl})))
    (diagnostic.config config)
    (tset handlers :textDocument/hover
          (with handlers.hover {:border :rounded}))
    (tset handlers :textDocument/signatureHelp
          (with handlers.signature_help {:border :rounded})))
  (mapping))

{
: config
}
