{
    (* open Token *)
    open Parser
    exception LexingError of string
}

let space = [' ''\t''\n''\r']
let symbol = ['a'-'z''A'-'Z''0'-'9'] 

rule next_token = parse
| "input symbols: "  {INPUTSYMBOLS}
| "stack symbols: " {STACKSYMBOLS}
| "states: "  {STATES}
| "initial state: "  {INITIALSTATE}
| "initial stack symbol: "  {INITIALSTACKSYMBOL}
| "transitions:"  {TRANSITIONS}
| symbol as c {SYMBOL(c)}
| ',' {COMMA}
| ';' {SEMICOLON}
| '(' {LPAREN}
| ')' {RPAREN}
| space* {next_token lexbuf}
| eof {EOF}
| _ {raise (LexingError "unexpected symbol")}
