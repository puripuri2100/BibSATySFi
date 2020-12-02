%{
  open Types
%}

%token EOF
%token AtMark
%token Comma
%token Equal
%token LCurlyBraces
%token RCurlyBraces

%token <string>Var
%token <string>Str1
%token <string>Str2
%token <int>Int1

%token Article
%token Book
%token BookLet
%token Conference
%token InBook
%token Incollection
%token Inproceedings
%token Manual
%token Mastersthesis
%token Misc
%token Online
%token Phdthesis
%token Proceedings
%token Techreport
%token Unpublished

%token Address
%token Annote
%token Author
%token BookTitle
%token CrossRef
%token Chapter
%token Edition
%token Editor
%token Eprint
%token HowPublished
%token Institution
%token ISBN
%token Journal
%token Key
%token Month
%token Note
%token Number
%token Organization
%token Pages
%token Publisher
%token School
%token Series
%token Title
%token Type
%token URL
%token Volume
%token Year


%start parse
%type <Types.term> parse

%%
parse :
  | bib EOF { $1 }

bib :
  | {[]}
  | bib_child bib { $1 :: $2 }

bib_child :
  | AtMark entry LCurlyBraces data_list RCurlyBraces {($2, $4)}

entry :
  | Article       {Article}
  | Book          {Book}
  | BookLet       {BookLet}
  | Conference    {Conference}
  | InBook        {InBook}
  | Incollection  {Incollection}
  | Inproceedings {Inproceedings}
  | Manual        {Manual}
  | Mastersthesis {Mastersthesis}
  | Misc          {Misc}
  | Online        {Online}
  | Phdthesis     {Phdthesis}
  | Proceedings   {Proceedings}
  | Techreport    {Techreport}
  | Unpublished   {Unpublished}

data_list :
  | {[]}
  | data {[$1]}
  | data Comma data_list {$1::$3}

data :
  | name {Name($1)}
  | data_title Equal value {Value($1,$3)}

data_title:
  | Address      {Address}
  | Annote       {Annote}
  | Author       {Author}
  | BookTitle    {BookTitle}
  | CrossRef     {CrossRef}
  | Chapter      {Chapter}
  | Edition      {Edition}
  | Editor       {Editor}
  | Eprint       {Eprint}
  | HowPublished {HowPublished}
  | Institution  {Institution}
  | ISBN         {ISBN}
  | Journal      {Journal}
  | Key          {Key}
  | Month        {Month}
  | Note         {Note}
  | Number       {Number}
  | Organization {Organization}
  | Pages        {Pages}
  | Publisher    {Publisher}
  | School       {School}
  | Series       {Series}
  | Title        {Title}
  | Type         {Type}
  | URL          {URL}
  | Volume       {Volume}
  | Year         {Year}
  | Var          {TitleVar($1)}

name :
  | Str1 {$1}


value :
  | value_string {ValueString($1)}
  | value_int {ValueInt($1)}

value_string :
  | Str1 {$1}
  | LCurlyBraces Str2 RCurlyBraces {$2}

value_int :
  | Int1 {$1}
  | LCurlyBraces Int1 RCurlyBraces {$2}

%%
