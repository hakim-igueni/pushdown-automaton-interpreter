let channel = open_in (Sys.argv.(1));;
let lexbuf = Lexing.from_channel channel;;
let aut = Parser.automate Lexer.next_token lexbuf;;

Printf.printf "Parse result:\n\n%s\n" (Printer.as_string_automaton aut);;

print_string "Entrez un mot: ";;
let word = read_line ();;

print_newline ();

Interpreter.execute_automaton aut word;;
