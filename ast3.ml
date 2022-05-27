(* Abstract Syntax Tree (AST) *)
type symbol = char;;

type caseType = Top | Next | State;;

type case = {
  caseType: caseType;
  caseBody: (symbol * instruction) list;
}

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
