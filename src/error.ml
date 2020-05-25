open Format

exception UnidentifiedToken of string
exception SeeEndOfFileInStringLiteral
exception NoInputFile
exception NoDataName
exception Parser_error

type t =
  | Lexer
  | Parser
  | Config
  | Option


let print_error (t:t) msg =
  let err_title =
    match t with
    | Lexer -> "Lexer"
    | Parser -> "Parser"
    | Config -> "Config"
    | Option -> "Option"
  in
  Printf.eprintf "![%s Error]\n%s\n" err_title msg


let error_msg t =
  try
    t ()
  with
    | UnidentifiedToken(s) -> print_error Lexer ("unidentified token '"^ s ^ "'")
    | SeeEndOfFileInStringLiteral -> print_error Lexer "unclosed string literal"
    | NoInputFile -> print_error Option "input file not found"
    | NoDataName -> print_error Config "no name"
