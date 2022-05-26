open Ast
open List
open Printf
open Printer

let rec check_list_in_list (sl1 : symbol list) (sl2 : symbol list): bool =
  match sl1 with
  | [] -> true
  | (s::sl1s) -> if not(mem s sl2) then false else check_list_in_list sl1s sl2;;

let check_input_symbol (is : symbol option) (sl : symbol list) =
  match is with
  | None -> true
  | Some s -> if mem s sl then true else false;;

let rec check_transitions (ts : transitions) (d : declarations): bool =
  match ts with
  | [] -> true
  | (t::tss) ->
    if not(mem t.currentState d.states) then
      (printf "currentState"; false)
    else if not(check_input_symbol t.inputSymbol d.inputSymbols) then
      (printf "inputSymbol"; false)
    else if not(mem t.stackTop d.stackSymbols) then
      (printf "stackTop"; false)
    else if not(mem t.nextState d.states) then
      (printf "nextState"; false)
    else if not(check_list_in_list t.newStackTop d.stackSymbols) then
      (printf "newStackTop\n"; printf "%s\n" (as_string_symbol_list t.newStackTop);
      print_string (as_string_symbol_list d.stackSymbols); false)
    else check_transitions tss d;;

let is_correct_automaton (a : automaton) : bool =
  (*TODO: verifier s'il y a des doublons dans inputsymbols, ...*)
  (* check if initial state is in the list of states *)
  if not(mem a.declarations.initialState a.declarations.states) then
    (printf "initialState"; false)
  (* check if initial stack symbol is in the list of stack symbols *)
  else if not(mem a.declarations.initialStackSymbol a.declarations.stackSymbols) then
    (printf "initialStackSymbol"; false)
  (* check the transitions *)
  else check_transitions a.transitions a.declarations;;

let rec is_deterministic_automaton (transitions : transitions) : bool =
  let check_input_symbols (is1 : symbol option) (is2 : symbol option) : bool =
    match is1, is2 with
    | Some s1, Some s2 -> s1 = s2
    | _, _ -> true
  in let are_deterministic_transitions (t1 : transition) (t2 : transition) : bool =
    if (t1.currentState = t2.currentState && t1.stackTop = t2.stackTop && check_input_symbols t1.inputSymbol t2.inputSymbol) then
      if t1 = t2 then true
      else
        (printf "Automaton is non-deterministic because of these transitions : %s %s\n"
                (as_string_transition t1) (as_string_transition t2); false)
    else true
  in
  let rec check (t1 : transition) (ts : transitions) : bool =
    match ts with
    | [] -> true
    | t2::tss -> if are_deterministic_transitions t1 t2 then check t1 tss else false
  in match transitions with
  | [] -> true (* if the automaton has no transitions then it's deterministic *)
  | t::ts -> if check t ts then is_deterministic_automaton ts else false;;
