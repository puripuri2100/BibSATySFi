{
  open Parse_author
  open Error
}


let space = [' ' '\t']
let break = ['\n' '\r']
let nzdigit = ['1'-'9']
let digit = (nzdigit | "0")
let capital = ['A'-'Z']
let small = ['a'-'z']
let latin = (capital | small)
let identifier = latin+
let str = [^ ',' ' ']


rule lex = parse
  | space { lex lexbuf }
  | break { Lexing.new_line lexbuf; lex lexbuf }
  | "and" {And}
  | "," {Comma}
  | str+ as s {
    Str(s)
  }
  | eof {EOF}
  | _ as c {raise (UnidentifiedToken(String.make 1 c))}

