# TgBot

A modern framework for [Telegram Bot API](https://core.telegram.org/bots/api) written in multicore OCaml.

#### Features

- Enough completed API
- Batteries-included (middlewares, sessions, etc)
- Parallelism out of the box
- Thoughtful documentation with examples

## Installation

...

## Documentation

...

## Usage

### Echo bot

```ocaml
let echo_text ctx =
  ctx#answer ctx.message.text

let echo_bot ~token =
  let open Tgbot.Bot in
  bot ~token
  |> on F.text echo_text

let () =
  let token = Sys.getenv "TOKEN" in
  let pool = Domainslib.Task.setup_pool ~num_domains:2 () in
  Tgbot.run_polling echo_bot ~pool ~token
```

## Contribution

...
