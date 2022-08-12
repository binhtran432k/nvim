(fn config []
  (let [{: setup} (require :Comment)]
    (setup {:pre_hook (fn [{: ctype : cmotion}]
                        (let [{:ctype {: block : line} :cmotion {: v : V}} (require :Comment.utils)
                              {: get_cursor_location
                               : get_visual_start_location} (require :ts_context_commentstring.utils)
                              {: calculate_commentstring} (require :ts_context_commentstring.internal)
                              location (if (= ctype block)
                                           (get_cursor_location)
                                           (or (= cmotion v) (= cmotion V))
                                           (get_visual_start_location))
                              key (if (= ctype line) :__default :__multiline)]
                          (calculate_commentstring {: key : location})))})))

{: config}
