type cite_key = string


type value =
  | Text of string
  | RawText of string
  | Int of int
  | DefText of string


type entry_type =
  | Article
  | Book
  | Booklet
  | Conference
  | InBook
  | InCollection
  | InProceedings
  | Manual
  | MastersThesis
  | Misc
  | Online
  | PhDThesis
  | Proceedings
  | TechReport
  | UnPublished
  | OtherEntry of string


type bib = {
  entry_type : entry_type;
  cite : cite_key;
  entry_lst : (string, (value list)) Hashtbl.t;
}

