let make_package_lst str lst =
  lst
  |> List.map (fun s -> "@"^str^": "^s)
  |> List.fold_left (fun s1 s2 -> s1^"\n"^s2) ""



let make_module_str (require_package_lst, import_package_lst) module_name str =
"@require: bibyfi/bibyfi\n" ^
make_package_lst "require" require_package_lst^
make_package_lst "import" import_package_lst^
"

module "^module_name^" :sig

  val bibs : (string * bibyfi-item) list

end = struct

let bibs =
"
^str^
"

end

"
