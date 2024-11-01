let run ?(timeout = 600) (module B : Bot.S) callback =
  let offset = ref 0 in

  let handle_update (update : Tgbot_api.Types.Update.t) =
    offset := succ update.update_id;
    callback update
  in

  while%lwt true do
    let%lwt updates = B.get_updates ~offset:!offset ~timeout () in

    Lwt_list.iter_p handle_update updates
  done
