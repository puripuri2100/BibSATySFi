open Types

let satysfi_string str =
  "``` " ^ str ^ " ```"


let pages_string str =
  let re = Str.regexp "—\\|-+\\|–\\|-+" in
  let lst = Str.split re str in
  "(" ^ (satysfi_string (List.nth lst 0)) ^ ", " ^ (satysfi_string (List.nth lst 1)) ^ ")"


let author_string str =
  let re1 = Str.regexp "and" in
  let re2 = Str.regexp ",\\s*" in
  let lst =
    str
    |> Str.split re1
    |> List.map (fun s -> (
      s
      |> Str.split re2
      |> List.map String.trim
      |> List.fold_left (fun s1 s2 -> s1 ^ " " ^ s2) ""
      |> String.trim
    ))
  in
  lst
  |> List.map satysfi_string
  |> fun l -> List.fold_right (fun s1 s2 -> s1 ^ "; " ^s2) l ""
  |> fun s -> "[" ^ s ^ "]"


let rec value_lst_to_string def_value_lst value_lst =
  value_lst
  |> List.map (fun value -> (
    match value with
    | Text(str) -> str
    | RawText(str) -> str
    | Int(n) -> string_of_int n
    | DefText(key) -> (
      match Hashtbl.find_opt def_value_lst key with
      | Some(values) -> value_lst_to_string def_value_lst values
      | None -> ""
    )
  ))
  |> List.fold_left (^) ""


let get_str_f f def_value_lst key entry_lst =
  Hashtbl.find entry_lst key
  |> value_lst_to_string def_value_lst
  |> f

let get_str_opt_f f def_value_lst key entry_lst =
  match Hashtbl.find_opt entry_lst key with
  | Some(values) -> (
    "Some("^(
    values
    |> value_lst_to_string def_value_lst
    |> f
    ) ^ ")"
  )
  | None -> "None"



let get_str = get_str_f satysfi_string
let get_str_opt = get_str_opt_f satysfi_string


