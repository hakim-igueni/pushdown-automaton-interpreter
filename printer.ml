open Ast

let as_string_symbol (s : symbol): string = String.make 1 s;;

let as_string_symbol_option (s : symbol option): string = match s with
  | Some c -> as_string_symbol c
  | None -> "";;

let rec as_string_symbol_list(l : symbol list) =
  match l with
  | [] -> ""
  | [x] -> as_string_symbol x
  | (s::ls) ->  as_string_symbol(s) ^ ", " ^ as_string_symbol_list ls;;

let as_string_declarations (d : declarations) : string =
  (* match d with
  | (inputSymbols, stackSymbols, states, initialState, initialstack) -> *)
    "\tinputSymbols: " ^ as_string_symbol_list d.inputSymbols ^ "\n"
    ^ "\tstackSymbols: " ^ as_string_symbol_list d.stackSymbols ^ "\n"
    ^ "\tstates: " ^ as_string_symbol_list d.states ^ "\n"
    ^ "\tinitialState: " ^ as_string_symbol d.initialState ^ "\n"
    ^ "\tinitialStackSymbol: " ^ as_string_symbol d.initialStackSymbol;;

let rec as_string_stack_list(s : symbol list) =
  match s with
  | [] -> ""
  | (s::ls) ->  as_string_symbol(s) ^ ";" ^ as_string_symbol_list ls;;

let as_string_transition (t : transition) : string =
  "(" ^ as_string_symbol t.currentState ^ "," ^ as_string_symbol_option t.inputSymbol ^ ","
    ^ as_string_symbol t.stackTop ^ "," ^ as_string_symbol t.nextState
    ^ "," ^ as_string_stack_list t.newStackTop ^ ")"

let rec as_string_transitions (ts : transitions) : string =
  match ts with
  | [] -> ""
  | (t::ts) -> as_string_transition t ^ "\n\t" ^ as_string_transitions ts;;

let as_string_automaton (a : automaton) : string =
  "Declarations:\n" ^ as_string_declarations a.declarations ^ "\n\nTransitions:\n\t" ^ as_string_transitions a.transitions;;
