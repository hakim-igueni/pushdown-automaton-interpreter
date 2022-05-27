%{
open Ast3
%}

%token <char> SYMBOL
%token COMMA COLON EOF
%token INPUTSYMBOLS STACKSYMBOLS STATES INITIALSTATE INITIALSTACKSYMBOL
%token PROGRAM CASE STATE NEXT TOP OF BEGIN END PUSH POP CHANGE REJECT

%start<Ast3.automaton3> automate

%%


automate:
    s1=inputSymbols s2=stackSymbols s3=states s4=initialState s5=initialStackSymbol p=program EOF {
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
    INPUTSYMBOLS s=separated_nonempty_list(COMMA, SYMBOL) { s }

stackSymbols:
    STACKSYMBOLS s=separated_nonempty_list(COMMA, SYMBOL) { s }

states:
    STATES s=separated_nonempty_list(COMMA, SYMBOL) { s }

initialState:
    INITIALSTATE s=SYMBOL { s }

initialStackSymbol:
    INITIALSTACKSYMBOL s=SYMBOL { s }

program:
    PROGRAM c=case {c}
    // PROGRAM CASE caseBody {c}
// |                       {[]} // epsilon

case:
|   BEGIN CASE t=caseType OF is=instructions END { { caseType=t; caseBody=is } }
|   CASE t=caseType OF is=instructions END { { caseType=t; caseBody=is } }

caseType:
|   TOP {Top}
|   NEXT {Next}
|   STATE {State}

instructions:
    l=nonempty_list(instruction) {l}

instruction:
    s=SYMBOL COLON ib=instructionBody {(s,ib)}

instructionBody:
|   PUSH s=SYMBOL {Push s}
|   POP {Pop}
|   CHANGE s=SYMBOL {Change s}
|   REJECT {Reject}
|   c=case {Case c}
