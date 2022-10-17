(local g vim.g)
(local opt vim.opt)

;; Neovide configuration
(when g.neovide
  (tset opt :guifont "Cascadia Code:h12")
  (tset g :neovide_floating_blur_amount_x 3)
  (tset g :neovide_floating_blur_amount_y 3)
  (tset g :neovide_transparency 0.9))

{}
