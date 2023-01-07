(local {:fn {: sign_define}
        :keymap {:set map}
        :lsp {: protocol : handlers : with}
        :api {: nvim_create_user_command}} vim)

(fn noresilentmap [mode key func opts]
  (tset opts :noremap true)
  (tset opts :silent true)
  (map mode key func opts))

(fn mapping []
  (noresilentmap :n :<space>e vim.diagnostic.open_float
                 {:desc "Float diagnostic"})
  (noresilentmap :n "]d" vim.diagnostic.goto_next {:desc "Next diagnostic"})
  (noresilentmap :n "[d" vim.diagnostic.goto_prev {:desc "Previous diagnostic"})
  (noresilentmap :n :<space>q vim.diagnostic.setloclist {:desc "Open loclist"})
  (noresilentmap :n :gD vim.lsp.buf.declaration {:desc "Go to declaration"})
  (noresilentmap :n :gd vim.lsp.buf.definition {:desc "Go to definition"})
  ;; (noresilentmap :n :gr vim.lsp.buf.references {:desc "Go to references"})
  ;; (noresilentmap :n :gI vim.lsp.buf.implementation
  ;;                {:desc "Go to implementation"})
  ;noresilentmapmap :n :K vim.lsp.buf.hover {:desc "Hover"}) ; ufo
  (noresilentmap :n :gK vim.lsp.buf.signature_help {:desc "Signature help"})
  (noresilentmap :n :<space>wa vim.lsp.buf.add_workspace_folder
                 {:desc "Add workspace folder"})
  (noresilentmap :n :<space>wr vim.lsp.buf.remove_workspace_folder
                 {:desc "Remove workspace folder"})
  (noresilentmap :n :<space>wl
                 #(print (vim.inspect (vim.lsp.buf.list_workspace_folders)))
                 {:desc "Print list workspace folder"})
  (let [fmt #(vim.lsp.buf.format {:async true})]
    (noresilentmap [:n :v] :<space>f fmt {:desc "Format file"})
    (nvim_create_user_command :Format fmt {}))
  (noresilentmap :n :<space>rn vim.lsp.buf.rename {:desc :Rename})
  (noresilentmap [:n :v] :<space>ca vim.lsp.buf.code_action
                 {:desc "Code action"}))

(fn get-capabilities [local-capabilities]
  (let [{: default_capabilities} (require :cmp_nvim_lsp)
        capabilities (default_capabilities)
        local-capabilities (or local-capabilities {})]
    (set capabilities.textDocument.completion.completionItem.snippetSupport
         true)
    (set capabilities.textDocument.foldingRange
         {:dynamicRegistration false :lineFoldingOnly true})
    (vim.tbl_extend :force capabilities local-capabilities)))

(fn on-attach [client bufnr]
  (set vim.opt_local.formatexpr " ")
  (let [signature (require :lsp_signature)
        navic (require :nvim-navic)]
    (signature.on_attach {:floating_window false :hint_prefix "💪 "} bufnr)
    (if client.server_capabilities.documentSymbolProvider
        (navic.attach client bufnr))))

(fn config-neodev []
  (let [{: setup} (require :neodev)]
    (setup {})))

(fn call-servers []
  (when (not= vim.g.readonly_mode 1)
    (let [servers [:clangd
                   :cssls
                   :cucumber_language_server
                   :emmet_ls
                   :html
                   :jsonls
                   :marksman
                   :omnisharp
                   :pyright
                   :lemminx
                   :sqlls
                   :sumneko_lua
                   :tsserver
                   :yamlls]
          sv-configs {:cucumber_language_server true
                      :emmet_ls true
                      :jsonls true
                      :marksman true
                      :omnisharp true
                      :sumneko_lua true}
          lspconfig (require :lspconfig)]
      ;; (set lspconfig.util.default_config
      ;;      (vim.tbl_extend :force lspconfig.util.default_config
      ;;                      {:on_attach on-attach
      ;;                       :capabilities (get-capabilities)}))
      (each [_ sv-name (ipairs servers)]
        (let [sv (. lspconfig sv-name)
              custom-lsp-config (if (. sv-configs sv-name)
                                    (require (.. :mods.lsp.configs. sv-name))
                                    {})]
          (set custom-lsp-config.on_attach on-attach)
          (set custom-lsp-config.capabilities
               (get-capabilities custom-lsp-config.capabilities))
          (sv.setup custom-lsp-config))))))

(fn call-lsp-utils []
  (let [lsp-fts {:jdtls [:java]}
        ft vim.bo.filetype]
    (each [lsp fts (pairs lsp-fts)]
      (each [_ lspft (ipairs fts)]
        (when (= ft lspft)
          ((. (require (string.format "mods.lsp.%s" lsp)) :config)))))))

(fn autocmd []
  (let [{:api {: nvim_create_autocmd
               : nvim_buf_get_name
               : nvim_set_current_dir
               : nvim_get_current_buf
               : nvim_buf_delete}} vim]
    (nvim_create_autocmd :BufEnter {:callback call-lsp-utils})))

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
                        :prefix ""}}
        windows (require :lspconfig.ui.windows)]
    (each [typ icon (pairs signs)]
      (let [hl (.. :DiagnosticSign typ)]
        (sign_define hl {:text icon :texthl hl :numhl hl})))
    (set windows.default_options.border :rounded)
    (vim.diagnostic.config config)
    (tset handlers :textDocument/hover (with handlers.hover {:border :rounded}))
    (tset handlers :textDocument/signatureHelp
          (with handlers.signature_help {:border :rounded})))
  (autocmd)
  (mapping)
  (config-neodev)
  (call-servers))

{: config : on-attach : get-capabilities}
