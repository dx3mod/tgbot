module Make (Args : sig
  val token : string
end) =
struct
  open Args

  let base_endpoint = Printf.sprintf "https://api.telegram.org/bot%s/" token
  let make_method meth = Uri.of_string @@ base_endpoint ^ meth
  let get_me = make_method "getMe"
end
