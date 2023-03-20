open Sedlexing
open Parser
open Error
open Types

let lexeme = Sedlexing.Utf8.lexeme



let white_space = [%sedlex.regexp? ' ' | '\t']
let break = [%sedlex.regexp? '\r' | '\n' | "\r\n"]
let space = [%sedlex.regexp? white_space | break]
let nzdigit = [%sedlex.regexp? '1'..'9']
let digit = [%sedlex.regexp? nzdigit | '0']
let capital = [%sedlex.regexp? 'A'..'Z']
let small = [%sedlex.regexp? 'a'..'z']
let latin = [%sedlex.regexp? small | capital]
let accent_mark = [%sedlex.regexp? '\'' | '`' | '^' | 'v' | '~' | '=' | 'u' | '.' | '"']
let accent_latin = [%sedlex.regexp? 'u' | 'v' | 'H' | 'c' | 'd' | 'b']



let is_entry_mode = ref false



let rec lex_bib lexbuf =
  match%sedlex lexbuf with
  | '{' -> (
    let () = is_entry_mode := true in
    L_CURLY_BRACES
  )
  | space -> lex_bib lexbuf
  | '@', Plus latin -> (
    let s = lexeme lexbuf in
    let len = String.length s in
    let s = String.lowercase_ascii (String.sub s 1 (len - 1)) in
    match s with
    | "comment"       -> COMMENT_MODE
    | "preamble"      -> PREAMBLE_MODE
    | "string"        -> STRING_MODE

    | "article"       -> ENTRY_TYPE Article
    | "book"          -> ENTRY_TYPE Book
    | "booklet"       -> ENTRY_TYPE Booklet
    | "conference"    -> ENTRY_TYPE Conference
    | "inbook"        -> ENTRY_TYPE InBook
    | "incollection"  -> ENTRY_TYPE InCollection
    | "inproceedings" -> ENTRY_TYPE InProceedings
    | "manual"        -> ENTRY_TYPE Manual
    | "mastersthesis" -> ENTRY_TYPE MastersThesis
    | "misc"          -> ENTRY_TYPE Misc
    | "online"        -> ENTRY_TYPE Online
    | "phdthesis"     -> ENTRY_TYPE PhDThesis
    | "proceedings"   -> ENTRY_TYPE Proceedings
    | "techteport"    -> ENTRY_TYPE TechReport
    | "unpublished"   -> ENTRY_TYPE UnPublished
    | _               -> ENTRY_TYPE (OtherEntry s)
  )
  | eof -> EOF
  | any -> raise (UnidentifiedToken(lexeme lexbuf))
  | _ -> raise (UnidentifiedToken "")


and lex_entry lexbuf =
  match%sedlex lexbuf with
  | space -> lex_entry lexbuf
  | '}' -> (
    let () = is_entry_mode := false in
    R_CURLY_BRACES
  )
  | ',' -> COMMA
  | '=' -> EQUAL
  | '#' -> SHARP
  | digit | (nzdigit, Plus digit) -> VALUE([Int(lexbuf |> lexeme |> int_of_string)])
  | '"' -> (
    let buf = Buffer.create 128 in
    let slst = lex_string "\"" 0 [] buf lexbuf in
    VALUE(slst)
  )
  | '{' -> (
    let buf = Buffer.create 128 in
    let slst = lex_string "}" 0 [] buf lexbuf in
    VALUE(slst)
  )
  | any -> (
    let buf = Buffer.create 128 in
    let () = Buffer.add_string buf (lexeme lexbuf) in
    let s = lex_value buf lexbuf in
    STRING(s)
  )
  | _ -> raise (UnidentifiedToken "")


and lex_value buffer lexbuf =
  match%sedlex lexbuf with
  | space -> (
    let _ = Sedlexing.backtrack lexbuf in
    Buffer.contents buffer
  )
  | "," | "{" | "}" | "=" | "#" -> (
    let _ = Sedlexing.backtrack lexbuf in
    Buffer.contents buffer
  )
  | any -> (
    let () = Buffer.add_string buffer (lexeme lexbuf) in
    lex_value buffer lexbuf
  )
  | _ -> raise (UnidentifiedToken "")



