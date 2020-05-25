open Types
open Lex_author
open Parse_author
open Lexing

val title_to_str : Types.data_title_type -> string

val entry_str : Types.entry_type -> string

val to_satysfi_str : string -> string

val to_satysfi_opt : (string -> string) -> string option -> string

val author_to_lst : (string -> string) -> string -> string

val pages_to_tuple : string -> string

val make_record : (string * string) list -> string

