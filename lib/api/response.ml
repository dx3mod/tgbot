open Ppx_yojson_conv_lib.Yojson_conv

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

let of_yojson p json : 'a t =
  match raw_of_yojson p json with
  | { ok = true; result = Some result; _ } -> Ok result
  | { ok = false; error_code = Some error_code; description; _ } ->
      Error { code = error_code; description }
  (* | Error msg -> raise (Invalid_argument msg) *)
  | _ -> failwith "invalid response format state"

let get_value = function
  | Ok v -> v
  | Error { code; description } ->
      failwith @@ Printf.sprintf "bad response(%d): %s" code description
