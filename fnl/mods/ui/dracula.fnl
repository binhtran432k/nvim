(macro gradients [hex1 hex2 max]
  (local max-1 (- max 1))

  (fn rbg->hex [r g b]
    (string.format "#%02X%02X%02X" r g b))

  (fn hex->rbg [hex]
    (let [r (tonumber (.. :0x (hex:sub 2 3)))
          g (tonumber (.. :0x (hex:sub 4 5)))
          b (tonumber (.. :0x (hex:sub 6 7)))]
      [r g b]))

  (fn color [c1 c2 i]
    (math.floor (/ (+ (* c1 (- max-1 i)) (* c2 i)) max-1)))

  (let [[r1 g1 b1] (hex->rbg hex1)
        [r2 g2 b2] (hex->rbg hex2)
        grads []]
    (for [i 0 max-1]
      (table.insert grads (rbg->hex (color r1 r2 i) (color g1 g2 i)
                                    (color b1 b2 i))))
    grads))

(fn config []
  (set vim.g.dracula_italic_comment true)
  (vim.cmd "syntax on | colorscheme dracula")
  (let [{: cmd :api {: nvim_create_augroup : nvim_create_autocmd}} vim
        colors ((. (require :dracula) :colors))
        rainbows-colors [colors.red
                         colors.green
                         colors.yellow
                         colors.purple
                         colors.pink
                         colors.cyan
                         colors.white]
        logo-colors (gradients "#bd93f9" "#ff79c6" 8)
        callback (fn []
                   (each [i color (ipairs rainbows-colors)]
                     (cmd (string.format "highlight! rainbowcol%d guifg=%s" i
                                         color)))
                   (each [i color (ipairs logo-colors)]
                     (cmd (string.format "highlight! StartLogo%d guifg=%s" i
                                         color))))
        gid (nvim_create_augroup :custom_dracula_highlights {})]
    (nvim_create_autocmd :ColorScheme {: callback :group gid})
    (callback)))

{: config}
