open Types
open Hashtbl

val make_tbl : Types.data_type list -> (string, string) Hashtbl.t

val make_str : Types.entry_type -> (string, string) Hashtbl.t -> string