let to_str buf def_value_lst cite_key bib =
  let s =
    match bib.entry_type with
    | Article -> (
      Printf.sprintf "  (%s, Article (|
    author       = %s;
    title        = %s;
    journal      = %s;
    year         = %s;
    pages        = %s;
    volume       = %s;
    number       = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title"   bib.entry_lst)
      (get_str def_value_lst "journal" bib.entry_lst)
      (get_str def_value_lst "year"    bib.entry_lst)
      (get_str_f pages_string def_value_lst "pages" bib.entry_lst)
      (get_str_opt def_value_lst "volume" bib.entry_lst)
      (get_str_opt def_value_lst "number" bib.entry_lst)
      (get_str_opt def_value_lst "month"  bib.entry_lst)
      (get_str_opt def_value_lst "note"   bib.entry_lst)
      (get_str_opt def_value_lst "key"    bib.entry_lst)
    )
    | Book -> (
      Printf.sprintf "  (%s, Book (|
    author       = %s;
    title        = %s;
    publisher    = %s;
    year         = %s;
    volume       = %s;
    series       = %s;
    address      = %s;
    edition      = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title"     bib.entry_lst)
      (get_str def_value_lst "publisher" bib.entry_lst)
      (get_str def_value_lst "year"      bib.entry_lst)
      (get_str_opt def_value_lst "volume"  bib.entry_lst)
      (get_str_opt def_value_lst "series"  bib.entry_lst)
      (get_str_opt def_value_lst "address" bib.entry_lst)
      (get_str_opt def_value_lst "edition" bib.entry_lst)
      (get_str_opt def_value_lst "month"   bib.entry_lst)
      (get_str_opt def_value_lst "note"    bib.entry_lst)
      (get_str_opt def_value_lst "key"     bib.entry_lst)
    )
    | Booklet -> (
      Printf.sprintf "  (%s, Booklet (|
    title        = %s;
    author       = %s;
    howpublished = %s;
    address      = %s;
    year         = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str def_value_lst "title" bib.entry_lst)
      (get_str_opt_f author_string def_value_lst "author" bib.entry_lst)
      (get_str_opt def_value_lst "howpublished"  bib.entry_lst)
      (get_str_opt def_value_lst "address"       bib.entry_lst)
      (get_str_opt def_value_lst "year"          bib.entry_lst)
      (get_str_opt def_value_lst "hmonth"        bib.entry_lst)
      (get_str_opt def_value_lst "note"          bib.entry_lst)
      (get_str_opt def_value_lst "key"           bib.entry_lst)
    )
    | InCollection -> (
      Printf.sprintf "  (%s, Incollection (|
    author       %s;
    title        %s;
    booktitle    %s;
    year         %s;
    editor       %s;
    pages        %s;
    organization %s;
    publisher    %s;
    address      %s;
    month        %s;
    note         %s;
    key          %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title"     bib.entry_lst)
      (get_str def_value_lst "booktitle" bib.entry_lst)
      (get_str def_value_lst "year"      bib.entry_lst)
      (get_str_opt_f author_string def_value_lst "editior" bib.entry_lst)
      (get_str_f pages_string def_value_lst "pages" bib.entry_lst)
      (get_str_opt def_value_lst "organization" bib.entry_lst)
      (get_str_opt def_value_lst "publisher"    bib.entry_lst)
      (get_str_opt def_value_lst "address"      bib.entry_lst)
      (get_str_opt def_value_lst "month"        bib.entry_lst)
      (get_str_opt def_value_lst "note"         bib.entry_lst)
      (get_str_opt def_value_lst "key"          bib.entry_lst)
    )
    | InProceedings -> (
      Printf.sprintf "  (%s, Inproceedings (|
    title        = %s;
    year         = %s;
    editor       = %s;
    publisher    = %s;
    organization = %s;
    address      = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str def_value_lst "title" bib.entry_lst)
      (get_str def_value_lst "year"  bib.entry_lst)
      (get_str_opt_f author_string def_value_lst "editior" bib.entry_lst)
      (get_str_opt def_value_lst "publisher"    bib.entry_lst)
      (get_str_opt def_value_lst "organization" bib.entry_lst)
      (get_str_opt def_value_lst "address"      bib.entry_lst)
      (get_str_opt def_value_lst "month"        bib.entry_lst)
      (get_str_opt def_value_lst "note"         bib.entry_lst)
      (get_str_opt def_value_lst "key"          bib.entry_lst)
    )
    | MastersThesis -> (
      Printf.sprintf "  (%s, Masterthesis (|
    author       = %s;
    title        = %s;
    school       = %s;
    year         = %s;
    address      = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title"  bib.entry_lst)
      (get_str def_value_lst "school" bib.entry_lst)
      (get_str def_value_lst "year"   bib.entry_lst)
      (get_str_opt def_value_lst "address" bib.entry_lst)
      (get_str_opt def_value_lst "month"   bib.entry_lst)
      (get_str_opt def_value_lst "note"    bib.entry_lst)
      (get_str_opt def_value_lst "key"     bib.entry_lst)
    )
    | PhDThesis -> (
      Printf.sprintf "  (%s, Phdthesis (|
    author       = %s;
    title        = %s;
    school       = %s;
    year         = %s;
    address      = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title"  bib.entry_lst)
      (get_str def_value_lst "school" bib.entry_lst)
      (get_str def_value_lst "year"   bib.entry_lst)
      (get_str_opt def_value_lst "address" bib.entry_lst)
      (get_str_opt def_value_lst "month"   bib.entry_lst)
      (get_str_opt def_value_lst "note"    bib.entry_lst)
      (get_str_opt def_value_lst "key"     bib.entry_lst)
    )
    | TechReport -> (
      Printf.sprintf "  (%s, Techreport (|
    author       = %s;
    title        = %s;
    institution  = %s;
    year         = %s;
    typeof       = %s;
    number       = %s;
    address      = %s;
    month        = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title"       bib.entry_lst)
      (get_str def_value_lst "institution" bib.entry_lst)
      (get_str def_value_lst "year"        bib.entry_lst)
      (get_str_opt def_value_lst "typeof"  bib.entry_lst)
      (get_str_opt def_value_lst "number"  bib.entry_lst)
      (get_str_opt def_value_lst "address" bib.entry_lst)
      (get_str_opt def_value_lst "month"   bib.entry_lst)
      (get_str_opt def_value_lst "note"    bib.entry_lst)
      (get_str_opt def_value_lst "key"     bib.entry_lst)
    )
    | Misc -> (
      Printf.sprintf "  (%s, Misc (|
    author       = %s;
    title        = %s;
    howpublished = %s;
    month        = %s;
    year         = %s;
    note         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_opt_f author_string def_value_lst "author" bib.entry_lst)
      (get_str_opt def_value_lst "title"        bib.entry_lst)
      (get_str_opt def_value_lst "howpublished" bib.entry_lst)
      (get_str_opt def_value_lst "month"        bib.entry_lst)
      (get_str_opt def_value_lst "year"         bib.entry_lst)
      (get_str_opt def_value_lst "note"         bib.entry_lst)
      (get_str_opt def_value_lst "key"          bib.entry_lst)
    )
    | UnPublished -> (
      Printf.sprintf "  (%s, Unpublished (|
    author       = %s;
    title        = %s;
    note         = %s;
    month        = %s;
    year         = %s;
    key          = %s;
  |));"
      (satysfi_string cite_key)
      (get_str_f author_string def_value_lst "author" bib.entry_lst)
      (get_str def_value_lst "title" bib.entry_lst)
      (get_str def_value_lst "note"  bib.entry_lst)
      (get_str_opt def_value_lst "month" bib.entry_lst)
      (get_str_opt def_value_lst "year"  bib.entry_lst)
      (get_str_opt def_value_lst "key"   bib.entry_lst)
    )
    | _ -> (
      let () = Printf.printf "No Supported Pattern : %s\n" cite_key in
      ""
    )
  in
  Buffer.add_string buf ("\n" ^ s ^ "\n")
