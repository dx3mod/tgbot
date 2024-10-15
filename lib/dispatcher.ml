open Tg_bot_api.Types

module type S = sig
  val on_message : Message.t -> unit
end

module Default : S = struct
  let on_message _ = failwith "not implemented 'on_message' route"
end

module Routs = struct
  let command pat f msg =
    if Message.(msg.text = pat) then Some (f msg) else None

  let any_text f (msg : Message.t) = Some (f msg)

  let any xs u =
    let rec aux = function
      | [] -> ()
      | hd :: tl -> ( match hd u with Some () -> () | None -> aux tl)
    in
    aux xs

  let once f u = f u |> ignore
end

let handler_of (module Dispr : S) = function
  | Update.Message msg -> Dispr.on_message msg
  | _ -> failwith "not implemented for handle"
