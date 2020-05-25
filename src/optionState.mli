val set_input_file : string -> unit
val input_file : unit -> string option

val set_output_file : string -> unit
val output_file : unit -> string option

val set_aux_file : string -> unit
val aux_file : unit -> string option

val set_module_name : string -> unit
val module_name : unit -> string option

val set_require_package_lst : string list -> unit
val require_package_lst : unit -> string list

val set_import_package_lst : string list -> unit
val import_package_lst : unit -> string list
