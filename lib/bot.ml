module type S = sig
  open Tg_bot_api.Types

  val get_me : unit -> User.t

  val get_updates :
    ?max_size:int -> ?timeout:int -> ?offset:int -> unit -> Updates.t

  val send_message : chat_id:int -> string -> Light_message.t
end

module Make (E : Tg_bot_api.Env) = struct
  module Api = Tg_bot_api.Make (E)
  open Tg_bot_api.Types

  let get_me () =
    Api.send_request ~max_size:1000 ~decoder:User.t_of_yojson Api.Methods.get_me

  let get_updates ?(max_size = 1_000_000) ?timeout ?offset () =
    Api.send_request ~max_size ~decoder:Updates.t_of_yojson
    @@ Api.Methods.get_updates ~timeout ~offset ()

  let send_message ~chat_id text =
    Api.send_request
      ~max_size:(1000 + String.length text)
      ~decoder:Light_message.t_of_yojson
    @@ Api.Methods.send_message ~chat_id ~text
end
