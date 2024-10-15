let run ?(timeout = 600) ?catch (module Api : Bot.S) callback =
  let offset = ref 0 in

  let catch = Option.value catch ~default:raise in

  Eio.Switch.run @@ fun sw ->
  while true do
    let updates = Api.get_updates ~timeout ~offset:!offset () in

    List.iter
      (fun (update : Tg_bot_api.Types.Update.t) ->
        offset := update.update_id + 1;
        Eio.Fiber.fork ~sw (fun () ->
            try callback update.value with e -> catch e))
      updates
  done
