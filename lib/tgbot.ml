module Bot = Bot
module Long_polling = Long_polling
module Dispatcher = Dispatcher
module Client = Client
module Logger = Logger

module type Dispr_with_bot_depend = functor (_ : Bot.S) -> Dispatcher.S

let run_long_polling ?timeout ?catch ~token (module D : Dispr_with_bot_depend) =
  let (module Bot) = Bot.make ~token in
  let module D = D (Bot) in
  let handler = Dispatcher.handler_of (module D) in
  Long_polling.run ?timeout ?catch (module Bot) handler
