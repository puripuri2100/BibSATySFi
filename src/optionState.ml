
type state = {
  mutable input_file : string option;
  mutable output_file : string option;
  mutable aux_file : string option;
  mutable module_name : string option;
  mutable require_package_lst : string list;
  mutable import_package_lst : string list;
}


let state = {
  input_file  = None;
  output_file = None;
  aux_file    = None;
  module_name = None;
  require_package_lst = [];
  import_package_lst = [];
}

let set_input_file path = state.input_file <- Some(path)
let input_file () = state.input_file

let set_output_file path = state.output_file <- Some(path)
let output_file () = state.output_file

let set_aux_file path = state.aux_file <- Some(path)
let aux_file () = state.aux_file

let set_module_name name = state.module_name <- Some(name)
let module_name () = state.module_name

let set_require_package_lst lst = state.require_package_lst <- lst
let require_package_lst () = state.require_package_lst

let set_import_package_lst lst = state.import_package_lst <- lst
let import_package_lst () = state.import_package_lst
