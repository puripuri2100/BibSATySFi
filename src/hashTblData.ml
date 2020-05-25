open Hashtbl
open DataToStr
open Types
open Error

(*
module Hashtbl = Hashtbl.Make
  (struct
    type t = string
    let equal = String.equal
    let hash = Hashtbl.hash
  end)
*)

let make_tbl lst =
  let hash = Hashtbl.create 10 in
  let f x =
    match x with
    | Name(_) -> ()
    | Value(t,v) ->
      let str_v =
        match v with
        | ValueString(s) -> s
        | ValueInt(n) -> string_of_int n
      in
      Hashtbl.add hash (DataToStr.title_to_str t) str_v
  in
  let () = List.iter f lst in
  hash


let article_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let journal =
    Hashtbl.find tbl "Journal"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let pages =
    Hashtbl.find tbl "Pages"
    |> DataToStr.pages_to_tuple
  in
  let volume =
    Hashtbl.find_opt tbl "Volume"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let number =
    Hashtbl.find_opt tbl "Number"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("journal", journal);
    ("year", year);
    ("pages", pages);
    ("volume", volume);
    ("number", number);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let book_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let publisher =
    Hashtbl.find tbl "Publisher"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let volume =
    Hashtbl.find_opt tbl "Volume"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let series =
    Hashtbl.find_opt tbl "Series"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let edition =
    Hashtbl.find_opt tbl "Edition"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("publisher", publisher);
    ("year", year);
    ("volume", volume);
    ("series", series);
    ("address", address);
    ("edition", edition);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let booklet_str tbl =
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let author =
    Hashtbl.find_opt tbl "Author"
    |> DataToStr.to_satysfi_opt (DataToStr.author_to_lst DataToStr.to_satysfi_str)
  in
  let howpublished =
    Hashtbl.find_opt tbl "Howpublished"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find_opt tbl "Year"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("title", title);
    ("author", author);
    ("howpublished", howpublished);
    ("address", address);
    ("year", year);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let incollection_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let booktitle =
    Hashtbl.find tbl "BookTitle"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let editor =
    Hashtbl.find_opt tbl "Editor"
    |> DataToStr.to_satysfi_opt (DataToStr.author_to_lst DataToStr.to_satysfi_str)
  in
  let pages =
    Hashtbl.find tbl "Pages"
    |> DataToStr.pages_to_tuple
  in
  let organization =
    Hashtbl.find_opt tbl "Organization"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let publisher =
    Hashtbl.find_opt tbl "Publisher"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("booktitle", booktitle);
    ("year", year);
    ("editor", editor);
    ("pages", pages);
    ("organization", organization);
    ("publisher", publisher);
    ("address", address);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let inproceedings_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let booktitle =
    Hashtbl.find tbl "BookTitle"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let editor =
    Hashtbl.find_opt tbl "Editor"
    |> DataToStr.to_satysfi_opt (DataToStr.author_to_lst DataToStr.to_satysfi_str)
  in
  let pages =
    Hashtbl.find_opt tbl "Pages"
    |> DataToStr.to_satysfi_opt DataToStr.pages_to_tuple
  in
  let organization =
    Hashtbl.find_opt tbl "Organization"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let publisher =
    Hashtbl.find_opt tbl "Publisher"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("booktitle", booktitle);
    ("year", year);
    ("editor", editor);
    ("pages", pages);
    ("organization", organization);
    ("publisher", publisher);
    ("address", address);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let proceedings_str tbl =
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let editor =
    Hashtbl.find_opt tbl "Editor"
    |> DataToStr.to_satysfi_opt (DataToStr.author_to_lst DataToStr.to_satysfi_str)
  in
  let organization =
    Hashtbl.find_opt tbl "Organization"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let publisher =
    Hashtbl.find_opt tbl "Publisher"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("title", title);
    ("year", year);
    ("editor", editor);
    ("organization", organization);
    ("publisher", publisher);
    ("address", address);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let manual_str tbl =
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let author =
    Hashtbl.find_opt tbl "Author"
    |> DataToStr.to_satysfi_opt (DataToStr.author_to_lst DataToStr.to_satysfi_str)
  in
  let organization =
    Hashtbl.find_opt tbl "Organization"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let edition =
    Hashtbl.find_opt tbl "Edition"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find_opt tbl "Year"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("title", title);
    ("author", author);
    ("organization", organization);
    ("address", address);
    ("edition", edition);
    ("month", month);
    ("year", year);
    ("note", note);
    ("key", key);
  ]


let masterthesis_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let school =
    Hashtbl.find tbl "School"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("school", school);
    ("year", year);
    ("address", address);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let phdthesis_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let school =
    Hashtbl.find tbl "School"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("school", school);
    ("year", year);
    ("address", address);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let techreport_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let institution =
    Hashtbl.find tbl "Institution"
    |> DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find tbl "Year"
    |> DataToStr.to_satysfi_str
  in
  let typeof =
    Hashtbl.find_opt tbl "Typeof"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let number =
    Hashtbl.find_opt tbl "Number"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let address =
    Hashtbl.find_opt tbl "Address"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("institution", institution);
    ("year", year);
    ("typeof", typeof);
    ("number", number);
    ("address", address);
    ("month", month);
    ("note", note);
    ("key", key);
  ]


let misc_str tbl =
  let author =
    Hashtbl.find_opt tbl "Author"
    |> DataToStr.to_satysfi_opt (DataToStr.author_to_lst DataToStr.to_satysfi_str)
  in
  let title =
    Hashtbl.find_opt tbl "Title"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let howpublished =
    Hashtbl.find_opt tbl "Howpublished"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find_opt tbl "Year"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find_opt tbl "Note"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("howpublished", howpublished);
    ("month", month);
    ("year", year);
    ("note", note);
    ("key", key);
  ]


let unpublished_str tbl =
  let author =
    Hashtbl.find tbl "Author"
    |> DataToStr.author_to_lst DataToStr.to_satysfi_str
  in
  let title =
    Hashtbl.find tbl "Title"
    |> DataToStr.to_satysfi_str
  in
  let note =
    Hashtbl.find tbl "Note"
    |> DataToStr.to_satysfi_str
  in
  let month =
    Hashtbl.find_opt tbl "Month"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let year =
    Hashtbl.find_opt tbl "Year"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  let key =
    Hashtbl.find_opt tbl "Key"
    |> DataToStr.to_satysfi_opt DataToStr.to_satysfi_str
  in
  DataToStr.make_record [
    ("author", author);
    ("title", title);
    ("note", note);
    ("month", month);
    ("year", year);
    ("key", key);
  ]


let make_str entry tbl=
  match entry with
  | Article       -> article_str tbl
  | Book          -> book_str tbl
  | BookLet       -> booklet_str tbl
  | Conference    -> ""
  | InBook        -> ""
  | Incollection  -> incollection_str tbl
  | Inproceedings -> inproceedings_str tbl
  | Manual        -> manual_str tbl
  | Mastersthesis -> masterthesis_str tbl
  | Misc          -> misc_str tbl
  | Online        -> ""
  | Phdthesis     -> phdthesis_str tbl
  | Proceedings   -> proceedings_str tbl
  | Techreport    -> techreport_str tbl
  | Unpublished   -> unpublished_str tbl
