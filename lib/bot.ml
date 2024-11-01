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

  let get_me () =
    Client.send_request Tgbot_api.Types.User.t_of_yojson Methods.get_me

  let get_updates ?offset ?timeout () =
    Methods.get_updates ~offset ~timeout
    |> Client.send_request Tgbot_api.Types.Updates.t_of_yojson
end
