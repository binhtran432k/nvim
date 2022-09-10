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
  (map :n :gl open_float {:desc "Float diagnostic"})
  (map :n "]d" goto_next {:desc "Next diagnostic"})
  (map :n "[d" goto_prev {:desc "Previous diagnostic"})
  (map :n :gr references {:desc "Go to references"})
  (map :n :gD declaration {:desc "Go to declaration"})
  (map :n :gd definition {:desc "Go to definition"})
  (map :n :gI implementation {:desc "Go to implementation"})
  ;; (map :n :K hover {:desc "Hover"}) ; ufo
  (map :n :gK signature_help {:desc "Signature help"})
  (map :n :gp format {:desc "Format file"})
  (map :v :gp range_formatting {:desc "Format range"})
  (nvim_create_user_command :Format format {})
  (map :n :<leader>rn rename {:desc :Rename})
  (map :n :<leader>ca code_action {:desc "Code action"}))

(fn get-capabilities []
  (let [capabilities (protocol.make_client_capabilities)
        {: update_capabilities} (require :cmp_nvim_lsp)]
    (set capabilities.textDocument.completion.completionItem.snippetSupport
         true)
    (set capabilities.textDocument.foldingRange
         {:dynamicRegistration false :lineFoldingOnly true})
    (update_capabilities capabilities)))

(fn on-attach [client bufnr]
  (let [signature (require :lsp_signature)
        navic (require :nvim-navic)]
    (signature.on_attach {:floating_window false :hint_prefix "💪 "} bufnr)
    (navic.attach client bufnr)))

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
                         {:on_attach on-attach
                          :capabilities (get-capabilities)}))
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

{: config : on-attach : get-capabilities}
