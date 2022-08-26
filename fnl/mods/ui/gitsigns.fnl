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
                              {:expr true :desc "Next hunk"})
                         (map :n "[h"
                              (fn []
                                (if vim.wo.diff "[h"
                                    (do
                                      (vim.schedule prev_hunk)
                                      :<ignore>)))
                              {:expr true :desc "Previous hunk"})
                         (map [:n :v] :<localleader>hs
                              ":Gitsigns stage_hunk<CR>" {:desc "Stage hunk"})
                         (map [:n :v] :<localleader>hr
                              ":Gitsigns reset_hunk<CR>" {:desc "Reset hunk"})
                         (map :n :<localleader>hS stage_buffer
                              {:desc "Stage buffer"})
                         (map :n :<localleader>hu undo_stage_hunk
                              {:desc "Undo stage hunk"})
                         (map :n :<localleader>hR reset_buffer
                              {:desc "Reset buffer"})
                         (map :n :<localleader>hp preview_hunk
                              {:desc "Preview hunk"})
                         (map :n :<localleader>hb #(blame_line {:full true})
                              {:desc "Blame line"})
                         (map :n :<localleader>tb toggle_current_line_blame
                              {:desc "Toggle current line blame"})
                         (map :n :<localleader>hd diffthis {:desc "Diff this"})
                         (map :n :<localleader>hD #(diffthis "~")
                              {:desc "Diff this(~)"})
                         (map :n :<localleader>td toggle_deleted
                              {:desc "Toggle hunk deleted"}))})))

{: config}
