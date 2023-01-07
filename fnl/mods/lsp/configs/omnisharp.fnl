{:handlers {:textDocument/definition (let [{: handler} (require :omnisharp_extended)]
                                       handler)}
 :enable_roslyn_analyzers false
 :analyze_open_documents_only false
 :organize_imports_on_format true
 :enable_import_completion true}
