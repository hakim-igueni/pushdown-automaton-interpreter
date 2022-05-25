let channel = open_in (Sys.argv.(1))

let lexbuf = Lexing.from_channel channel 

let ast = Parser.automate Lexer.next_token lexbuf 

let _ = Printf.printf "Parse:\n\n%s\n" (Ast.as_string ast)


(* Pour vérifier si la lettre lue appartient à l'alphabet inputSymbols
let rec check_input ((input : char), (inputSymbols : Ast.inputSymbols)) : bool = 
  match inputSymbols with
  | [] -> false
  | (x::xs) -> if (x = input) then true else check_input (input, xs);;


(*Pour extraire la list des inputSymbols*)
let extract_inputSymbols (automate : Ast.automaton) : Ast.inputSymbols = 
  match automate with
  | (d, t) -> match d with 
    (is, inst, st, s1, s2) -> is;;


(*Pour extraire la list des transitions*)
let extract_transitions (automate : Ast.automaton) : Ast.transitions = 
  match automate with
  | (d, t) -> t;;


let inputSymbols = extract_inputSymbols ast;;
Printf.printf "Input symbols: %s\n" (Ast.as_string_symbol_list inputSymbols);;
Printf.printf "Checking input: %s\n" (if check_input ('x', inputSymbols) then "OK" else "FAIL") *)
    
  

    
