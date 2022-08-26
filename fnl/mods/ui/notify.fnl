(local notify (require :notify))
(local {: defer_fn :lsp {: handlers : get_client_by_id}} vim)

(local client-notifs {})
(fn get-notif-data [client-id token]
  (when (not (. client-notifs client-id))
    (tset client-notifs client-id {}))
  (when (not (. (. client-notifs client-id) token))
    (tset (. client-notifs client-id) token {}))
  (. (. client-notifs client-id) token))

(local spinner-frames ["⣾" "⣽" "⣻" "⢿" "⡿" "⣟" "⣯" "⣷"])
(fn update-spinner [client-id token]
  (let [notif-data (get-notif-data client-id token)]
    (when notif-data.spinner
      (local new-spinner (% (+ notif-data.spinner 1) (length spinner-frames)))
      (set notif-data.spinner new-spinner)
      (set notif-data.notification
           (notify nil nil
                   {:hide_from_history true
                    :icon (. spinner-frames new-spinner)
                    :replace notif-data.notification}))
      (defer_fn (fn []
                  (update-spinner client-id token)) 100))))

(fn format-title [title client-name]
  (.. client-name (if (< 0 (length title)) (.. ": " title) "")))

(fn format-message [message percentage]
  (.. (if percentage (.. percentage "%\t") "") (or message "")))

(fn setup-lsp-status []
  (tset handlers :$/progress
        (fn [_ result ctx]
          (let [client-id ctx.client_id
                val result.value]
            (when (not val.kind)
              (lua "return "))
            (local notif-data (get-notif-data client-id result.token))
            (if (= val.kind :begin)
                (let [message (format-message val.message val.percentage)]
                  (set notif-data.notification
                       (notify message :info
                               {:title (format-title val.title
                                                     (. (get_client_by_id client-id)
                                                        :name))
                                :icon (. spinner-frames 1)
                                :timeout false
                                :hide_from_history false}))
                  (set notif-data.spinner 1)
                  (update-spinner client-id result.token))
                (and (= val.kind :report) notif-data)
                (set notif-data.notification
                     (notify (format-message val.message val.percentage) :info
                             {:replace notif-data.notification
                              :hide_from_history false}))
                (and (= val.kind :end) notif-data)
                (do
                  (set notif-data.notification
                       (notify (if val.message
                                   (format-message val.message)
                                   :Complete)
                               :info
                               {:icon ""
                                :replace notif-data.notification
                                :timeout 3000}))
                  (set notif-data.spinner nil)))))))

(fn setup-lsp-message []
  (tset handlers :window/showMessage
        (fn [_ {: message :type typ} {: client_id}]
          (let [{: name} (get_client_by_id client_id)
                lvl (. [:ERROR :WARN :INFO :DEBUG] typ)]
            (notify [message] lvl
                    {:title (.. "LSP | " name)
                     :timeout 10000
                     :keep #(or (= lvl :ERROR) (= lvl :WARN))})))))

(fn config []
  (notify.setup {:background_colour "#000000" :stages :static :level 0})
  (set vim.notify notify)
  (setup-lsp-status)
  (setup-lsp-message))

{: config}
