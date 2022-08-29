(fn config []
  (let [{: setup} (require :nvim-lightbulb)]
    (setup {:sign {:priority 99} :autocmd {:enabled true}}))
  (vim.fn.sign_define :LightBulbSign
                      {:text "" :texthl "" :linehl "" :numhl ""}))

{: config}
