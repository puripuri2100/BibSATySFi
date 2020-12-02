open Types
open Lex_author
open Parse_author
open Lexing

let title_to_str t =
  match t with
  | Address      -> "Address"
  | Annote       -> "Annote"
  | Author       -> "Author"
  | BookTitle    -> "BookTitle"
  | CrossRef     -> "CrossRef"
  | Chapter      -> "Chapter"
  | Edition      -> "Edition"
  | Editor       -> "Editor"
  | Eprint       -> "Eprint"
  | HowPublished -> "HowPublished"
  | Institution  -> "Institution"
  | ISBN         -> "ISBN"
  | Journal      -> "Journal"
  | Key          -> "Key"
  | Month        -> "Month"
  | Note         -> "Note"
  | Number       -> "Number"
  | Organization -> "Organization"
  | Pages        -> "Pages"
  | Publisher    -> "Publisher"
  | School       -> "School"
  | Series       -> "Series"
  | Title        -> "Title"
  | Type         -> "Type"
  | URL          -> "URL"
  | Volume       -> "Volume"
  | Year         -> "Year"
  | TitleVar(s)  -> s


let entry_str t =
  match t with
  | Article       -> "Article"
  | Book          -> "Book"
  | BookLet       -> "Booklet"
  | Conference    -> "Conference"
  | InBook        -> "InBook"
  | Incollection  -> "InCollection"
  | Inproceedings -> "InProceedings"
  | Manual        -> "Manual"
  | Mastersthesis -> "MastersThesis"
  | Misc          -> "Misc"
  | Online        -> "Online"
  | Phdthesis     -> "PhDThesis"
  | Proceedings   -> "Proceedings"
  | Techreport    -> "TechReport"
  | Unpublished   -> "Unpublished"


let to_satysfi_str s =
  "```" ^ s ^ "```"


let to_satysfi_opt f d_opt =
  match d_opt with
  | None -> "None"
  | Some(d) -> "Some(" ^ f d ^ ")"


let author_to_lst f s =
  let rec join b str lst =
    match lst with
    | [] -> str
    | x::xs ->
      if b then
        join false x xs
      else
        join false (str ^ ";" ^ x) xs
  in
  let str_lst =
    s |> Lexing.from_string |> Parse_author.parse Lex_author.lex
  in
  let main_s =
    str_lst
    |> List.map f
    |> join true ""
  in
  "[" ^ main_s ^ "]"


let pages_to_tuple s =
  let str_lst = String.split_on_char '-' s in
  let (f,s) =
    match str_lst with
    | [] -> ("","")
    | x::[] -> (x,x)
    | x::y::zs -> (x,y)
  in
  "(```" ^ f ^ "``` , ```" ^ s ^"```)"


let make_record lst =
  let join s1 s2 = s1 ^ "\n" ^ s2 in
  let f (name, value) = "    " ^ name ^ " = " ^ value ^ ";" in
  let main_s =
    lst
    |> List.map f
    |> List.fold_left join ""
  in
  "  (|" ^ main_s ^ "\n  |)"


