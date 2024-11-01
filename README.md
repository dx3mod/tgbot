# TgBot

A framework for [Telegram Bot API](https://core.telegram.org/bots/api) written OCaml
 and built on [Lwt] and [Cohttp] libraries. 

## Usage

### Installation 

```console
$ opam pin https://github.com/dx3mod/tgbot.git
```

### Echo bot

```ocaml
(* Your incoming updates dispatcher. *)
module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot_api.Types
  open Lwt.Infix

  (* Incoming message handler. *)
  let on_message (message : Message.t) =
    Bot.send_message ~chat_id:message.chat.id message.text >|= ignore
end

let () =
  Lwt_main.run @@
  let token = "YOUR TOKEN" in
  Tgbot.run_long_polling ~token (module Dispr)
```

## Contribution

Feel free to create issues and PRs.

[Cohttp]: https://github.com/mirage/ocaml-cohttp
[Lwt]: https://github.com/ocsigen/lwt