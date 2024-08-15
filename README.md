# TgBot

A modern framework for [Telegram Bot API](https://core.telegram.org/bots/api) written in multicore OCaml for more modern age.

> [!WARNING]
> The library is still being built and not ready to use yet!

#### Features

- Enough completed API
- Batteries-included (middlewares, sessions, etc)
- Parallelism out of the box
- Thoughtful documentation with examples

## Installation

> [!IMPORTANT]
> Only 64-bit systems are supported.

...

## Documentation

...

## Usage

### Echo bot

```ocaml
let echo_bot token =
  let open Tgbot.Bot in

  let echo_text ctx =
    ctx#answer @@ Printf.sprintf "echo: %s" ctx.message.text
  in

  bot ~token [ `OnText echo_text ]

let () =
  let pool = Domainslib.Task.setup_pool ~num_domains:2 () in
  Tgbot.run_polling ~pool @@ echo_bot (Sys.getenv "TOKEN")
```

## Contribution

...
