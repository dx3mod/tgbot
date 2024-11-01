(* Your incoming updates dispatcher. *)
module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot_api.Types
  open Lwt.Infix

  (* Incoming message handler. *)
  let on_message (message : Message.t) =
    Bot.send_message ~chat_id:message.chat.id message.text >|= ignore
end

let () =
  Lwt_main.run
  @@
  let token = Sys.getenv "TOKEN" in
  Tgbot.run_long_polling ~token (module Dispr)
