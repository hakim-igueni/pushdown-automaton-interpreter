open Ast
open Printf
open Printer

exception InterpreterError;;

let stack = ref [];;
let current_state = ref ' ';;
let i = ref 0;;

let rec push_symbols_to_stack (symbols : symbol list) : unit =
  match symbols with
  | [] -> ()
  | s::ss ->
    (stack := s::!stack;
    push_symbols_to_stack ss);;

let update_stack (_newStackTop : symbol list) (_oldStackTop : symbol) : unit =
  match _newStackTop with
  | [] -> stack := List.tl !stack
  | hd::tl ->
    if hd = _oldStackTop then
      push_symbols_to_stack tl
    else
      (stack := List.tl !stack;
      push_symbols_to_stack tl);;

let print_stack () : unit =
  print_endline ("Stack: " ^ as_string_symbol_list (List.rev !stack));;

let print_from_position (i: int) (w: string) : unit =
  let rec loop (i: int) (w: string) : unit =
    print_char w.[i];
    loop (i+1) w
  in try loop i w with Invalid_argument e -> print_newline ();;

let print_log (w: string) : unit =
  printf "Current state: %c\n" !current_state;
  print_string "Remainging word: ";
  print_from_position !i w;
  print_stack ();
  print_newline ();;

let execute_automaton (a : automaton) (w : string) : unit =
  stack := [a.declarations.initialStackSymbol];
  current_state := a.declarations.initialState;
  print_log w;
  match a.transitions with
  | [] -> printf "[InterpreterError] Automaton has no transitions\n"
  | _ ->
    let len = String.length w
    in let rec loop (transitions : transitions) (w : string) : unit =
      match transitions with
      | [] -> raise InterpreterError
      | t::ts ->
        (if (t.currentState = !current_state) && (t.stackTop = List.hd !stack) then
          (match t.inputSymbol with
          | None ->
            (current_state := t.nextState;
            update_stack t.newStackTop (List.hd !stack);
            printf "Transition: %s\n\n" (as_string_transition t);
            print_log w)
          | Some l ->
            (if l = w.[!i] then
              (current_state := t.nextState;
              update_stack t.newStackTop (List.hd !stack);
              i := !i + 1;
              printf "Transition: %s\n\n" (as_string_transition t);
              print_log w)
            else
              loop ts w))
        else
          loop ts w)
    in
    try
      while !i < len do
        loop a.transitions w
      done;
      while !stack <> [] do (* vider la pile avec des epsiolns transitions si cest possible *)
        loop a.transitions w
      done;
      print_newline ();
      if !stack = [] && !i = len then print_endline ">>> Recognized word"
      else print_endline ">>> Unrecognized word";
    with
    | Failure e ->
      printf "[InterpreterError] The stack is empty but the input isn't fully consummed\n";
      print_endline "\n>>> Unrecognized word"; exit 7 (* 7 for interpreter errors *)
    | InterpreterError ->
      printf "[InterpreterError] No matching transition\n";
      print_endline "\n>>> Unrecognized word"; exit 7 (* 7 for interpreter errors *)
