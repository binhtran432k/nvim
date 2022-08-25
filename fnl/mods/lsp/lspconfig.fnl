(local {:fn {: sign_define}
        :keymap {:set map}
        :diagnostic {: open_float : goto_prev : goto_next :config diag-config}
        :lsp {: protocol
              : handlers
              : with
              :buf {: references
                    : definition
                    : declaration
                    : implementation
                    : hover
                    : signature_help
                    : rename
                    : code_action
                    : range_code_action
                    : format
                    : range_formatting}}
        :api {: nvim_create_user_command}} vim)

(fn mapping []
  (map :n :gl open_float)
  (map :n "]d" goto_next)
  (map :n "[d" goto_prev)
  (map :n :gr references)
  (map :n :gD declaration)
  (map :n :gd definition)
  (map :n :gI implementation)
  ;; (map :n :K hover) ; ufo
  (map :n :gK signature_help)
  (map :n :gp format)
  (map :v :gp range_formatting)
  (map :n :<leader>rn rename)
  (map :n :<leader>ca code_action)
  (nvim_create_user_command :Format format {}))

(fn capabilities []
  (let [capabilities (protocol.make_client_capabilities)
        {: update_capabilities} (require :cmp_nvim_lsp)]
    (set capabilities.textDocument.completion.completionItem.snippetSupport
         true)
    (set capabilities.textDocument.foldingRange
         {:dynamicRegistration false :lineFoldingOnly true})
    (update_capabilities capabilities)))

(fn call-servers []
  (let [servers [:cssls
                 :emmet_ls
                 :html
                 :jsonls
                 :marksman
                 :pyright
                 :sqlls
                 :sumneko_lua
                 :yamlls]
        sv-configs {:jsonls true :sumneko_lua true}
        lspconfig (require :lspconfig)]
    (set lspconfig.util.default_config
         (vim.tbl_extend :force lspconfig.util.default_config
                         {:capabilities (capabilities)}))
    (each [_ sv-name (ipairs servers)]
      (let [sv (. lspconfig sv-name)]
        (if (. sv-configs sv-name)
            (sv.setup (require (.. :mods.lsp.configs. sv-name)))
            (sv.setup {}))))))

(fn config []
  (let [signs {:Error "" :Warn "" :Hint "" :Info ""}
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
    (diag-config config)
    (tset handlers :textDocument/hover (with handlers.hover {:border :rounded}))
    (tset handlers :textDocument/signatureHelp
          (with handlers.signature_help {:border :rounded})))
  (mapping)
  (call-servers))

{: config}
