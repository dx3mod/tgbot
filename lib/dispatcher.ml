open Tgbot_api.Types

module type S = sig
  val on_message : Message.t -> unit Lwt.t
end

let handler_of (module R : S) = function
  | Update.Message message -> R.on_message message
  | _ -> failwith "not implement yet handing this update"
