open Tgbot_api.Types

module type S = sig
  val on_message : Message.t -> unit Lwt.t
  val trigger : Update.value -> unit Lwt.t
end

module Defaults : S = struct
  let on_message _ = Lwt.return_unit
  let trigger _ = Lwt.return_unit
end

let handler_of (module R : S) update =
  Lwt.async (fun () -> R.trigger update);
  match update with
  | Update.Message message -> R.on_message message
  | _ -> failwith "not implement yet handing this update"
