# TgBot

A framework for [Telegram Bot API](https://core.telegram.org/bots/api) written OCaml
 and built on [Lwt] & [Cohttp] libraries. 

## Usage

### Installation 

You can [pin][opam-pin] the upstream version of the library using the [OPAM] package manager.
```console
$ opam pin https://github.com/dx3mod/tgbot.git
```

### Echo bot

Typical bot example	&mdash; "echo bot" sending your message back.
Taken from [examples/echobot.ml](./examples/echobot.ml).

```ocaml
(* Your incoming updates dispatcher. *)
module Dispr (Bot : Tgbot.Bot.S) = struct
  open Tgbot_api.Types
  open Lwt.Infix

  include Tgbot.Dispatcher.Plugs
  include Tgbot.Logger.Dev (* log incoming messages *)

  (* Incoming message handler. *)
  let on_message (message : Message.t) =
    Bot.send_message ~chat_id:message.chat.id message.text >|= ignore
end

let () =
  Lwt_main.run @@
  let token = "YOUR TOKEN" in
  Tgbot.run_long_polling ~token (module Dispr)
```

In the example we use high-level abstraction for handling incoming messages by [dispatcher pattern][dispr-pat]. You can find a more low-level version of the example [here](./examples/lowlevel_echobot.ml).

## Contribution

The is an open source project under the [MIT](./LICENSE) license. Contributions are very welcome!
Please be sure to read the [CONTRIBUTING.md](./CONTRIBUTING.md) before your first commit.


[Cohttp]: https://github.com/mirage/ocaml-cohttp
[Lwt]: https://github.com/ocsigen/lwt

[OPAM]: https://opam.ocaml.org/
[opam-pin]: https://opam.ocaml.org/doc/Usage.html#opam-pin

[dispr-pat]: https://www.researchgate.net/figure/Event-dispatcher-pattern_fig14_242378736