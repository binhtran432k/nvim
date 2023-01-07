(fn config []
  (let [ai (require :mini.ai)
        spec-pair ai.gen_spec.pair
        spec-ts ai.gen_spec.treesitter]
    (ai.setup {:custom_textobjects {"," (spec-pair "," "," {:type :greedy})
                                    :f (spec-ts {:a "@function.outer"
                                                 :i "@function.inner"})
                                    :o (spec-ts {:a "@conditional.outer"
                                                 :i "@conditional.inner"})
                                    :c (spec-ts {:a "@class.outer"
                                                 :i "@class.inner"})}
               :search_method :cover})))

{: config}
