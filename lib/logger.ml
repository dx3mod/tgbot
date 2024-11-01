open Tgbot_api.Types

module Dev = struct
  let trigger = function
    | Update.Message message ->
        Lwt_fmt.printf "Message %a\n\n" Message.pp message
    | _ -> Lwt.return_unit
end
