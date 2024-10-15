open Ppx_yojson_conv_lib.Yojson_conv

module User = struct
  type t = {
    id : int;
    is_bot : bool;
    first_name : string;
    last_name : string option; [@default None]
    username : string option; [@default None]
    language_code : string option; [@default None]
    is_premium : bool; [@default false]
    added_to_attachment_menu : bool; [@default false]
    can_join_groups : bool; [@default false]
    can_read_all_group_messages : bool; [@default false]
    supports_inline_queries : bool; [@default false]
    can_connect_to_business : bool; [@default false]
    has_main_web_app : bool; [@default false]
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module Chat = struct
  type kind = Private | Group | SuperGroup | Channel [@@deriving show]

  let kind_of_yojson : Yojson.Safe.t -> kind = function
    | `String "private" -> Private
    | `String "group" -> Group
    | `String "supergroup" -> SuperGroup
    | `String "channel" -> Channel
    | _ -> failwith "Types.Chat.kind"

  type t = {
    id : int;
    kind : kind; [@key "type"]
    title : string option; [@default None]
    username : string option; [@default None]
    first_name : string option; [@default None]
    last_name : string option; [@default None]
    all_members_are_administrators : bool; [@default false]
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module Location = struct
  type t = { longitude : float; latitude : float }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module Message = struct
  type t = {
    message_id : int;
    from : User.t option; [@default None]
    date : int;
    chat : Chat.t;
    forward_from : User.t option; [@default None]
    forward_date : int option; [@default None]
    reply_to_message : t option; [@default None]
    text : string; [@default ""]
    caption : string option; [@default None]
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
  (* TODO: implement all fields for message type  *)
end

module Light_message = struct
  type t = { message_id : int; date : int }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module InlineQuery = struct
  type t = {
    id : string;
    from : User.t;
    location : Location.t option; [@default None]
    query : string;
    offset : string;
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module ChosenInlineResult = struct
  type t = {
    result_id : string;
    from : User.t;
    location : Location.t option; [@default None]
    inline_message_id : string option; [@default None]
    query : string;
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module CallbackQuery = struct
  type t = {
    id : string;
    from : User.t;
    message : Message.t option; [@default None]
    inline_message_id : string option; [@default None]
    data : string;
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]
end

module Update = struct
  type raw = {
    update_id : int;
    message : Message.t option; [@default None]
    inline_query : InlineQuery.t option; [@default None]
    chosen_inline_result : ChosenInlineResult.t option; [@default None]
    callback_query : CallbackQuery.t option; [@default None]
  }
  [@@deriving of_yojson, show] [@@yojson.allow_extra_fields]

  type value =
    | Message of Message.t
    | InlineQuery of InlineQuery.t
    | ChosenInlineResult of ChosenInlineResult.t
    | CallbackQuery of CallbackQuery.t
  [@@deriving show]

  let value_of_raw raw =
    match raw with
    | { message = Some message; _ } -> Message message
    | { inline_query = Some inline_query; _ } -> InlineQuery inline_query
    | { chosen_inline_result = Some chosen_inline_result; _ } ->
        ChosenInlineResult chosen_inline_result
    | { callback_query = Some callback_query; _ } ->
        CallbackQuery callback_query
    | _ -> failwith "invalid Update.raw state"

  type t = { update_id : int; value : value } [@@deriving show]

  let t_of_yojson json =
    let raw = raw_of_yojson json in
    let value = value_of_raw raw in
    { update_id = raw.update_id; value }
end

module Updates = struct
  type t = Update.t list [@@deriving of_yojson, show]
end
