module Bot = Tgbot.Bot.Make (struct
  let token = Sys.getenv "TOKEN"
end)

let () =
  Lwt_main.run
  @@ Tgbot.Long_polling.run
       (module Bot)
       (fun update ->
         Lwt_fmt.printf "Incoming update: %a\n" Tgbot_api.Types.Update.pp update)
