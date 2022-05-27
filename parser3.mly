%{
open Ast
%}

%token <char> SYMBOL
%token COMMA COLON EOF
%token INPUTSYMBOLS STACKSYMBOLS STATES INITIALSTATE INITIALSTACKSYMBOL
%token PROGRAM CASE STATE NEXT TOP OF BEGIN END PUSH POP CHANGE REJECT

%start<Ast.automaton3> automate3

%%


automate3:
    s1=inputSymbols s2=stackSymbols s3=states s4=initialState s5=initialStackSymbol p=program EOF {
        print_string "Automaton3";
        {
            inputSymbols=s1;
            stackSymbols=s2;
            states=s3;
            initialState=s4;
            initialStackSymbol=s5;
            program=p;
        }
    }

inputSymbols:
    INPUTSYMBOLS s=separated_nonempty_list(COMMA, SYMBOL) { print_string "Automaton3";s }

stackSymbols:
    STACKSYMBOLS s=separated_nonempty_list(COMMA, SYMBOL) { print_string "Automaton3";s }

states:
    STATES s=separated_nonempty_list(COMMA, SYMBOL) { print_string "Automaton3";s }

initialState:
    INITIALSTATE s=SYMBOL { print_string "Automaton3";s }

initialStackSymbol:
    INITIALSTACKSYMBOL s=SYMBOL { print_string "Automaton3";s }

program:
    PROGRAM c=case {print_string "Program";c}
// |                       {[]} // epsilon

case:
|   BEGIN CASE t=caseType OF is=instructions END { print_string "Case";{ caseType=t; caseBody=is } }
|   CASE t=caseType OF is=instructions END { print_string "Case";{ caseType=t; caseBody=is } }

caseType:
|   TOP {print_string "TOP";Top}
|   NEXT {print_string "NEXT";Next}
|   STATE {print_string "STATE";State}

instructions:
    l=nonempty_list(instruction) {print_string "instruction list";l}

instruction:
    s=SYMBOL COLON ib=instructionBody {print_string "instructionBody";(s,ib)}

instructionBody:
|   PUSH s=SYMBOL {print_string "Push";Push s}
|   POP {print_string "Pop";Pop}
|   CHANGE s=SYMBOL {print_string "Change";Change s}
|   REJECT {print_string "Reject";Reject}
|   c=case {print_string "Case";Case c}
