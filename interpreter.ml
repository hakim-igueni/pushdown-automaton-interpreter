open Ast
open Printf
open Printer

(*TODO: Ensuite, écrire un interpréteur pour l’arbre construit qui lit du terminal un mot,
exécute l’automate sur le mot et affiche le détail de l’exécution.*)

let stack = ref [];;
let current_state = ref ' ';;
let i = ref 0;;

exception InterpreterError of string;;

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
  print_endline ("pile: " ^ as_string_symbol_list (List.rev !stack));;

let print_from_position (i: int) (w: string) : unit =
  let rec loop (i: int) (w: string) : unit =
    print_char w.[i];
    loop (i+1) w
  in try loop i w with Invalid_argument e -> print_newline ();;

let print_log (w: string) : unit =
  printf "Etat courant: %c\n" !current_state;
  print_string "Mot restant a lire: ";
  print_from_position !i w;
  print_stack ();
  print_newline ();;

let execute_automaton (a : automaton) (w : string) : unit =
  stack := [a.declarations.initialStackSymbol];
  current_state := a.declarations.initialState;
  print_log w;
  match a.transitions with
  | [] -> raise (InterpreterError "Automate sans transitions")
  | _ ->
    let rec loop (transitions : transitions) (w : string) : unit =
      match transitions with
      | [] -> raise (InterpreterError "Aucune transition correspond à cette configuration")
      | t::ts ->
        (* TODO: treat the exception when the stack is empty before the end of the word *)
        if (t.currentState = !current_state) && (t.stackTop = List.hd !stack) then
          (match t.inputSymbol with
          | None ->
            (current_state := t.nextState;
            update_stack t.newStackTop (List.hd !stack);
            print_log w;
            printf "Transition: %s\n\n" (as_string_transition t))
          | Some l ->
            (if l = w.[!i] then
              (current_state := t.nextState;
              update_stack t.newStackTop (List.hd !stack);
              i := !i + 1;
              print_log w;
              printf "Transition: %s\n\n" (as_string_transition t))
            else
              loop ts w))
        else
          loop ts w
    in let len = String.length w
    in while !i < len do
      loop a.transitions w
    done;
    while !stack != [] do (* vider la pile avec des epsiolns transitions si cest possible *)
      loop a.transitions w
    done;
    if !stack = [] then print_endline "Mot reconnu"
    else raise (InterpreterError "Mot non reconnu");;


(* print_endline ("Etat courant: " ^ as_string_symbol !current_state);
          print_endline ("Symbole de la pile: " ^ as_string_symbol (List.hd !stack));
          print_endline "Symbole en entrée: EPSILON";
          print_endline ("Etat prochain: " ^ as_string_symbol t.nextState);
          print_stack (); *)
