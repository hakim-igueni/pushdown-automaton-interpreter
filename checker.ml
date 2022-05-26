open Ast
open List
open String
open Printf
let check_automaton (a : automaton) : bool =
  if not(mem a.declarations.initialState a.declarations.states) then
    (printf "initialState"; false)
  else
    if not(mem a.declarations.initialStackSymbol a.declarations.stackSymbols) then
      (printf "initialStackSymbol"; false)
    else
     let rec check_transitions (ts : transitions) (d : declarations): bool =
      match ts with
      | [] -> true
      | (t::tss) ->
        if not(mem t.currentState d.states) then false
        else let check_input_symbol (is : symbol option) (sl : symbol list) =
          match is with
          | None -> true
          | Some s -> if mem s sl then true else false
        in if not(check_input_symbol t.inputSymbol d.inputSymbols) then
        (printf "inputSymbol"; false)
        else if not(mem t.stackTop d.stackSymbols) then
        (printf "stackTop"; false)
        else if not(mem t.nextState d.states) then
        (printf "nextState"; false)
        else
        let rec check_list_in_list (sl1 : symbol list) (sl2 : symbol list): bool =
          match sl1 with
          | [] -> true
          | (s::sl1s) ->
            if not(mem s sl2) then false
            else check_list_in_list sl1s sl2
          in if not(check_list_in_list t.newStackTop d.stackSymbols) then
            (printf "newStackTop\n";
            let rec print_list(sl : symbol list) =
              match sl with
              | [] -> ()
              | [s] -> printf "%s" (as_string_symbol s)
              | (s::sls) -> printf "%s," (as_string_symbol s);
              print_list sls
            in print_list t.newStackTop; print_newline(); print_list d.stackSymbols;
            false)
        else check_transitions tss d
      in check_transitions a.transitions a.declarations;;


(*TODO: verifier s'il y a des doublons dans inputsymbols, ...*)
let rec check_automaton_determinist (transitions : transitions) : bool =
  let check_input_symbols (is1 : symbol option) (is2 : symbol option) : bool =
    match is1, is2 with
    | Some s1, Some s2 -> s1 = s2
    | _, _ -> true
  in let check_two_transitions (t1 : transition) (t2 : transition) =
    if (t1.currentState = t2.currentState && t1.stackTop = t2.stackTop
      && check_input_symbols t1.inputSymbol t2.inputSymbol && t1.nextState != t2.nextState) then
        (printf "Non déterministe à cause de : %s %s\n" (as_string_transition t1) (as_string_transition t2);true)
    else false
  in let rec check_transitions (t1 : transition) (ts : transitions) : bool =
    match ts with
      | [] -> false
      | t2::tss -> if check_two_transitions t1 t2 then true
                    else check_transitions t1 tss
  in match transitions with
    | [] -> true
    | t::ts -> if check_transitions t ts then false else check_automaton_determinist ts;;

(* if check_automaton ast then printf "OK\n" else printf "\nFAIL\n";;

if check_automaton_determinist ast.transitions then printf "OK\n" else printf "\nFAIL\n";; *)



