module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot_api.Types

  let on_message (message : Message.t) =
    Bot.send_message ~chat_id:message.chat.id message.text |> Lwt.ignore_result;
    Lwt.return_unit
end

let echo_bot () =
  let token = Sys.getenv "TOKEN" in
  Tgbot.run_long_polling ~token (module Dispr)

let () = Lwt_main.run @@ echo_bot ()
