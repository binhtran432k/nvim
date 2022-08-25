(fn setup []
  (let [g vim.g]
    (set g.matchup_enabled 1)
    (set g.matchup_matchparen_timeout 100)
    (set g.matchup_matchparen_deferred_show_delay 100)
    (set g.matchup_matchparen_stopline (* 2 (vim.api.nvim_win_get_height 0)))
    (set g.matchup_delim_noskips 1)
    (set g.matchup_matchparen_deferred 1)
    (set g.matchup_matchparen_offscreen {:method nil})
    (set g.matchup_matchpref {:html {:nolists 1}})))

{: setup}
