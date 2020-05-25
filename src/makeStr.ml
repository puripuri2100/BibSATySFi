open Types
open Error
open DataToStr
open HashTblData

let make_indent n =
  let rec sub n str =
    if n <= 0 then
      str
    else
      sub (n-1) (" "^str)
  in
  sub (n*2) ""


let show_satysfi_lst n lst =
  let indent = make_indent n in
  let rec sub lst str =
    match lst with
    | [] -> str
    | x::xs -> sub xs (indent^x^";\n"^str)
  in
  (make_indent (n-1))^"[\n" ^ sub lst "" ^ (make_indent (n-1)) ^ "]"


let get_data_name lst =
  let rec sub lst str_opt =
    match lst with
    | [] -> str_opt
    | (Value(_))::xs -> sub xs str_opt
    | (Name(str))::xs -> sub xs (Some(str))
  in
  match sub lst None with
  | None -> raise NoDataName
  | Some(v) -> v


let make_str (name, entry, data_lst) =
  let data_name_satysfi_str = "`"^name^"`" in
  let entry_str = DataToStr.entry_str entry in
  let hashtbl = HashTblData.make_tbl data_lst in
  let para_str = HashTblData.make_str entry hashtbl in
  "("^ data_name_satysfi_str ^ ", " ^ entry_str ^ "(\n"^ para_str ^"))"


let make_main_str bib_data_lst aux_data_lst_opt =
  let name_lst =
    bib_data_lst
    |> List.map (fun (entry,data_lst) -> (get_data_name data_lst,entry,data_lst)) 
  in
  let main_bib_data_lst =
    match aux_data_lst_opt with
    | None -> name_lst
    | Some(lst) -> (
      let f s_opt =
        match s_opt with
        | None -> []
        | Some(s) -> List.filter (fun (n,_,_) -> String.equal s n) name_lst
      in
      lst
      |> List.map f
      |> List.concat
    )
  in
  let str_lst =
    main_bib_data_lst
    |> List.map make_str
  in
  str_lst
  |> show_satysfi_lst 1

