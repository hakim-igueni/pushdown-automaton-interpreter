(* Abstract Syntax Tree (AST) of the first part *)
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


(* Abstract Syntax Tree (AST) of the third part *)

type caseType = Top | Next | State;;

type case = {
  caseType: caseType;
  caseBody: symbolInstruction list;
}

and symbolInstruction = (symbol * instruction)

and instruction =
| Push of symbol
| Pop
| Change of symbol
| Reject
| Case of case;;

type program = case;;

(* Automaton *)
type automaton3 = {
  inputSymbols: symbol list;
  stackSymbols: symbol list;
  states: symbol list;
  initialState: symbol;
  initialStackSymbol: symbol;
  program: program;
};;
