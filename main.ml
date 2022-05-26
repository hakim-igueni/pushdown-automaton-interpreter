open Lexer
open Parser
open Interpreter
open Checker
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

printf "Parsing automaton from %s...\n\n" Sys.argv.(1);;

let aut =
  try
    automate next_token lexbuf
  with
  | LexingError c -> printf "[LexerError] Caractere non reconu: %c\n" c; exit 3; (* 3 for lexing errors *)
  | _ -> printf "[ParserError] Parsing error detected by Menhir in the file %s\n" Sys.argv.(1); exit 4;; (* 4 for parsing errors *)
printf "Parse result:\n\n%s\n" (Printer.as_string_automaton aut);;
print_string "-----------------------------------------------------------\n\n";;

if is_correct_automaton aut then
  printf "Automaton is correct\n"
else
  printf "Automaton is incorrect\n"; exit 5;; (* 5 for incorrect automata *)

if is_deterministic_automaton aut.transitions then
  printf "Automaton is deterministic\n"
else
  printf "Automaton is not deterministic\n"; exit 6;; (* 6 for non-deterministic automata *)

print_string "-----------------------------------------------------------\n\n";;

print_string "Enter a word: ";;
let word = read_line ();;
print_newline ();;
execute_automaton aut word;;

(* 0 for normal termination *)
(* exit 0;; *)
