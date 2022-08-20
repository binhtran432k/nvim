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

{: directory? : directory-or-nil? : set-status}
