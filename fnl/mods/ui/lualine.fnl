(fn lsp []
  (var msg "No Active Lsp")
  (local buf-ft (vim.api.nvim_buf_get_option 0 :filetype))
  (local clients (vim.lsp.get_active_clients))
  (each [_ client (ipairs clients)]
    (local filetypes client.config.filetypes)
    (when (and filetypes (not= (vim.fn.index filetypes buf-ft) (- 1)))
      (if (or (= client.name :null-ls) (= client.name :emmet_ls))
          (set msg client.name)
          (let [___client_name___ client.name]
            (lua "return ___client_name___")))))
  msg)

(fn diff-source []
  (let [gitsigns vim.b.gitsigns_status_dict]
    (when gitsigns
      {:added gitsigns.added
       :modified gitsigns.changed
       :removed gitsigns.removed})))

(fn config []
  (let [{: setup} (require :lualine)
        navic (require :nvim-navic)
        diagnostic-line {1 :diagnostics
                         :symbols {:hint " "
                                   :info " "
                                   :warn " "
                                   :error " "}}]
    (setup {:options {:icons_enabled true
                      ;; :theme :auto
                      :theme :dracula-nvim
                      :component_separators {:left "" :right ""}
                      :section_separators {:left "" :right ""}
                      :disabled_filetypes {:statusline [:alpha]
                                           :winbar [:alpha
                                                    :NvimTree
                                                    :toggleterm
                                                    :Trouble]}
                      :ignore_focus {}
                      :always_divide_middle true
                      :globalstatus false
                      :refresh {:statusline 1000 :tabline 1000 :winbar 1000}}
            :sections {:lualine_a [:mode]
                       :lualine_b [{1 "b:gitsigns_head" :icon ""}
                                   {1 :diff :source diff-source}]
                       :lualine_c [:filename]
                       :lualine_x [:encoding :fileformat :filetype]
                       :lualine_y [:progress]
                       :lualine_z [:location]}
            :inactive_sections {:lualine_a []
                                :lualine_b []
                                :lualine_c [:filename]
                                :lualine_x [:location]
                                :lualine_y []
                                :lualine_z []}
            :tabline {}
            :winbar {:lualine_a [#" "]
                     :lualine_c [{1 lsp :icon " "}
                                 diagnostic-line
                                 {1 navic.get_location
                                  :cond navic.is_available}]}
            :inactive_winbar {}
            :extensions [:nvim-tree :toggleterm]})))

{: config}
