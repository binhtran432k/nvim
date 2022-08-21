(fn setup []
  (let [g vim.g]
    (tset g "conjure#mapping#doc_word" :K)
    (tset g "conjure#completion#omnifunc" false)))

{: setup}
