(let [{: g : opt :api {:nvim_set_keymap map}} vim]
  ;; Neovide configuration
  (when g.neovide
    (set opt.guifont "Cascadia Code:h12")
    (set g.neovide_floating_blur_amount_x 3)
    (set g.neovide_floating_blur_amount_y 3)
    (set g.neovide_transparency 0.9)))

{}
