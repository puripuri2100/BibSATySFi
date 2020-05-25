{
  open Parse
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
let str = [^ ',' '"' '{' '}' '@' '=']


rule lex = parse
  | space { lex lexbuf }
  | break { Lexing.new_line lexbuf; lex lexbuf }
  | latin+ {
    let tokstr = Lexing.lexeme lexbuf in
    match tokstr with
    | "article"       -> Article
    | "Article"       -> Article
    | "book"          -> Book
    | "Book"          -> Book
    | "booklet"       -> BookLet
    | "Booklet"       -> BookLet
    | "BookLet"       -> BookLet
    | "conference"    -> Conference
    | "Conference"    -> Conference
    | "inbook"        -> InBook
    | "Inbook"        -> InBook
    | "InBook"        -> InBook
    | "incollection"  -> Incollection
    | "Incollection"  -> Incollection
    | "InCollection"  -> Incollection
    | "inproceedings" -> Inproceedings
    | "Inproceedings" -> Inproceedings
    | "InProceedings" -> Inproceedings
    | "manual"        -> Manual
    | "Manual"        -> Manual
    | "mastersthesis" -> Mastersthesis
    | "Mastersthesis" -> Mastersthesis
    | "misc"          -> Misc
    | "Misc"          -> Misc
    | "online"        -> Online
    | "Online"        -> Online
    | "phdthesis"     -> Phdthesis
    | "Phdthesis"     -> Phdthesis
    | "proceedings"   -> Proceedings
    | "Proceedings"   -> Proceedings
    | "techreport"    -> Techreport
    | "Techreport"    -> Techreport
    | "unpublished"   -> Unpublished
    | "Unpublished"   -> Unpublished

    | "address"       -> Address
    | "annote"        -> Annote
    | "author"        -> Author
    | "booktitle"     -> BookTitle
    | "crossref"      -> CrossRef
    | "chapter"       -> Chapter
    | "edition"       -> Edition
    | "editor"        -> Editor
    | "eprint"        -> Eprint
    | "howpublished"  -> HowPublished
    | "institution"   -> Institution
    | "isbn"          -> ISBN
    | "journal"       -> Journal
    | "key"           -> Key
    | "month"         -> Month
    | "note"          -> Note
    | "number"        -> Number
    | "organization"  -> Organization
    | "pages"         -> Pages
    | "publisher"     -> Publisher
    | "school"        -> School
    | "series"        -> Series
    | "title"         -> Title
    | "type"          -> Type
    | "url"           -> URL
    | "volume"        -> Volume
    | "year"          -> Year
    | _               -> raise (UnidentifiedToken(tokstr))
  }
  | digit+ {
    let tok = Lexing.lexeme lexbuf in
    Int1(int_of_string tok)
  }
  | "{" {LCurlyBraces}
  | "}" {RCurlyBraces}
  | "," {Comma}
  | "=" {Equal}
  | "@" {AtMark}
  | "\"" {
      let strbuf = Buffer.create 128 in
      let s = make_string strbuf lexbuf in
      Str1(s)
    }
  | eof {EOF}
  | _ as c {
    raise (UnidentifiedToken(String.make 1 c))
  }


and make_string strbuf = parse
  | "\""   { Buffer.contents strbuf }
  | eof    { raise SeeEndOfFileInStringLiteral }
  | _ as c { Buffer.add_char strbuf c; make_string strbuf lexbuf }
