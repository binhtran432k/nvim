(fn config []
  (let [{: setup} (require :project_nvim)]
    (setup {:detection_methods [:pattern :lsp]
            :patterns [:.git
                       :_darcs
                       :.hg
                       :.bzr
                       :.svn
                       :Makefile
                       :package.json
                       :*.sln
                       :build/env.sh]})))

{: config}
