open Tg_bot_api.Types

let on_text f = function
  | Update.Message message -> Some (f message)
  | _ -> None

let ( <|> ) ha hb (update : Update.value) =
  match ha update with Some () -> Some () | None -> hb update
