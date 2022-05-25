(* Abstract Syntax Tree (AST) *)
open String
type symbol = char;;

(* Declarations *)
type inputSymbols = symbol list;;
type stackSymbols = symbol list;;
type states = symbol list;;

type declarations = inputSymbols * stackSymbols * states * symbol * symbol;;

(* Transitions *)
type stack = symbol list;;
type transition = symbol * symbol option * symbol * symbol * stack;;
type transitions = transition list;;


(* Automaton *)
type automaton = declarations * transitions;;

let as_string_symbol(s : symbol): string = "" ^ make 1 s ^ "";;

let rec as_string_symbol_list(l : symbol list) =
  match l with
  | [] -> ""
  | [x] -> as_string_symbol x
  | (s::ls) ->  as_string_symbol(s) ^ ", " ^ as_string_symbol_list ls;;

let as_string_declarations (d : declarations) : string =
  match d with
  | (inputSymbols, stackSymbols, states, initialState, initialstack) ->
    "\tinputSymbols: " ^ as_string_symbol_list inputSymbols ^ "\n"
    ^ "\tstackSymbols: " ^ as_string_symbol_list stackSymbols ^ "\n"
    ^ "\tstates: " ^ as_string_symbol_list states ^ "\n"
    ^ "\tinitialState: " ^ as_string_symbol initialState ^ "\n"
    ^ "\tinitialstack: " ^ as_string_symbol initialstack;;

let rec as_string_stack_list(s : symbol list) =
  match s with
  | [] -> ""
  | (s::ls) ->  as_string_symbol(s) ^ ";" ^ as_string_symbol_list ls;;

let as_string_transition (t : transition) : string =
  match t with
  | (state, Some(inputSymbol), stackSymbol, nextState, nextStack) ->
    "\t(" ^ as_string_symbol state ^ "," ^ as_string_symbol inputSymbol ^ ","
    ^ as_string_symbol stackSymbol ^ "," ^ as_string_symbol nextState
    ^ "," ^ as_string_stack_list nextStack ^ ")"
  | (state, None, stackSymbol, nextState, nextStack) ->
    "\t(" ^ as_string_symbol state ^ "," ^ "" ^ ","
    ^ as_string_symbol stackSymbol ^ "," ^ as_string_symbol nextState
    ^ "," ^ as_string_stack_list nextStack ^ ")";;

let rec as_string_transitions (ts : transitions) : string =
  match ts with
  | [] -> ""
  | (t::ts) -> as_string_transition t ^ "\n" ^ as_string_transitions ts;;


let as_string_automaton (a : automaton) : string =
  match a with (d, tr) -> "\nDeclarations:\n" ^ as_string_declarations d ^ "\n\nTransitions:\n" ^ as_string_transitions tr;;
