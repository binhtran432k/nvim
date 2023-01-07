(let [util (require :lspconfig.util)
      notify-method #(vim.notify $3.method)
      root-files [:*.sln :*.csproj :node_modules/]
      primary-fn (util.root_pattern (unpack root-files))
      fallback-root-files [:Makefile :makefile :.git]
      fallback-fn (util.root_pattern (unpack fallback-root-files))]
  {:root_dir (fn [fname]
               (or (primary-fn fname) (fallback-fn fname)))
   :capabilities {:textDocument {:formatting true}}
   :handlers {:workspace/semanticTokens/refresh notify-method
              :workspace/diagnostic/refresh notify-method}
   :settings {:cucumber {:features [; Cucumber-JVM
                                    :src/test/**/*.feature
                                    ; Cucumber-Ruby Cucumber-Js, Behat, Behave
                                    :features/**/*.feature
                                    ; Pytest-BDD
                                    :tests/**/*.feature
                                    ; SpecFlow
                                    :*specs*/**/.feature
                                    :**/Features/**/*.feature
                                    :cypress/e2e/**/*.feature]
                         :glue [; Cucumber-JVM
                                :src/test/**/*.java
                                ; Cucumber-Js
                                :features/**/*.ts
                                :features/**/*.tsx
                                ; Behave
                                :features/**/*.php
                                ; Behat
                                :features/**/*.py
                                ; Pytest-BDD
                                :tests/**/*.py
                                ; Cucumber Rust
                                :tests/**/*.rs
                                :features/**/*.rs
                                ; Cucumber-Ruby
                                :features/**/*.rb
                                ; SpecFlow
                                :*specs*/**/.cs
                                :**/Steps/**/*.cs
                                "cypress/e2e/**/*{.js,.ts}"
                                "cypress/support/step_definitions/**/*{.js,.ts}"]}}})
