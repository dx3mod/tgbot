type photo = [ `Url of string ]

module Media = struct
  type t = Photo of photo

  let to_json_string = function
    | Photo (`Url url) -> Printf.sprintf {|{"type":"photo","media":"%s"}|} url
end

module Make (Args : sig
  val token : string
end) =
struct
  open Args

  let base_endpoint = Printf.sprintf "https://api.telegram.org/bot%s/" token

  let make_method ?(query = []) meth =
    Uri.add_query_params' (Uri.of_string @@ base_endpoint ^ meth) query

  let query_opt key value uri =
    Option.fold value ~none:uri ~some:(fun value ->
        Uri.add_query_param' uri (key, value))

  let get_me = make_method "getMe"

  let get_updates ?offset ?timeout () =
    make_method "getUpdates"
    |> query_opt "offset" (Option.map string_of_int offset)
    |> query_opt "timeout" (Option.map string_of_int timeout)

  let send_message ~chat_id ~text =
    make_method "sendMessage"
      ~query:[ ("chat_id", string_of_int chat_id); ("text", text) ]

  let send_photo ~chat_id = function
    | `Url url ->
        make_method "sendPhoto"
          ~query:[ ("chat_id", string_of_int chat_id); ("photo", url) ]

  let send_media_group ~chat_id medias =
    let objects = List.map Media.to_json_string medias |> String.concat "," in
    make_method "sendMediaGroup"
      ~query:
        [
          ("chat_id", string_of_int chat_id);
          ("media", Printf.sprintf "[%s]" objects);
        ]

  let edit_message_text ~chat_id ~message_id ~text =
    make_method "editMessageText"
      ~query:
        [
          ("chat_id", string_of_int chat_id);
          ("message_id", string_of_int message_id);
          ("text", text);
        ]
end
