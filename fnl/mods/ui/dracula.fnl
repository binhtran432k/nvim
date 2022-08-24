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
  (let [{: cmd :api {: nvim_create_augroup : nvim_create_autocmd}} vim
        {: setup : colors} (require :dracula)
        colors (colors)
        overrides {:GitSignsCurrentLineBlame {:fg colors.white}
                   :NvimTreeIndentMarker {:fg colors.white}}
        logo-colors (gradients "#bd93f9" "#ff79c6" 8)
        transparent {:Normal {:fg colors.fg}
                     :SignColumn {}
                     :NvimTreeNormal {:link :Normal}
                     :NvimTreeVertSplit {:fg colors.black}
                     :Pmenu {:fg colors.white}
                     :BufferLineFill {}
                     :NormalFloat {:link :Normal}
                     :TelescopeNormal {:link :Normal}}]
    (collect [i color (ipairs logo-colors) :into overrides]
      (values (.. :StartLogo i) {:fg color}))
    (collect [group settings (pairs transparent) :into overrides]
      (values group settings))
    (setup {:italic_comment true : overrides})
    (cmd "colorscheme dracula")))

{: config}
