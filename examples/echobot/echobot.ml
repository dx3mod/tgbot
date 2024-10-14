open Tgbot.Api.Types

let echo (module Bot : Tgbot.Bot.S) (message : Message.t) =
  Bot.send_message ~chat_id:message.chat.id message.text

let () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->
  let (module Bot) = Tgbot.make_bot ~net:env#net ~token:(Sys.getenv "TOKEN") in

  Tgbot.Long_polling.run (module Bot)
  @@ Tgbot.Handler.on_text (echo (module Bot))
