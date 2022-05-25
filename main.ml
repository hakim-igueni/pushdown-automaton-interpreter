let channel = open_in (Sys.argv.(1))

let lexbuf = Lexing.from_channel channel 

let ast = Parser.automate Lexer.next_token lexbuf 

let _ = Printf.printf "Parse:\n%s\n" (Ast.as_string ast)
