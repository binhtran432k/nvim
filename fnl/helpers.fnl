(fn directory? []
  (let [buf-path (vim.api.nvim_buf_get_name 0)]
    (= (vim.fn.isdirectory buf-path) 1)))

(fn directory-or-nil? []
  (let [buf-path (vim.api.nvim_buf_get_name 0)]
    (or (= buf-path "") (= (vim.fn.isdirectory buf-path) 1))))

(fn set-status [laststatus showtabline cmdheight]
  (let [{: go : opt} vim]
    (set go.laststatus laststatus)
    (set opt.showtabline showtabline)
    (set opt.cmdheight cmdheight)))

(fn auto-indent [opts]
  (local {: bo : b} vim)
  (local opts (require :user-config))

  (fn config [key default]
    (let [_lang (. opts :filetypes)
          _ft (if _lang (. _lang bo.filetype))
          ft_opt (if _ft (. _ft key))
          opt (. opts key)]
      (if ft_opt ft_opt
          opt opt
          default)))

  (fn default-indent []
    (if bo.expandtab
        (let [indent bo.shiftwidth]
          (if (= indent 0) (bo.tabstop) indent))
        0))

  (fn multiline? [line]
    (let [{:fn {: synIDattr : synIDtrans : synID}} vim
          syntax (-> line (synID 1 1) synIDtrans (synIDattr :name))]
      (or (= syntax :Comment) (= syntax :String))))

  (fn in? [x arr]
    (< 0 (length (icollect [_ v (ipairs arr)]
                   (if (= x v) 1)))))

  (fn detect []
    (let [{:api {: nvim_buf_get_lines : nvim_buf_line_count}} vim
          max (math.min (config :max 2048) (nvim_buf_line_count 0))
          widths (config :widths [2 4 8])
          multiline (config :multiline true)
          default (default-indent)]
      (var detected nil)
      (for [i 1 max :until (not= detected nil)]
        (let [line (. (nvim_buf_get_lines 0 (- i 1) i false) 1)
              space (string.match line "^[\t ]+")]
          (when (and space (not (and multiline (multiline? (+ i 1)))))
            (set detected
                 (if (string.match space "^\t") 0 (string.match space "^ +$")
                     (let [indent (length space)]
                       (if (in? indent widths) indent)))))))
      (when (and detected (not= detected default))
        (vim.notify (.. "Auto detect indent: "
                        (if (= detected 0) :tab
                            (string.format "space(%s)" (tostring detected)))))
        (if (= detected 0)
            (set bo.expandtab false)
            (do
              (set bo.expandtab true)
              (set bo.tabstop detected)
              (set bo.softtabstop detected)
              (set bo.shiftwidth detected))))))

  (when (not (and b.editorconfig b.editorconfig.indent_size
                  b.editorconfig.indent_style))
    (detect)))

{: directory? : directory-or-nil? : set-status : auto-indent}
