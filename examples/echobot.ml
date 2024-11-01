module Bot = Tgbot.Bot.Make (struct
  let token = Sys.getenv "TOKEN"
end)

let () =
  Lwt_main.run
  @@ Tgbot.Long_polling.run
       (module Bot)
       (function
         | Tgbot_api.Types.Update.Message message ->
             Bot.send_message ~chat_id:message.chat.id message.text
             |> Lwt.ignore_result;
             Lwt.return_unit
         | _ -> Lwt.return_unit)
