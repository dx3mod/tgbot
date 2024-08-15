open Cohttp_eio

type t = { client : Client.t; token : string }

exception Bad_request of string

let bot_api_base_uri = Uri.of_string "https://api.telegram.org/"

let make_meth_uri t meth =
  Uri.with_path bot_api_base_uri (Printf.sprintf "bot%s/%s" t.token meth)

let send_request ~decoder ?(max_size = 100_000) t uri =
  Eio.Switch.run @@ fun sw ->
  let resp, body = Client.post ~sw t.client (uri t) in
  match resp.status with
  | `OK ->
      (* maybe write own stream json decoder? *)
      Eio.Buf_read.(parse_exn take_all) body ~max_size
      |> Yojson.Safe.from_string |> Response.of_yojson decoder
  | _ -> failwith "not okay"

module Methods = struct
  let get_me t = make_meth_uri t "getMe"
end

module Types = Types
module Response = Response
