open Ast
open Printer
open Printf

let rec caseType_to_string (ct : caseType) : string =
  match ct with
  | Top -> "top"
  | Next -> "next"
  | State -> "state"

and instruction_to_string (i: instruction) : string =
  match i with
  | Push s -> (sprintf "push %c" s)
  | Pop -> "pop"
  | Change s -> (sprintf "change %c" s)
  | Reject -> "reject"
  | Case c -> case_to_string c

and caseBody_to_string (cb : symbolInstruction list) : string =
  match cb with
  | [] -> ""
  | (s, i) :: rest ->
    sprintf "%c: %s\n" s (instruction_to_string i)

and case_to_string (c : case) : string =
  sprintf "begin case %s of\n%s end\n" (caseType_to_string c.caseType) (caseBody_to_string c.caseBody)

and print_program (p: program) (niv : int): unit =
  printf "\n\nProgram:\n\t";

  print_endline (case_to_string p);;

let print_automaton (a : automaton3) : unit =
  printf "Declarations:\n";
  printf "\tinputSymbols: %s\n" (as_string_symbol_list a.inputSymbols);
  printf "\tstackSymbols: %s\n" (as_string_symbol_list a.stackSymbols);
  printf "\tstates: %s\n" (as_string_symbol_list a.states);
  printf "\tinitialState: %s\n" (as_string_symbol a.initialState);
  printf "\tinitialStackSymbol: %s\n" (as_string_symbol a.initialStackSymbol);
  print_program a.program 0;;
