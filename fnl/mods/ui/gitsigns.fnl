(fn config []
  (let [{: setup
         : next_hunk
         : prev_hunk
         : stage_buffer
         : undo_stage_hunk
         : reset_buffer
         : preview_hunk
         : blame_line
         : toggle_current_line_blame
         : diffthis
         : toggle_deleted} (require :gitsigns)]
    (setup {:on_attach (fn [bufnr]
                         (fn map [mode l r opts]
                           (let [opts (or opts {})]
                             (tset opts :buffer bufnr)
                             (vim.keymap.set mode l r opts)))

                         (map :n "]h"
                              (fn []
                                (if vim.wo.diff "]h"
                                    (do
                                      (vim.schedule next_hunk)
                                      :<ignore>)))
                              {:expr true})
                         (map :n "[h"
                              (fn []
                                (if vim.wo.diff "[h"
                                    (do
                                      (vim.schedule prev_hunk)
                                      :<ignore>)))
                              {:expr true})
                         (map [:n :v] :<localleader>hs
                              ":Gitsigns stage_hunk<CR>")
                         (map [:n :v] :<localleader>hr
                              ":Gitsigns reset_hunk<CR>")
                         (map :n :<localleader>hS stage_buffer)
                         (map :n :<localleader>hu undo_stage_hunk)
                         (map :n :<localleader>hR reset_buffer)
                         (map :n :<localleader>hp preview_hunk)
                         (map :n :<localleader>hb #(blame_line {:full true}))
                         (map :n :<localleader>tb toggle_current_line_blame)
                         (map :n :<localleader>hd diffthis)
                         (map :n :<localleader>hD #(diffthis "~"))
                         (map :n :<localleader>td toggle_deleted))})))

{: config}
