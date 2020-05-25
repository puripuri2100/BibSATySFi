open Arg
open Lexing
open Filename

open OptionState
open Parse
open Lex
open Types
open Error
open MakeStr
(*open ReadAux*)
open ModuleStr

let arg_version () =
  print_string "bib2saty version 0.1.0\n";
  exit 0


let arg_input curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_input_file path


let arg_output curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_output_file path


let arg_aux curdir s =
  let path =
    if Filename.is_relative s then
      Filename.concat curdir s
    else
      s
  in
  OptionState.set_aux_file path


let arg_module_name s =
  OptionState.set_module_name s


let arg_require_package str =
  let str_lst = String.split_on_char ',' str in
  OptionState.set_require_package_lst str_lst


let arg_import_package str =
  let str_lst = String.split_on_char ',' str in
  OptionState.set_import_package_lst str_lst


let arg_spec curdir =
  [
    ("-v",        Arg.Unit(arg_version)  , "Prints version");
    ("--version", Arg.Unit(arg_version)  , "Prints version");
    ("-f",     Arg.String (arg_input curdir), "Specify Bib file");
    ("--file", Arg.String (arg_input curdir), "Specify Bib file");
    ("-o",       Arg.String (arg_output curdir),  "Specify output file");
    ("--output", Arg.String (arg_output curdir), "Specify output file");
    ("-a",    Arg.String (arg_aux curdir),  "Specify AUX file");
(*    ("--aux", Arg.String (arg_aux curdir), "Specify AUX file");*)
    ("--module-name", Arg.String (arg_module_name), "Specify Module name");
    ("--require-packages", Arg.String (arg_require_package), "Specify `@require` package");
    ("--import-packages", Arg.String (arg_import_package), "Specify `@import` package");
  ]

 
let main =
  Error.error_msg (fun () ->
    let curdir = Sys.getcwd () in
    let () = Arg.parse (arg_spec curdir) (arg_input curdir) "" in

    let input_file_path =
      match OptionState.input_file () with
      | None    -> raise NoInputFile
      | Some(v) -> v
    in
    let basename =
      try Filename.chop_extension input_file_path with
      | Invalid_argument(_) -> input_file_path
    in
    let output_file_path =
      match OptionState.output_file () with
      | Some(v) -> v
      | None -> basename ^ ".satyh"
    in
    let bib_data_list =
      open_in input_file_path |> Lexing.from_channel |> Parse.parse Lex.lex
    in
(*
    let aux_data_lst_opt =
      match OptionState.aux_file () with
      | None -> None
      | Some(s) -> Some(s |> ReadAux.key_lst |> ReadAux.value_lst)
    in
*)
    let module_name =
      match OptionState.module_name () with
      | None -> "Bib"
      | Some(s) -> s
    in
    let package_lst = (OptionState.require_package_lst (), OptionState.import_package_lst ()) in
    let body_str = MakeStr.make_main_str bib_data_list None in
    let main_str = ModuleStr.make_module_str package_lst module_name body_str in
    let open_channel = open_out output_file_path in
    let () = Printf.fprintf open_channel "%s" main_str in
    let () = close_out open_channel in
    ()
  )
