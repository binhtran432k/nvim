(local {: set-status : directory?} (require :helpers))
(local nvim-web-devicons (require :nvim-web-devicons))
(local {:button dashboard-button} (require :alpha.themes.dashboard))
(local insert table.insert)

(local cool
       (if vim.g.neovide
           ["███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗"
            "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║"
            "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║"
            "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║"
            "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║"
            "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝"]
           ["                                                                   "
            "      ████ ██████           █████      ██                    "
            "     ███████████             █████                            "
            "     █████████ ███████████████████ ███   ███████████  "
            "    █████████  ███    █████████████ █████ ██████████████  "
            "   █████████ ██████████ █████████ █████ █████ ████ █████  "
            " ███████████ ███    ███ █████████ █████ █████ ████ █████ "
            "██████  █████████████████████ ████ █████ █████ ████ ██████"]))

(fn extension [fname]
  (let [fmatch (fname:match "^.+(%..+)$")]
    (if (not= fmatch nil) (fmatch:sub 2) "")))

(fn icon [fname]
  (nvim-web-devicons.get_icon fname (extension fname) {:default true}))

(fn file-button [fname shortcut short-fname]
  (let [name (or short-fname fname)
        fname-start (name:match ".*[/\\]")
        (ico ico-hl) (icon fname)
        ico-txt (.. ico "  ")
        button (dashboard-button shortcut (.. ico-txt name)
                                 (.. "<cmd>e " fname :<cr>))]
    (let [button-hls []]
      (when ico-hl
        (insert button-hls [ico-hl 0 3]))
      (when (not= fname-start nil)
        (insert button-hls
                [:Comment
                 (length ico-txt)
                 (+ (length fname-start) (length ico-txt))]))
      (tset button.opts :hl button-hls))
    button))

(fn shortname [fname cwd target-width]
  (let [plenary_path (require :plenary.path)
        short-fname-by-vim (vim.fn.fnamemodify fname (if cwd ":." ":~"))]
    (if (< target-width (length short-fname-by-vim))
        (let [short-fname-by-plenary (-> (plenary_path.new short-fname-by-vim)
                                         (: :shorten 1 [-2 -1]))]
          (if (< target-width (length short-fname-by-plenary))
              (-> (plenary_path.new short-fname-by-vim)
                  (: :shorten 1 [-1]))
              short-fname-by-plenary))
        short-fname-by-vim)))

(fn mru [start cwd items-number opts]
  (let [default-mru-ignore [:gitcommit]
        default-mru-opts {:ignore (fn [path ext]
                                    (or (string.find path :COMMIT_EDITMSG)
                                        (vim.tbl_contains default-mru-ignore
                                                          ext)))}
        opts (or opts default-mru-opts)
        items-number (or items-number 9)
        {: startswith :fn {: filereadable} :v {: oldfiles}} vim
        opts-ignore opts.ignore
        special-shortcuts [:a :s :d]
        target-width 35
        olds []
        _ (icollect [_ file (ipairs oldfiles) :until (< items-number
                                                        (length olds)) :into olds]
            (let [cwd? (if (not cwd) true (startswith file cwd))
                  ignore? (if opts-ignore
                              (opts-ignore file (extension file))
                              false)]
              (if (and (= (filereadable file) 1) cwd? (not ignore?))
                  file)))
        tbl (icollect [i fname (ipairs olds)]
              (let [short-fname (shortname fname cwd target-width)
                    shortcut (if (<= i (length special-shortcuts))
                                 (. special-shortcuts i)
                                 (tostring (- (+ i start) 1
                                              (length special-shortcuts))))]
                (file-button fname (.. " " shortcut) short-fname)))]
    {:type :group :val tbl :opts {}}))

(fn header-chars []
  (let [headers [cool]]
    (. headers (math.random (length headers)))))

(fn header-color []
  (let [lines {}]
    (each [i line-chars (ipairs (header-chars))]
      (let [hi (.. :StartLogo i)
            line {:type :text
                  :val line-chars
                  :opts {:hl hi :shrink_margin false :position :center}}]
        (insert lines line)))
    {:type :group :val lines :opts {:position :center}}))

(fn autocmd []
  (let [{:api {: nvim_create_autocmd
               : nvim_buf_get_name
               : nvim_set_current_dir
               : nvim_get_current_buf
               : nvim_buf_delete}} vim]
    (fn run-alpha []
      (local buf (nvim_get_current_buf))
      (when (directory?)
        (nvim_set_current_dir (nvim_buf_get_name buf)))
      (vim.cmd :Alpha)
      (nvim_buf_delete buf {}))

    (nvim_create_autocmd :VimEnter {:callback run-alpha})
    (nvim_create_autocmd :User
                         {:pattern :AlphaReady :callback #(set-status 0 0 0)})
    (nvim_create_autocmd :BufUnload
                         {:callback (fn []
                                      (when (= vim.bo.filetype :alpha)
                                        (set-status 2 2 1)))})))

(fn config []
  (let [{: setup} (require :alpha)
        section-mru {:type :group
                     :val [{:type :text
                            :val "Recent files"
                            :opts {:hl :SpecialComment
                                   :shrink_margin false
                                   :position :center}}
                           {:type :padding :val 1}
                           {:type :group
                            :val (fn []
                                   [(mru 1 (vim.fn.getcwd) 9)])
                            :opts {:shrink_margin false}}]}
        buttons {:type :group
                 :val [{:type :text
                        :val "Quick links"
                        :opts {:hl :SpecialComment :position :center}}
                       {:type :padding :val 1}
                       (dashboard-button :f "  Find file"
                                         ":Telescope find_files <CR>")
                       (dashboard-button :F "  Find text"
                                         ":Telescope live_grep <CR>")
                       (dashboard-button :n "  New file"
                                         ":ene <BAR> startinsert <CR>")
                       (dashboard-button :c "  Configuration"
                                         ":e ~/.config/nvim/init.lua <CR>")
                       (dashboard-button :u "  Update plugins"
                                         ":PackerSync<CR>")
                       (dashboard-button :q "  Quit" ":qa<CR>")]
                 :position :center}]
    (setup {:layout [{:type :padding :val 2}
                     (header-color)
                     {:type :padding :val 2}
                     section-mru
                     {:type :padding :val 2}
                     buttons]
            :opts {:margin 0 :autostart false}})
    (autocmd)))

{: config}
