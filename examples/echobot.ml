(* Your incoming updates dispatcher. *)
module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot_api.Types

  (* Incoming message handler. *)
  let on_message (message : Message.t) =
    Bot.send_message ~chat_id:message.chat.id message.text |> Lwt.ignore_result;
    Lwt.return_unit
end

let () =
  Lwt_main.run
  @@
  let token = "YOUR TOKEN" in
  Tgbot.run_long_polling ~token (module Dispr)
