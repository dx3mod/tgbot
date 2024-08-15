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
  [@@deriving of_yojson, show]
end

module Chat = struct
  type t = {
    id : int;
    kind : kind; [@key "type"]
    title : string option; [@default None]
    username : string option; [@default None]
    first_name : string option; [@default None]
    last_name : string option; [@default None]
    all_members_are_administrators : bool; [@default false]
  }

  and kind =
    | Private [@name "private"]
    | Group [@name "group"]
    | SuperGroup [@name "supergroup"]
    | Channel [@name "channel"]
  [@@deriving of_yojson, show]
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
    text : string option; [@default None]
    caption : string option; [@default None]
  }
  [@@deriving of_yojson { strict = false }, show]
end

module Update = struct
  type t = { update_id : int; message : unit (* ... *) }
  [@@deriving of_yojson, show]
end
