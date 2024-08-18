let run ?(timeout = 600) ~api:(module Api : Bot_api.S) callback =
  let offset = ref 0 in
  let callback = callback (module Api : Bot_api.S) in

  Eio.Switch.run @@ fun sw ->
  while true do
    let updates = Api.get_updates ~offset:!offset ~timeout () in

    List.iter
      (fun (update : Bot_api.Types.Update.t) ->
        offset := update.update_id + 1;
        Eio.Fiber.fork ~sw (fun () ->
            try callback update with
            | Failure msg -> Eio.traceln "failure: %s" msg
            | Bot_api.Bad_request msg -> Eio.traceln "bad request: %s" msg
            | Bot_api.Response.Parse_error msg ->
                Eio.traceln "parse error: %s" msg))
      updates
  done
