open Arg
open Lexing
open Filename

open OptionState
open Parser
open Lexer
open Types
open Error
open ModuleStr


let parse lexbuf =
  let () = is_entry_mode := false in
  let lexer () =
    let (ante_position, post_position) =
      Sedlexing.lexing_positions lexbuf
    in
    let token = Lexer.lex lexbuf in
    (token, ante_position, post_position)
  in
  let parser =
    MenhirLib.Convert.Simplified.traditional2revised Parser.parse
  in
  parser lexer


let arg_version () =
  print_string "bibsatysfi version 0.2.0\n";
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
    ("-v",                 Arg.Unit(arg_version),            "Prints version");
    ("--version",          Arg.Unit(arg_version),            "Prints version");
    ("-f",                 Arg.String (arg_input curdir),    "Specify Bib file");
    ("--file",             Arg.String (arg_input curdir),    "Specify Bib file");
    ("-o",                 Arg.String (arg_output curdir),   "Specify output file");
    ("--output",           Arg.String (arg_output curdir),   "Specify output file");
    ("--module-name",      Arg.String (arg_module_name),     "Specify Module name");
    ("--require-packages", Arg.String (arg_require_package), "Specify `@require` package");
    ("--import-packages",  Arg.String (arg_import_package),  "Specify `@import` package");
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
      | None -> basename ^ ".satyg"
    in
    let (bib_data, def_value_lst) =
      input_file_path |> open_in |> Sedlexing.Utf8.from_channel |> parse
    in
    let module_name =
      match OptionState.module_name () with
      | None -> "Bib"
      | Some(s) -> s
    in
    let package_lst = (OptionState.require_package_lst (), OptionState.import_package_lst ()) in
    let body_str_buf = Buffer.create 512 in
    let () = Hashtbl.iter (MakeStr.to_str body_str_buf def_value_lst) bib_data in
    let main_str = ModuleStr.make_module_str package_lst module_name (Buffer.contents body_str_buf) in
    let open_channel = open_out output_file_path in
    let () = Printf.fprintf open_channel "%s" main_str in
    let () = close_out open_channel in
    ()
  )
