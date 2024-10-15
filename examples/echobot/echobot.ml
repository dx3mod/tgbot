let token = Sys.getenv "TOKEN"

(* Your dispatcher for handling incoming updates. Has TgBot.Dispatcher.S signature. *)
module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot.Api.Types
  include Tgbot.Dispatcher.Default

  let on_message (msg : Message.t) =
    Bot.send_message ~chat_id:msg.chat.id msg.text |> ignore
end

let () =
  (* Eio runtime with TLS support. *)
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->
  (* Make client for your bot. *)
  let (module Bot) = Tgbot.make_bot ~net:env#net ~token in

  (* Make handler (Update.t -> unit function) from your dispatcher. *)
  let handler = Tgbot.Dispatcher.handler_of (module Dispr (Bot)) in

  (* Run an infinite loop to process incoming updates
     using the long polling method. *)
  Tgbot.Long_polling.run (module Bot) handler