and lex_string end_char depth str_lst buffer lexbuf =
  match%sedlex lexbuf with
  | "---" -> (
    let () = Buffer.add_string buffer "—" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "--" -> (
    let () = Buffer.add_string buffer "-" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\OE" -> (
    let () = Buffer.add_string buffer "Œ" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\oe" -> (
    let () = Buffer.add_string buffer "œ" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\AE" -> (
    let () = Buffer.add_string buffer "Æ" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\ae" -> (
    let () = Buffer.add_string buffer "æ" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\AA" -> (
    let () = Buffer.add_string buffer "Å" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\aa" -> (
    let () = Buffer.add_string buffer "å" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\O" -> (
    let () = Buffer.add_string buffer "Ø" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\o" -> (
    let () = Buffer.add_string buffer "ø" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\L" -> (
    let () = Buffer.add_string buffer "Ł" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\l" -> (
    let () = Buffer.add_string buffer "ł" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\ss" -> (
    let () = Buffer.add_string buffer "ß" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "?'" -> (
    let () = Buffer.add_string buffer "¿" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "!'" -> (
    let () = Buffer.add_string buffer "¡" in
    lex_string end_char depth str_lst buffer lexbuf
  )

  | '\\', accent_mark, latin -> (
    let s = lexeme lexbuf in
    let m = String.sub s 1 1 in
    let c = String.sub s 2 1 in
    let () = Buffer.add_string buffer (parse_accent m c) in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | '\\', accent_mark, '{', latin, '}' -> (
    let s = lexeme lexbuf in
    let m = String.sub s 1 1 in
    let c = String.sub s 3 1 in
    let () = Buffer.add_string buffer (parse_accent m c) in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | '\\', accent_latin, '{', latin, '}' -> (
    let s = lexeme lexbuf in
    let m = String.sub s 1 1 in
    let c = String.sub s 3 1 in
    let () = Buffer.add_string buffer (parse_accent m c) in
    lex_string end_char depth str_lst buffer lexbuf
  )

  | "\\&" -> (
    let () = Buffer.add_string buffer "&" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\{" -> (
    let () = Buffer.add_string buffer "{" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\\"" -> (
    let () = Buffer.add_string buffer "\"" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\\\" -> (
    let () = Buffer.add_string buffer "\\" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\$" -> (
    let () = Buffer.add_string buffer "$" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\_" -> (
    let () = Buffer.add_string buffer "_" in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | "\\%" -> (
    let () = Buffer.add_string buffer "%" in
    lex_string end_char depth str_lst buffer lexbuf
  )

  | '{' -> (
    if depth == 0 then
      let s = Buffer.contents buffer in
      let buf = Buffer.create 128 in
      lex_string end_char (depth + 1) ((Text s)::str_lst) buf lexbuf
    else
      lex_string end_char (depth + 1) str_lst buffer lexbuf
  )

  | '}' -> (
    if depth == 0 && String.equal "}" end_char then
      let s = Buffer.contents buffer in
      List.rev ((Text s)::str_lst)
    else if depth == 1 then
      let s = Buffer.contents buffer in
      let buf = Buffer.create 128 in
      lex_string end_char 0 ((RawText s)::str_lst) buf lexbuf
    else if depth > 1 then
      lex_string end_char (depth - 1) str_lst buffer lexbuf
    else if String.equal "}" end_char then
      raise (UnidentifiedToken "}")
    else
      let () = Buffer.add_string buffer "}" in
      lex_string end_char depth str_lst buffer lexbuf
  )

  | '"' -> (
    if depth == 0 && String.equal "\"" end_char then
      let s = Buffer.contents buffer in
      List.rev ((Text s)::str_lst)
    else if String.equal "\"" end_char then
      raise (UnidentifiedToken "\"")
    else
      let () = Buffer.add_string buffer "\"" in
      lex_string end_char depth str_lst buffer lexbuf
  )

  | any -> (
    let s = lexeme lexbuf in
    let () = Buffer.add_string buffer s in
    lex_string end_char depth str_lst buffer lexbuf
  )
  | _ -> raise (UnidentifiedToken "")


(* ref:
  - https://www.asahi-net.or.jp/~ax2s-kmtn/ref/character/latin_spec.html
  - https://pctool.net/2021/02/latex-alphabet-command
*)
and parse_accent m c =
  match (m, c) with
  | ("'", "A") -> "Á"
  | ("'", "a") -> "á"
  | ("'", "C") -> "Ć"
  | ("'", "c") -> "ć"
  | ("'", "E") -> "É"
  | ("'", "e") -> "é"
  | ("'", "I") -> "Í"
  | ("'", "i") -> "í"
  | ("'", "N") -> "Ń"
  | ("'", "n") -> "ń"
  | ("'", "O") -> "Ó"
  | ("'", "o") -> "ó"
  | ("'", "U") -> "Ú"
  | ("'", "u") -> "ú"
  | ("'", "S") -> "Ś"
  | ("'", "s") -> "ś"
  | ("'", "Y") -> "Ý"
  | ("'", "y") -> "ý"
  | ("'", "Z") -> "Ź"
  | ("'", "z") -> "ź"

  | (".", "I") -> "İ"
  | (".", "Z") -> "Ż"
  | (".", "z") -> "ż"

  | ("\"", "A") -> "Ä"
  | ("\"", "a") -> "ä"
  | ("\"", "O") -> "Ö"
  | ("\"", "o") -> "ö"
  | ("\"", "U") -> "Ü"
  | ("\"", "u") -> "ü"

  | ("`", "A") -> "À"
  | ("`", "a") -> "à"
  | ("`", "E") -> "È"
  | ("`", "e") -> "è"
  | ("`", "U") -> "Ù"
  | ("`", "u") -> "ù"

  | ("^", "A") -> "Â"
  | ("^", "a") -> "â"
  | ("^", "E") -> "Ê"
  | ("^", "e") -> "ê"
  | ("^", "I") -> "Î"
  | ("^", "i") -> "î"
  | ("^", "O") -> "Ô"
  | ("^", "o") -> "ô"
  | ("^", "U") -> "Û"
  | ("^", "u") -> "û"

  | ("c", "C") -> "Ç"
  | ("c", "c") -> "ç"
  | ("c", "S") -> "Ş"
  | ("c", "s") -> "ş"

  | ("~", "A") -> "Ã"
  | ("~", "a") -> "ã"
  | ("~", "E") -> "Ẽ"
  | ("~", "e") -> "ẽ"
  | ("~", "N") -> "Ñ"
  | ("~", "n") -> "ñ"
  | ("~", "O") -> "Õ"
  | ("~", "o") -> "õ"
  | ("~", "I") -> "Ĩ"
  | ("~", "i") -> "ĩ"
  | ("~", "U") -> "Ũ"
  | ("~", "u") -> "ũ"
  | ("~", "Y") -> "Ỹ"
  | ("~", "y") -> "ỹ"

  | ("=", "A") -> "Ā"
  | ("=", "a") -> "ā"
  | ("=", "E") -> "Ē"
  | ("=", "e") -> "ē"
  | ("=", "I") -> "Ī"
  | ("=", "i") -> "ī"
  | ("=", "O") -> "Ō"
  | ("=", "o") -> "ō"
  | ("=", "U") -> "Ū"
  | ("=", "u") -> "ū"

  | ("v", "A") -> "Ǎ"
  | ("v", "a") -> "ǎ"
  | ("v", "E") -> "Ě"
  | ("v", "e") -> "ě"
  | ("v", "I") -> "Ǐ"
  | ("v", "i") -> "ǐ"
  | ("v", "O") -> "Ǒ"
  | ("v", "o") -> "ǒ"
  | ("v", "U") -> "Ǔ"
  | ("v", "u") -> "ǔ"

  | ("H", "O") -> "Ő"
  | ("H", "o") -> "ő"
  | ("H", "U") -> "Ű"
  | ("H", "u") -> "ű"

  | ("u", "A") -> "Ă"
  | ("u", "a") -> "ă"
  | ("u", "G") -> "Ğ"
  | ("u", "g") -> "ğ"

  | _ -> raise (UnidentifiedToken "")


let lex lexbuf =
  if !is_entry_mode then
    lex_entry lexbuf
  else
    lex_bib lexbuf

