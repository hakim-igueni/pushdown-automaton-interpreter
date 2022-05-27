open Lexer3
open Parser3
open Interpreter
open Printf

let channel =
  try
    open_in (Sys.argv.(1))
  with
  | Invalid_argument e ->
    printf "Usage: %s <filename>\n" Sys.argv.(0); exit 1; (* 1 when no file is given *)
  | Sys_error e ->
    printf "[SysError] %s\n" e; exit 2;; (* 2 when system error *)
let lexbuf = Lexing.from_channel channel;;

printf ">>> Parsing automaton from %s...\n\n" Sys.argv.(1);;

let aut3 =
  try
    automate3 next_token3 lexbuf
  with
  | LexingError c -> printf "[LexerError] Caractere non reconu: %c\n" c; exit 3; (* 3 for lexing errors *)
  | _ -> printf "[ParserError] Parsing error detected by Menhir in the file %s\n" Sys.argv.(1); exit 4;; (* 4 for parsing errors *)

print_string "-----------------------------------------------------------\n\n";;
print_endline ">>> Executing the automaton...\n\n";;
print_string "Enter a word: ";;
let word = read_line ();;
print_newline ();;
execute_automaton3 aut3 word;;

(* 0 for normal termination *)
(* exit 0;; *)
