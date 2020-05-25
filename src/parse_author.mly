%{
%}

%token EOF
%token And
%token Comma

%token <string> Str

%start parse
%type <string list> parse

%%
parse :
  | author EOF { $1 }

author :
  | {[]}
  | str {[$1]}
  | str And author { $1 :: $3 }
  | str Comma author { $1 :: $3 }

str :
  | Str {$1}
  | Str str {$1 ^ " " ^ $2}

%%
