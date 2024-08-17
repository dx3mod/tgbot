open Cohttp_eio
open Types

module type Opts = sig
  val client : Client.t
  val token : string
  val endpoint : string
end

exception Bad_request of string

module type S = sig
  val send_request :
    decoder:(Yojson.Safe.t -> 'a Ppx_deriving_yojson_runtime.error_or) ->
    max_size:int ->
    Uri.t ->
    'a

  val get_me : unit -> User.t

  val get_updates :
    ?max_size:int ->
    ?offset:int ->
    ?limit:int ->
    ?timeout:int ->
    unit ->
    Updates.t

  val send_message : int -> string -> Message.t
end

module Make (O : Opts) : S = struct
  open O

  let endpoint = Uri.of_string endpoint

  let send_request ~decoder ~max_size endpoint =
    Eio.Switch.run @@ fun sw ->
    let resp, body = Client.post ~sw client endpoint in
    match resp.status with
    | `OK -> (
        (* TODO: maybe write own stream json decoder? *)
        let response =
          Eio.Buf_read.(parse_exn take_all) body ~max_size
          |> Yojson.Safe.from_string |> Response.of_yojson decoder
        in

        match response with
        | Ok result -> result
        | Error Response.{ code; description } ->
            raise (Bad_request (Printf.sprintf "%d: %s" code description)))
    | _ -> raise (Bad_request "no ok")

  module Builder = struct
    let method_endpoint meth =
      Uri.with_path endpoint (Printf.sprintf "bot%s/%s" token meth)

    let query_opt k v uri =
      Option.fold ~none:uri ~some:(fun v -> Uri.add_query_param' uri (k, v)) v

    let query k v uri = Uri.add_query_param' uri (k, v)
  end

  module Methods = struct
    open Builder

    let get_me = method_endpoint "getMe"

    let get_updates ?(offset = None) ?(limit = None) ?(timeout = None) () =
      method_endpoint "getUpdates"
      |> query_opt "offset" offset |> query_opt "limit" limit
      |> query_opt "timeout" timeout

    let send_message ?parse_mode ?disable_notification ?reply_to_message_id
        ?reply_markup ~chat_id ~text () =
      method_endpoint "sendMessage"
      |> query "chat_id" chat_id |> query "text" text
      |> query_opt "parse_mode" parse_mode
      |> query_opt "disable_notification" disable_notification
      |> query_opt "reply_to_message_id" reply_to_message_id
      |> query_opt "reply_markup" reply_markup
  end

  let get_me () =
    send_request ~decoder:Types.User.of_yojson ~max_size:1000 Methods.get_me

  let get_updates ?(max_size = 1_000_000) ?offset ?limit ?timeout () =
    let to_string o = Option.map string_of_int o in

    Methods.get_updates ~offset:(to_string offset) ~limit:(to_string limit)
      ~timeout:(to_string timeout) ()
    |> send_request ~max_size ~decoder:Types.Updates.of_yojson

  let send_message chat_id text =
    Methods.send_message ~chat_id:(string_of_int chat_id) ~text ()
    |> send_request ~max_size:1000 ~decoder:Types.Message.of_yojson
end

module Types = Types
module Response = Response
