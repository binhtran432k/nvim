(fn config []
  (let [{: setup
         : visible
         : close
         : complete
         : complete_common_string
         : select_next_item
         : select_prev_item
         : mapping
         :config {: sources}} (require :cmp)
        {: lsp_expand : expand_or_jumpable : expand_or_jump : jumpable : jump} (require :luasnip)
        {: cmp_format} (require :lspkind)
        {: lazy_load} (require :luasnip.loaders.from_vscode)
        menu {:luasnip "[Snip]"
              :nvim_lsp "[Lsp]"
              :buffer "[Buf]"
              :conjure "[Conj]"
              :path "[Path]"
              :cmdline "[Cmd]"}
        border {:border :rounded}
        toggle-cmp #(if (visible) (close) (complete))
        common-cmp #(if (visible) (complete_common_string) ($1))
        select-next-cmp (fn [fallback]
                          (if (visible) (select_next_item)
                              (expand_or_jumpable) (expand_or_jump)
                              (fallback)))
        select-prev-cmp (fn [fallback]
                          (if (visible) (select_prev_item)
                              (jumpable -1) (jump -1)
                              (fallback)))]
    (lazy_load)
    (setup {:snippet {:expand #(lsp_expand $1.body)}
            :formatting {:format (cmp_format {:maxwidth 50
                                              :before (fn [{:source {: name}}
                                                           item]
                                                        (tset item :menu
                                                              (. menu name))
                                                        item)})}
            :mapping (mapping.preset.insert {:<C-u> (mapping.scroll_docs -4)
                                             :<C-d> (mapping.scroll_docs 4)
                                             :<C-Space> {:i toggle-cmp
                                                         :c toggle-cmp}
                                             :<C-l> (mapping common-cmp)
                                             :<C-e> (mapping.abort)
                                             :<CR> (mapping.confirm {:select true})
                                             :<C-n> select-next-cmp
                                             :<C-p> select-prev-cmp
                                             :<Tab> select-next-cmp
                                             :<S-Tab> select-prev-cmp})
            :window {:completion border :documentation border}
            :sources (sources [{:name :nvim_lsp}
                               {:name :luasnip}
                               {:name :conjure}
                               {:name :path}
                               {:name :buffer}])})
    (setup.cmdline ":"
                   {:mapping (mapping.preset.cmdline)
                    :sources (sources [{:name :cmdline}] [{:name :buffer}])})
    (each [_ cmd-type (ipairs ["/" "?"])]
      (setup.cmdline cmd-type
                     {:mapping (mapping.preset.cmdline)
                      :sources (sources [{:name :buffer}])}))))

{: config}
