module Api = Tg_bot_api
module Bot = Bot
module Long_polling = Long_polling
module Dispatcher = Dispatcher

let make_env ~token ~net =
  let authenticator =
    match Ca_certs.authenticator () with
    | Ok x -> x
    | Error (`Msg m) ->
        Fmt.failwith "Failed to create system store X509 authenticator: %s" m
  in

  let https ~authenticator =
    let tls_config =
      match Tls.Config.client ~authenticator () with
      | Error (`Msg msg) -> failwith ("tls configuration problem: " ^ msg)
      | Ok tls_config -> tls_config
    in
    fun uri raw ->
      let host =
        Uri.host uri
        |> Option.map (fun x -> Domain_name.(host_exn (of_string_exn x)))
      in
      Tls_eio.client_of_flow ?host tls_config raw
  in

  let client =
    Cohttp_eio.Client.make ~https:(Some (https ~authenticator)) net
  in

  (module struct
    let token = token
    let endpoint = "https://api.telegram.org"
    let client = client
  end : Api.Env)

let make_bot ~token ~net =
  let module B = Bot.Make ((val make_env ~token ~net)) in
  (module B : Bot.S)
