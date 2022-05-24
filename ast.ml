(* Abstract Syntax Tree (AST) *)

type symbol = char;;

(* Declarations *)
type inputSymbols = symbol list;;
type stackSymbols = symbol list;;
type states = symbol list;;

(* type declarations = inputSymbols * stackSymbols * states * symbol * symbol;; *)

(* Transitions *)
type stack = symbol list;;
type transition = symbol * symbol option * symbol * symbol * stack;;
(* type transitions = transition list;; *)


(* Automaton *)
type automaton = {
  declarations: inputSymbols * stackSymbols * states * symbol * symbol;
  transitions: transition list
};;
(* type automaton = declarations * transitions;; *)
