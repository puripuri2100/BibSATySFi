%{
  open Types

  type mode =
  | BibMode of Types.bib
  | StringMode of (string * Types.value list) list
  | CommentMode
  | PreambleMode
%}


%token EOF
%token <Types.entry_type> ENTRY_TYPE
%token <string> STRING
%token <Types.value list> VALUE
%token COMMENT_MODE PREAMBLE_MODE STRING_MODE
%token SHARP
%token COMMA
%token EQUAL
%token L_CURLY_BRACES
%token R_CURLY_BRACES


%start parse
%type <(Types.cite_key, Types.bib) Hashtbl.t * (string, Types.value list) Hashtbl.t> parse
%type <(Types.cite_key, Types.bib) Hashtbl.t * (string, Types.value list) Hashtbl.t> bibs
%type <mode> bib
%type <(string, value list) Hashtbl.t> entry_lst
%type <string * value list> entry
%type <(string * value list) list> def_lst
%type <Types.value list> values
%type <unit> dummy_entry

%%

parse:
  | bibs=bibs; EOF { bibs }
;

bibs:
  | bib=bib; bibs=bibs {
    match bib with
    | BibMode(bib) -> (
      let (bib_lst, dictionary) = bibs in
      let () = Hashtbl.add bib_lst bib.cite bib in
      (bib_lst, dictionary)
    )
    | StringMode(lst) -> (
      let (bib_lst, dictionary) = bibs in
      let rec sub lst =
        match lst with
        | [] -> ()
        | (key, value) :: xs -> (
          let () = Hashtbl.add dictionary key value in
          sub xs
        )
      in
      let () = sub lst in
      (bib_lst, dictionary)
    )
    | _ -> bibs
  }
  | {
      let bib_lst = Hashtbl.create 256 in
      let dictionary = Hashtbl.create 8 in
      (bib_lst, dictionary)
    }
;

bib:
  | entry_type=ENTRY_TYPE; L_CURLY_BRACES; cite_key=STRING; COMMA; entry_lst=entry_lst; R_CURLY_BRACES {
    BibMode {
      entry_type = entry_type;
      cite = cite_key;
      entry_lst = entry_lst;
    }
  }
  | STRING_MODE; L_CURLY_BRACES; def_lst=def_lst; R_CURLY_BRACES { StringMode def_lst }
  | COMMENT_MODE; L_CURLY_BRACES; list(dummy_entry); R_CURLY_BRACES { CommentMode }
  | PREAMBLE_MODE; L_CURLY_BRACES; list(dummy_entry); R_CURLY_BRACES { PreambleMode }
;

entry_lst:
  | {
    let lst = Hashtbl.create 16 in
    lst
  }
  | entry=entry {
    let (key, value) = entry in
    let lst = Hashtbl.create 16 in
    let () = Hashtbl.add lst (String.lowercase_ascii key) value in
    lst
  }
  | entry=entry; COMMA; entry_lst=entry_lst {
    let (key, value) = entry in
    let () = Hashtbl.add entry_lst (String.lowercase_ascii key) value in
    entry_lst
  }
;

entry:
  | key=STRING; EQUAL; value=values { (key, value) }
;


def_lst:
  | { [] }
  | key=STRING; EQUAL; value=values { [(key, value)] }
  | key=STRING; EQUAL; value=values; COMMA; def_lst=def_lst { (key, value)::def_lst }
;


values:
  | key=STRING { [DefText(key)] }
  | value=VALUE { value }
  | key=STRING; SHARP; values=values { (DefText key)::values }
  | v=VALUE; SHARP; values=values { List.append v values }
;


dummy_entry:
  | VALUE { () }
  | COMMA { () }
  | EQUAL { () }
  | STRING { () }
;


%%
