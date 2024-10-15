let token = Sys.getenv "TOKEN"

let () =
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->
  let (module Bot) = Tgbot.make_bot ~net:env#net ~token in

  let bot_user = Bot.get_me () in
  Format.printf "Bot %a\n" Tg_bot_api.Types.User.pp bot_user
