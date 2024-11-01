open Lwt.Syntax

module Bot = Tgbot.Bot.Make (struct
  let token = Sys.getenv "TOKEN"
end)

let () =
  Lwt_main.run
  @@
  let* me = Bot.get_me () in
  Lwt_fmt.printf "Me : %a\n" Tgbot_api.Types.User.pp me
