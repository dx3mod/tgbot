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

module Location = struct
  type t = { longitude : float; latitude : float } [@@deriving of_yojson, show]
end

module Update = struct
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
    (* TODO: implement all fields for message type  *)
  end

  module InlineQuery = struct
    type t = {
      id : string;
      from : User.t;
      location : Location.t option; [@default None]
      query : string;
      offset : string;
    }
    [@@deriving of_yojson, show]
  end

  module ChosenInlineResult = struct
    type t = {
      result_id : string;
      from : User.t;
      location : Location.t option; [@default None]
      inline_message_id : string option; [@default None]
      query : string;
    }
    [@@deriving of_yojson, show]
  end

  module CallbackQuery = struct
    type t = {
      id : string;
      from : User.t;
      message : Message.t option; [@default None]
      inline_message_id : string option; [@default None]
      data : string;
    }
    [@@deriving of_yojson, show]
  end

  type raw = {
    update_id : int;
    message : Message.t option; [@default None]
    inline_query : InlineQuery.t option; [@default None]
    chosen_inline_result : ChosenInlineResult.t option; [@default None]
    callback_query : CallbackQuery.t option; [@default None]
  }
  [@@deriving of_yojson, show]

  and t = { update_id : int; value : value }

  and value =
    | Message of Message.t
    | InlineQuery of InlineQuery.t
    | ChosenInlineResult of ChosenInlineResult.t
    | CallbackQuery of CallbackQuery.t
end
