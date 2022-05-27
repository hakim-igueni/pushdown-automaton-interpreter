{
    open Parser3
    exception LexingError of char
}

let space = [' ''\t''\n''\r']
let symbol = ['a'-'z''A'-'Z''0'-'9']

rule next_token = parse
| "input symbols:"  {INPUTSYMBOLS}
| "stack symbols:" {STACKSYMBOLS}
| "states:"  {STATES}
| "initial state:"  {INITIALSTATE}
| "initial stack symbol:"  {INITIALSTACKSYMBOL}
| "program:"  {PROGRAM}
| "case"  {CASE}
| "state" {STATE}
| "next" {NEXT}
| "top" {TOP}
| "of"  {OF}
| "begin"  {BEGIN}
| "end"  {END}
| "push"  {PUSH}
| "pop"  {POP}
| "change"  {CHANGE}
| "reject"  {REJECT}
| ":"  {COLON}
| ',' {COMMA}
| symbol as c {SYMBOL(c)}
| space {next_token lexbuf}
| eof {EOF}
| _ as c {raise (LexingError c)}
