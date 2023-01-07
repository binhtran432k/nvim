(fn gradients [hex1 hex2 max]
  (local max-1 (- max 1))

  (fn rgb->hex [r g b]
    (string.format "#%02X%02X%02X" r g b))

  (fn hex->rgb [hex]
    (let [r (tonumber (.. :0x (hex:sub 2 3)))
          g (tonumber (.. :0x (hex:sub 4 5)))
          b (tonumber (.. :0x (hex:sub 6 7)))]
      [r g b]))

  (fn mix-hex [c1 c2 i]
    (math.floor (/ (+ (* c1 (- max-1 i)) (* c2 i)) max-1)))

  (fn mix [rgb1 rgb2 i]
    (let [[r g b] (icollect [j _ (ipairs rgb1)]
                    (mix-hex (. rgb1 j) (. rgb2 j) i))]
      (values r g b)))

  (let [rgb1 (hex->rgb hex1)
        rgb2 (hex->rgb hex2)
        grads []]
    (for [i 0 max-1]
      (table.insert grads (rgb->hex (mix rgb1 rgb2 i))))
    grads))

(fn lightness-rgb [hex ratio]
  (fn rgb->hex [r g b]
    (string.format "#%02X%02X%02X" r g b))

  (fn hex->rgb [hex]
    (let [r (tonumber (.. :0x (hex:sub 2 3)))
          g (tonumber (.. :0x (hex:sub 4 5)))
          b (tonumber (.. :0x (hex:sub 6 7)))]
      [r g b]))

  (fn lightness-hex [c]
    (math.min (math.floor (* c ratio)) 255))

  (let [rgb (hex->rgb hex)
        [r g b] (icollect [_ c (ipairs rgb)]
                  (lightness-hex c))]
    (rgb->hex r g b)))

(fn generation-colors []
  (let [colors (. (require :dracula) :colors)
        colors (colors)
        dark-ratio 0.6
        light-ratio 1.2]
    (values [(lightness-rgb colors.red dark-ratio)
             (lightness-rgb colors.orange dark-ratio)
             (lightness-rgb colors.yellow dark-ratio)
             (lightness-rgb colors.green dark-ratio)
             (lightness-rgb colors.purple dark-ratio)
             (lightness-rgb colors.cyan dark-ratio)
             (lightness-rgb colors.pink dark-ratio)]
            [(lightness-rgb colors.red light-ratio)
             (lightness-rgb colors.orange light-ratio)
             (lightness-rgb colors.yellow light-ratio)
             (lightness-rgb colors.green light-ratio)
             (lightness-rgb colors.purple light-ratio)
             (lightness-rgb colors.cyan light-ratio)
             (lightness-rgb colors.pink light-ratio)]
            (gradients colors.purple colors.pink 8))))

(local dark-colors ["#993333"
                    "#996E40"
                    "#909654"
                    "#309649"
                    "#715895"
                    "#538B97"
                    "#994876"])

(local logo-colors ["#BD93F9"
                    "#C68FF1"
                    "#CF8BEA"
                    "#D987E3"
                    "#E284DB"
                    "#EC80D4"
                    "#F57CCD"
                    "#FF79C6"])

(fn config []
  (let [{: cmd :api {: nvim_create_augroup : nvim_create_autocmd}} vim
        {: setup : colors} (require :dracula)
        colors (colors)
        overrides {:FoldColumn {:fg colors.white}
                   :Visual {:fg colors.black :bg colors.white}
                   :GitSignsCurrentLineBlame {:fg colors.white}
                   :NvimTreeIndentMarker {:fg colors.white}
                   "@property" {:fg colors.green}
                   ;; Cursive
                   "@keyword" {:fg colors.pink :italic true}
                   "@keyword.operator" {:fg colors.pink :italic true}
                   "@keyword.function" {:fg colors.cyan :italic true}
                   "@repeat" {:fg colors.pink :italic true}
                   "@conditional" {:fg colors.pink :italic true}
                   "@include" {:fg colors.pink :italic true}
                   "@function.builtin" {:fg colors.cyan :italic true}
                   "@type.builtin" {:fg colors.cyan :italic true}
                   "@tag.attribute" {:fg colors.green :italic true}
                   "@property.css" {:fg colors.green :italic true}
                   :ConflictMarkerBegin {:bg :#2f7366}
                   :ConflictMarkerOurs {:bg :#2e5049}
                   :ConflictMarkerTheirs {:bg :#344f69}
                   :ConflictMarkerEnd {:bg :#2f628e}
                   :ConflictMarkerCommonAncestorsHunk {:bg :#754a81}}
        transparent {:Normal {:fg colors.fg}
                     :MoreMsg {:fg colors.purple}
                     :SignColumn {}
                     :NvimTreeNormal {:link :Normal}
                     :NvimTreeVertSplit {:fg colors.black}
                     :Pmenu {:fg colors.white}
                     :BufferLineFill {}
                     :NormalFloat {:link :Normal}
                     :TelescopeNormal {:link :Normal}
                     :CmpItemAbbrDeprecated {:fg colors.white}
                     :CmpItemAbbrMatch {:fg colors.cyan}}]
    (collect [i color (ipairs logo-colors) :into overrides]
      (values (.. :StartLogo i) {:fg color}))
    (collect [group settings (pairs transparent) :into overrides]
      (values group settings))
    (when vim.g.neovide
      (tset overrides :Normal nil))
    (setup {:italic_comment true : overrides})
    (cmd "colorscheme dracula")))

{: config}
