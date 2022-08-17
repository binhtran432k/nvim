(fn config []
  (let [{: setup} (require :alpha)
        startify (require :alpha.themes.startify)]
    (setup startify.config)))

{: config}
