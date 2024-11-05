let run ?(timeout = 600) ?catch (module B : Bot.S) callback =
  let offset = ref 0 in

  let catch = Option.value catch ~default:raise in

  let handle_update (update : Tgbot_api.Types.Update.t) =
    offset := succ update.update_id;
    callback update.value
  in

  while%lwt true do
    let%lwt updates = B.get_updates ~offset:!offset ~timeout () in

    (* Handle all incoming updates in one time (async). *)
    List.iter
      (fun update -> Lwt.dont_wait (fun () -> handle_update update) catch)
      updates;

    Lwt.return_unit
  done
