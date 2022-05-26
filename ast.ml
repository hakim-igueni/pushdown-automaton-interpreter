(* Abstract Syntax Tree (AST) *)
type symbol = char;;

(* Declarations *)
type declarations = {
  inputSymbols: symbol list;
  stackSymbols: symbol list;
  states: symbol list;
  initialState: symbol;
  initialStackSymbol: symbol;
};;

(* Transitions *)
type transition = {
  currentState: symbol;
  inputSymbol: symbol option;
  stackTop: symbol;
  nextState: symbol;
  newStackTop: symbol list;
};;

type transitions = transition list;;


(* Automaton *)
type automaton = {
  declarations: declarations;
  transitions: transitions;
};;
