(local ufo (require :ufo))

(fn reset-fold []
  (let [o vim.o]
    (set o.foldmethod :manual)
    (set o.foldlevel 99)
    (set o.foldlevelstart -1)))

(fn autocmd []
  (vim.api.nvim_create_autocmd [:BufNewFile]
                               {:callback (fn []
                                            (set vim.o.foldlevel 99))}))

(fn mapping []
  (let [{:keymap {:set map}} vim
        {: openAllFolds
         : openFoldsExceptKinds
         : closeAllFolds
         : closeFoldsWith
         : peekFoldedLinesUnderCursor} ufo]
    (map :n :zR openAllFolds)
    (map :n :zM closeAllFolds)
    (map :n :zr openFoldsExceptKinds)
    (map :n :zm closeFoldsWith)
    (map :n :K (fn []
                 (when (not (peekFoldedLinesUnderCursor))
                   (vim.lsp.buf.hover)))
         {:desc "Expand or Hover"})))

(fn command []
  (let [{:api {: nvim_create_user_command}} vim]
    (nvim_create_user_command :ResetFold reset-fold {})))

(fn fold-virt-text [virt-text lnum end-lnum width truncate]
  (let [{:fn {: indent}} vim
        {: format : rep : gsub} string
        fillchar "•"
        suffix (format "  %d " (- end-lnum lnum))
        fillindent (rep fillchar (indent lnum))
        fillchars (rep fillchar width)
        new-virt-text []]
    (table.insert new-virt-text [fillindent :Folded])
    (icollect [i [text hl] (ipairs virt-text) :into new-virt-text]
      (if (= i 1) [(gsub text "^[\t ]+" "") hl] [text hl]))
    (table.insert new-virt-text [suffix :MoreMsg])
    (table.insert new-virt-text [fillchars :Folded])
    new-virt-text))

(fn config []
  (let [{: setup} ufo
        ft-map {:vim :indent :python :indent :git ""}]
    (setup {:preview {:win_config {:border ["" "─" "" "" "" "─" "" ""]
                                   :winblend 0}
                      :mappings {:scrollU :<c-u> :scrollD :<c-d>}}
            :fold_virt_text_handler fold-virt-text
            :open_fold_hl_timeout 0
            :provider_selector #(or (. ft-map $2) [:lsp :indent])}))
  (autocmd)
  (mapping)
  (command))

{: config}
