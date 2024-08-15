class context (api : Bot_api.t) =
  object (self)
    method private handle_response =
      function
      | Ok result -> result
      | Error Bot_api.Response.{ code; description } ->
          failwith @@ Printf.sprintf "bad request (%d): %s" code description

    method get_me =
      Bot_api.send_request ~decoder:Bot_api.Types.User.of_yojson ~max_size:1000
        api Bot_api.Methods.get_me
      |> self#handle_response
  end
