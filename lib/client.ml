exception Bad_response_status
exception Bad_response of Tgbot_api.Response.ok_false

let send_request decoder endpoint =
  let open Lwt.Infix in
  let%lwt resp, body = Cohttp_lwt_unix.Client.get endpoint in

  if resp.status == `OK then
    let%lwt response =
      Cohttp_lwt.Body.to_string body
      >|= Yojson.Safe.from_string
      >|= Tgbot_api.Response.of_yojson decoder
    in

    match response with
    | Ok response -> Lwt.return response
    | Error bad -> Lwt.fail (Bad_response bad)
  else Lwt.fail Bad_response_status
