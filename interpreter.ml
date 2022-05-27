open Ast
open Printf
open Printer

exception InterpreterError;;

let stack = ref [];;
let current_state = ref ' ';;
let i = ref 0;;

let push (s : symbol) : unit =
  stack := s::!stack

let rec push_symbols_to_stack (symbols : symbol list) : unit =
  match symbols with
  | [] -> ()
  | s::ss -> (push s; push_symbols_to_stack ss);;

let pop () : unit =
  stack := List.tl !stack;;

let update_stack (_newStackTop : symbol list) (_oldStackTop : symbol) : unit =
  match _newStackTop with
  | [] -> pop ()
  | hd::tl ->
    if hd = _oldStackTop then
      push_symbols_to_stack tl
    else
      (pop (); push_symbols_to_stack tl);;

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

let update_current_state (new_state : symbol) : unit =
  current_state := new_state;;

let execute_automaton (a : automaton) (w : string) : unit =
  stack := [a.declarations.initialStackSymbol];
  current_state := a.declarations.initialState;
  i := 0;
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
            (update_current_state t.nextState;
            update_stack t.newStackTop (List.hd !stack);
            printf "Transition: %s\n\n" (as_string_transition t);
            print_log w)
          | Some l ->
            (if !i < len && l = w.[!i] then
              (update_current_state t.nextState;
              update_stack t.newStackTop (List.hd !stack);
              i := !i + 1;
              printf "Transition: %s\n\n" (as_string_transition t);
              print_log w)
            else
              loop ts w)) (* move to the next transition *)
        else
          loop ts w) (* move to the next transition *)
    in
    try
      while !i < len do (* loop over the input string *)
        loop a.transitions w
      done;
      while !stack <> [] do (* empty the stack using epsioln transitions if possible *)
        loop a.transitions w
      done;
      print_newline ();
      if !i = len && !stack = [] then print_endline ">>> Recognized word"
      else raise InterpreterError
    with
    | Failure e -> (* error raised by List.hd *)
      printf "[InterpreterError] The stack is empty but the input isn't fully consumed\n";
      print_endline "\n>>> Unrecognized word"; exit 7 (* 7 for interpreter errors *)
    | InterpreterError ->
      if !i = len && !stack <> [] then
        (printf "[InterpreterError] The input is fully consumed but the stack is not empty\n";
        print_endline "\n>>> Unrecognized word"; exit 7) (* 7 for interpreter errors *)
      else
        printf "[InterpreterError] No matching transition\n";
        print_endline "\n>>> Unrecognized word"; exit 7;; (* 7 for interpreter errors *)

(* ************************************************************************************************** *)
(* ************************************************************************************************** *)
(* ************************************************************************************************** *)
(* ************************************************************************************************** *)

(* Part 3 interpreter *)

let rec treat_instruction (i : instruction) (w : string) : unit =
  match i with
  | Pop -> pop ()
  | Push s -> push s
  | Change q -> update_current_state q
  | Reject ->  raise InterpreterError
  | Case c -> treat_case c w

and treat_case (c : case) (w : string) =
  match c.caseType with
  | State -> treat_case_state c.caseBody w
  | Next ->  treat_case_next c.caseBody w
  | Top -> treat_case_top c.caseBody w

and treat_case_state (ll : symbolInstruction list) (w : string): unit =
  match ll with
  | [] -> raise InterpreterError
  | (s, i)::r ->
    (if !current_state = s then treat_instruction i w
    else treat_case_state r w)

and treat_case_next (ll : symbolInstruction list) (w : string) : unit =
  match ll with
  | [] -> raise InterpreterError
  | (s, ins)::r ->
    (if w.[!i] = s then
      (i := !i + 1;
      treat_instruction ins w)
    else treat_case_next r w)

and treat_case_top (ll : symbolInstruction list) (w : string) : unit =
  match ll with
  | [] -> raise InterpreterError
  | (s, ins)::r -> (if (List.hd !stack) = s then treat_instruction ins w else treat_case_top r w);;

let execute_automaton3 (a : automaton3) (w : string) : unit =
  stack := [a.initialStackSymbol];
  current_state := a.initialState;
  i := 0;
  print_log w;
  let len = String.length w
  in
  try
    while !i < len do (* loop over the input string *)
      treat_case a.program w
    done;
    while !stack <> [] do (* empty the stack using epsioln transitions if possible *)
      treat_case a.program w
    done;
    print_newline ();
    if !i = len && !stack = [] then print_endline ">>> Recognized word"
    else raise InterpreterError
  with
  | Failure e -> (* error raised by List.hd *)
    printf "[InterpreterError] The stack is empty but the input isn't fully consumed\n";
    print_endline "\n>>> Unrecognized word"; exit 7 (* 7 for interpreter errors *)
  | InterpreterError ->
    if !i = len && !stack <> [] then
      (printf "[InterpreterError] The input is fully consumed but the stack is not empty\n";
      print_endline "\n>>> Unrecognized word"; exit 7) (* 7 for interpreter errors *)
    else
      printf "[InterpreterError] No matching transition\n";
      print_endline "\n>>> Unrecognized word"; exit 7;; (* 7 for interpreter errors *)
