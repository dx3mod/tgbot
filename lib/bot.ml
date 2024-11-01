module Make (Args : sig
  val token : string
end) =
struct
  module Methods = Tgbot_api.Methods.Make (Args)

  let get_me () =
    Client.send_request Tgbot_api.Types.User.t_of_yojson Methods.get_me
end
