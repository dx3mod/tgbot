open Cohttp_eio
module Types = Types
module Response = Response

module type Env = sig
  val client : Client.t
  val token : string

  val endpoint : string
  (** Base endpoint  *)
end

exception Bad_response_status of Http.Status.t
exception Bad_response of Response.ok_false

module type S = sig end

module Make (E : Env) = struct
  let base_api_endpoint = Printf.sprintf "%s/bot%s/" E.endpoint E.token

  module Methods = struct
    let make_endpoint meth query =
      let uri = Uri.of_string @@ base_api_endpoint ^ meth in
      Uri.add_query_params' uri query

    let query_opt key value uri =
      Option.fold value ~none:uri ~some:(fun value ->
          Uri.add_query_param' uri (key, value))

    let get_me = make_endpoint "getMe" []

    let get_updates ~timeout ~offset () =
      make_endpoint "getUpdates" []
      |> query_opt "offset" (Option.map string_of_int offset)
      |> query_opt "timeout" (Option.map string_of_int timeout)

    let send_message ~chat_id ~text =
      make_endpoint "sendMessage"
        [ ("chat_id", string_of_int chat_id); ("text", text) ]
  end

  (** @raises Bad_response_status
      @raises Bad_response *)
  let send_request ~max_size ~decoder endpoint =
    Eio.Switch.run @@ fun sw ->
    let response, body = Client.get ~sw E.client endpoint in
    match response.status with
    | `OK -> (
        let body = Eio.Buf_read.(parse_exn take_all) ~max_size body in
        let response =
          Yojson.Safe.from_string body |> Response.of_yojson decoder
        in
        match response with
        | Ok v -> v
        | Error ok_false -> raise (Bad_response ok_false))
    | status -> raise (Bad_response_status status)
end
