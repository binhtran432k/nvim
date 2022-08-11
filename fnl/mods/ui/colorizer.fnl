(fn config []
  (let [{: setup} (require :colorizer)]
    (setup nil
           {:RGB true
           :RRGGBB true
           :RRGGBBAA true
           :rgb_fn true
           :hsl_fn true
           :css true
           :css_fn true})))

{
: config
}
