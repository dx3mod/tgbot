type 'a raw = {
  ok : bool;
  description : string; [@default ""]
  result : 'a option; [@default None]
  error_code : int option; [@default None]
}
[@@deriving of_yojson]
(**  "As is" API response.  *)

type 'a t = ('a, ok_false) result [@@deriving show]
and ok_false = { code : int; description : string }

exception Parse_error of string
(** Rises on failure of JSON parsing. *)

let of_yojson p json : 'a t =
  match raw_of_yojson p json with
  | Ok { ok = true; result = Some result; _ } -> Ok result
  | Ok { ok = false; error_code = Some error_code; description; _ } ->
      Error { code = error_code; description }
  | Error msg -> raise (Parse_error msg)
  | _ -> failwith "invalid response format state"
