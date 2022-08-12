(fn config []
  (let [parsers {:bibtex true
                :bash true
                :c true
                :c_sharp true
                :cpp true
                :css true
                :dockerfile true
                :dart true
                :fennel true
                :go true
                :haskell true
                :html true
                :java true
                :javascript true
                :jsdoc true
                :json true
                :json5 true
                :jsonc true
                :kotlin true
                :latex true
                :lua true
                :make true
                :markdown true
                :php true
                :python true
                :query true
                :ruby true
                :rust true
                :scss true
                :sql true
                :toml true
                :tsx true
                :typescript true
                :vim true
                :vue true
                :yaml true}
                ensures (icollect [parser enable? (pairs parsers)]
                          (if enable? parser))
                {: setup} (require :nvim-treesitter.configs)
                disable? (fn [lang bufnr]
                             (and
                               bufnr
                               (<
                                 5000
                                 (vim.api.nvim_buf_line_count bufnr))))]
    (setup {:ensure_installed ensures
           :sync_install false
           :ignore_install {}
           :highlight {:enable true
           :additional_vim_regex_highlighting false
           :disable disable?}
           :incremental_selection {:enable true
           :keymaps {:init_selection :<leader>ii
           :node_incremental :<leader>in
           :scope_incremental :<leader>is
           :node_decremental :<leader>ip}
           :disable disable?}
           :indent {:enable true
           :disable disable?}
           :autopairs {:enable true
           :disable disable?}
           :context_commentstring {:enable true
           :enable_autocmd false
           :disable disable?}
           :autotag {:enable true
           :disable disable?}
           :rainbow {:enable true
           :disable disable?}
           :playground {:enable true
           :disable disable?}
           :matchup {:enable true
           :disable disable?}
           :textobjects {:select {:enable true
           :disable disable?
           :lookahead true
           :keymaps {:af "@function.outer"
           :if "@function.inner"
           :ac "@class.outer"
           :ic "@class.inner"
           :ia "@parameter.inner"
           :aa "@parameter.outer"}}
           :move {:enable true
           :disable disable?
           :set_jumps true
           :goto_next_start {"]f" "@function.outer"
           "]c" "@class.outer"}
           :goto_next_end {"]F" "@function.outer" "]C" "@class.outer"}
           :goto_previous_start {"[f" "@function.outer"
           "[c" "@class.outer"}
           :goto_previous_end {"[F" "@function.outer"
           "[C" "@class.outer"}}}
           :refactor {:highlight_definitions {:enable true
           :disable disable?
           :clear_on_cursor_move false}
           :smart_rename {:enable true
           :disable disable?
           :keymaps {:smart_rename :<leader>rr}}}
           }))
  )

{
: config
}
