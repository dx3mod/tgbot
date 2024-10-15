let log_exn ?(throw = true) exn =
  (match exn with
  | Failure message -> Printf.eprintf "raised fatal error: %s\n" message
  | Tg_bot_api.Bad_response bad ->
      Printf.eprintf "raised bad response: %d, %s\n" bad.code bad.description
  | Tg_bot_api.Bad_response_status status ->
      Format.eprintf "raised bad response status: %a\n" Http.Status.pp status
  | e -> if throw then raise e);
  flush stderr
