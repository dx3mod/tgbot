module type S = sig
  open Tgbot_api.Types

  val get_me : unit -> User.t Lwt.t
  val get_updates : ?offset:int -> ?timeout:int -> unit -> Updates.t Lwt.t
end

module Make (Args : sig
  val token : string
end) =
struct
  module Methods = Tgbot_api.Methods.Make (Args)
  open Tgbot_api.Types

  let get_me () = Client.send_request User.t_of_yojson Methods.get_me

  let get_updates ?offset ?timeout () =
    Methods.get_updates ~offset ~timeout
    |> Client.send_request Updates.t_of_yojson

  let send_message ~chat_id text =
    Methods.send_message ~chat_id ~text
    |> Client.send_request Light_message.t_of_yojson
end
