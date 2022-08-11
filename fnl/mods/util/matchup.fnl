(fn setup []
  (let [g vim.g]
    (set g.matchup_enabled 1)
    (set g.matchup_matchparen_offscreen {:method nil})
    (set g.matchup_matchpref {:html {:nolists 1}})))

{
: setup
}
