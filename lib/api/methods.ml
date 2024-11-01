module Make (Args : sig
  val token : string
end) =
struct
  open Args

  let base_endpoint = Printf.sprintf "https://api.telegram.org/bot%s/" token
  let make_method meth = Uri.of_string @@ base_endpoint ^ meth

  let query_opt key value uri =
    Option.fold value ~none:uri ~some:(fun value ->
        Uri.add_query_param' uri (key, value))

  let get_me = make_method "getMe"

  let get_updates ~offset ~timeout =
    make_method "getUpdates"
    |> query_opt "offset" (Option.map string_of_int offset)
    |> query_opt "timeout" (Option.map string_of_int timeout)
end
