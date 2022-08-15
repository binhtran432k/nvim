(local {:json {: schemas}} (require :schemastore))

{:settings {:json {:schemas (schemas) :validate {:enable true}}}}
