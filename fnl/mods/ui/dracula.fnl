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
                   :TSProperty {:fg colors.green}
                   ;; Script12
                   :TSKeyword {:fg colors.pink :bold true :italic true}
                   :TSKeywordOperator {:fg colors.pink :bold true :italic true}
                   :TSKeywordFunction {:fg colors.cyan :bold true :italic true}
                   :TSRepeat {:fg colors.pink :bold true :italic true}
                   :TSConditional {:fg colors.pink :bold true :italic true}
                   :TSInclude {:fg colors.pink :bold true :italic true}
                   :TSFuncBuiltin {:fg colors.cyan :bold true :italic true}
                   :TSTypeBuiltin {:fg colors.cyan :bold true :italic true}
                   :TSTagAttribute {:fg colors.green :bold true :italic true}
                   :cssTSProperty {:fg colors.green :bold true :italic true}
                   ;; Hop
                   :HopNextKey {:fg colors.red :bold true}
                   :HopNextKey1 {:fg colors.green :bold true}
                   :HopNextKey2 {:fg dark-colors.green}
                   :HopUnmatched {:fg colors.comment
                                  :bg colors.bg
                                  :sp colors.comment}
                   :HopPreview {:fg colors.yellow :bold true}
                   :HopCursor {:link :Cursor}
                   ;; TreeHopper
                   :TSNodeUnmatched {:link :HopUnmatched}
                   :TSNodeKey {:link :HopNextKey}
                   ;; Notify
                   :NotifyERRORBorder {:fg dark-colors.red}
                   :NotifyWARNBorder {:fg dark-colors.yellow}
                   :NotifyINFOBorder {:fg dark-colors.green}
                   :NotifyDEBUGBorder {:fg dark-colors.white}
                   :NotifyTRACEBorder {:fg dark-colors.purple}
                   :NotifyERRORIcon {:link :NotifyERRORTitle}
                   :NotifyWARNIcon {:link :NotifyWARNTitle}
                   :NotifyINFOIcon {:link :NotifyINFOTitle}
                   :NotifyDEBUGIcon {:link :NotifyDEBUGTitle}
                   :NotifyTRACEIcon {:link :NotifyTRACETitle}
                   :NotifyERRORTitle {:fg colors.red}
                   :NotifyWARNTitle {:fg colors.yellow}
                   :NotifyINFOTitle {:fg colors.green}
                   :NotifyDEBUGTitle {:fg colors.white}
                   :NotifyTRACETitle {:fg colors.purple}}
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
    (setup {:italic_comment true : overrides})
    (cmd "colorscheme dracula")))

{: config}
