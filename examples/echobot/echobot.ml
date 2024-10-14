let handle_update (module Bot : Tgbot.Bot.S) (update : Tgbot.Api.Types.Update.t)
    =
  (match update.value with
  | Tgbot.Api.Types.Update.Message { text = Some text; chat; _ } ->
      Bot.send_message ~chat_id:chat.id ~text |> ignore
  | _ -> ());

  flush stdout

let () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->
  let (module Bot) = Tgbot.make_bot ~net:env#net ~token:(Sys.getenv "TOKEN") in

  Tgbot.Long_polling.run (module Bot) ~callback:(handle_update (module Bot))
