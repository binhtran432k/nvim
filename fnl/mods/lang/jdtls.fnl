(fn config []
  (let [{:api {: nvim_create_autocmd}} vim
        {: start_or_attach} (require :jdtls)
        {: find_root : add_commands} (require :jdtls.setup)
        jdtls-lspconfig (. (require :lspconfig.server_configurations.jdtls)
                           :default_config)
        {: capabilities} (require :mods.lsp.lspconfig)
        filetypes [:java]
        conf {:cmd jdtls-lspconfig.cmd
              :filetypes [:java]
              :init_options jdtls-lspconfig.init_options
              :on_attach (add_commands)
              :capabilities (capabilities)
              :settings {:java {:configuration {:runtimes [{:name :JavaSE-1.8
                                                            :path :/usr/lib/jvm/java-8-openjdk}
                                                           {:name :JavaSE-11
                                                            :path :/usr/lib/jvm/java-11-openjdk}
                                                           {:name :JavaSE-17
                                                            :path :/usr/lib/jvm/java-17-openjdk}]}}}
              :root_dir (find_root [:.git
                                    :build.xml
                                    :pom.xml
                                    :settings.gradle
                                    :settings.gradle.kts
                                    :mvnw
                                    :gradlew
                                    :build.gradle
                                    :build.gradle.kts])
              :handlers jdtls-lspconfig.handlers}]
    (nvim_create_autocmd :FileType
                         {:pattern [:java] :callback #(start_or_attach conf)})))

{: config}
