(fn config []
  (set vim.g.dracula_italic_comment true)
  (vim.cmd "syntax on | colorscheme dracula")
  (let [{: cmd :api {: nvim_create_augroup : nvim_create_autocmd}} vim
           colors ((. (require :dracula) :colors))
           dracula_colors [colors.red
                            colors.green
                            colors.yellow
                            colors.purple
                            colors.pink
                            colors.cyan
                            colors.white]
           callback (fn []
                      (each [i color (ipairs dracula_colors)]
                        (cmd (string.format
                               "highlight! rainbowcol%d guifg=%s"
                               i
                               color))))
           gid (nvim_create_augroup :custom_dracula_highlights {})]
    (nvim_create_autocmd :ColorScheme {: callback :group gid})
    (callback)))

{
: config
}
