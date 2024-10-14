let run ?(timeout = 600) ~callback (module Api : Bot.S) =
  let offset = ref 0 in

  Eio.Switch.run @@ fun sw ->
  while true do
    let updates = Api.get_updates ~timeout ~offset:!offset () in

    List.iter
      (fun (update : Tg_bot_api.Types.Update.t) ->
        offset := update.update_id + 1;
        Eio.Fiber.fork ~sw (fun () -> callback update))
        (* try callback update with
           | Failure msg -> Eio.traceln "failure: %s" msg
           | Bot_api.Bad_request msg -> Eio.traceln "bad request: %s" msg
           | Bot_api.Response.Parse_error msg ->
               Eio.traceln "parse error: %s" msg)) *)
      updates
  done
