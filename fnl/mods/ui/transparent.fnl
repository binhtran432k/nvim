(fn config []
  (let [{: setup} (require :transparent)]
    (setup {:enable true
            :extra_groups [:NormalFloat
                           :NvimTreeNormal
                           :NvimTreeVertSplit
                           :TelescopeNormal
                           :BufferLineTabClose
                           :BufferlineBufferSelected
                           :BufferLineFill
                           :BufferLineBackground
                           :BufferLineSeparator
                           :BufferLineIndicatorSelected
                           :BufferLineCloseButton
                           :BufferLineCloseButtonSelected]
            :exclude {}})))

{: config}
