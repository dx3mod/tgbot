module type S = sig
  open Tgbot_api.Types
  open Tgbot_api.Methods

  val get_me : unit -> User.t Lwt.t
  val get_updates : ?offset:int -> ?timeout:int -> unit -> Updates.t Lwt.t
  val send_message : chat_id:int -> string -> Light_message.t Lwt.t
  val send_photo : chat_id:int -> photo -> Light_message.t Lwt.t
  val send_media_group : chat_id:int -> Media.t list -> Light_message.ts Lwt.t
end

module Make (Args : sig
  val token : string
end) =
struct
  module Methods = Tgbot_api.Methods.Make (Args)
  open Tgbot_api.Types

  let get_me () = Client.send_request User.t_of_yojson Methods.get_me

  let get_updates ?offset ?timeout () =
    Methods.get_updates ?offset ?timeout ()
    |> Client.send_request Updates.t_of_yojson

  let send_message ~chat_id text =
    Methods.send_message ~chat_id ~text
    |> Client.send_request Light_message.t_of_yojson

  let send_photo ~chat_id photo =
    Methods.send_photo ~chat_id photo
    |> Client.send_request Light_message.t_of_yojson

  let send_media_group ~chat_id medias =
    Methods.send_media_group ~chat_id medias
    |> Client.send_request Light_message.ts_of_yojson

  let edit_message_text ~chat_id ~message_id text =
    Methods.edit_message_text ~chat_id ~message_id ~text
    |> Client.send_request Light_message.t_of_yojson
end

let make ~token =
  let module B = Make (struct
    let token = token
  end) in
  (module B : S)
