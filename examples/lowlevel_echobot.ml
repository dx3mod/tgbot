open Lwt.Infix
open Tgbot_api.Types

let token = Sys.getenv "TOKEN"

let echo_bot =
  let (module Bot) = Tgbot.Bot.make ~token in
  Tgbot.Long_polling.run (module Bot) @@ function
  | Update.Message message ->
      Bot.send_message ~chat_id:message.chat.id message.text >|= ignore
  | _ -> Lwt.return_unit

let () = Lwt_main.run echo_bot
