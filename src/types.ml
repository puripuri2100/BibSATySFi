
type value_type =
  | ValueString of string
  | ValueInt of int


type entry_type =
  | Article
  | Book
  | BookLet
  | Conference
  | InBook
  | Incollection
  | Inproceedings
  | Manual
  | Mastersthesis
  | Misc
  | Online
  | Phdthesis
  | Proceedings
  | Techreport
  | Unpublished

type data_title_type =
  | Address
  | Annote
  | Author
  | BookTitle
  | CrossRef
  | Chapter
  | Edition
  | Editor
  | Eprint
  | HowPublished
  | Institution
  | ISBN
  | Journal
  | Key
  | Month
  | Note
  | Number
  | Organization
  | Pages
  | Publisher
  | School
  | Series
  | Title
  | Type
  | URL
  | Volume
  | Year
  | TitleVar of string

type data_type =
  | Name of string
  | Value of data_title_type * value_type


type term = (entry_type * (data_type list)) list
