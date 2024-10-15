# TgBot

A modern framework for [Telegram Bot API](https://core.telegram.org/bots/api) written in multicore OCaml and
built on [Eio] & [Cohttp] libraries.

> [!WARNING]
> The library is still being built and not ready to use yet!

<!-- > [!IMPORTANT]
> Only 64-bit systems are supported. -->

## Usage

See [examples](./examples/).

### Echo bot example

```ocaml
let token = Sys.getenv "TOKEN"

(* Your dispatcher for handling incoming updates. Has TgBot.Dispatcher.S signature. *)
module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot.Api.Types

  include Tgbot.Dispatcher.Default

  let on_message (msg : Message.t) =
    Bot.send_message ~chat_id:msg.chat.id msg.text 
    |> ignore
end

let () =
  (* Eio runtime with TLS support. *)
  Eio_main.run @@ fun env ->
  Mirage_crypto_rng_eio.run (module Mirage_crypto_rng.Fortuna) env @@ fun () ->

  (* Make client for your bot. *)
  let (module Bot) = Tgbot.make_bot ~net:env#net ~token in

  (* Make handler (Update.t -> unit function) from your dispatcher. *)
  let handler = Tgbot.Dispatcher.handler_of (module Dispr (Bot)) in

  (* Run an infinite loop to process incoming updates using the long polling method. *)
  Tgbot.Long_polling.run (module Bot) handler

```

```
$ dune exec ./examples/echobot.exe
```

## Contribution

Feel free to create issues and PRs.


[Eio]: https://github.com/ocaml-multicore/eio
[Cohttp]: https://github.com/mirage/ocaml-cohttp