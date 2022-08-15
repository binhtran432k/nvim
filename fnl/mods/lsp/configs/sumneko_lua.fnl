(let [neovim-parent-dir (vim.fn.resolve (vim.fn.stdpath :config))
      buffer-file-name (vim.fn.expand "%:p")]
  (if (= (string.sub buffer-file-name 1 (length neovim-parent-dir))
         neovim-parent-dir)
      ((. (require :lua-dev) :setup) {})
      {}))
