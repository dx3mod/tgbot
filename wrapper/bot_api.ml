open Cohttp_eio

type t = { client : Client.t; token : string }

exception Bad_request of string

let send_request ~decoder ?(max_size = 100_000) t uri =
  Eio.Switch.run @@ fun sw ->
  let resp, body = Client.post ~sw t.client (uri t) in
  match resp.status with
  | `OK ->
      (* TODO: maybe write own stream json decoder? *)
      Eio.Buf_read.(parse_exn take_all) body ~max_size
      |> Yojson.Safe.from_string |> Response.of_yojson decoder
  | _ -> failwith "not okay"

module U = struct
  let bot_api_base_uri = Uri.of_string "https://api.telegram.org/"

  let make_meth_uri t meth =
    Uri.with_path bot_api_base_uri (Printf.sprintf "bot%s/%s" t.token meth)

  let add_opt_query k v uri =
    Option.fold ~none:uri ~some:(fun v -> Uri.add_query_param uri (k, v)) v
end

module Methods = struct
  open U

  let get_me t = make_meth_uri t "getMe"

  let get_updates ?offset ?limit ?timeout t =
    make_meth_uri t "getUpdates"
    |> add_opt_query "offset" offset
    |> add_opt_query "limit" limit
    |> add_opt_query "timeout" timeout
end

module Types = Types
module Response = Response
