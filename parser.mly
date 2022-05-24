%{
open Ast
%}

%token <char> SYMBOl
%token COMMA SEMICOLON LPAREN RPAREN EOF 
%token INPUTSYMBOLS STACKSYMBOLS STATES INITIALSTATE INITIALSTACKSYMBOL TRANSITIONS

%start<Ast.automaton> automate

%%

  
automate:
    d=declarations; t=transitions; EOF { { declarations = d; transitions = t } }

declarations:
    s1=inputSymbols s2=stackSymbols s3=states s4=initialState s5=initialStackSymbol s6=transitions {(s1,s2,s3,s4,s5,s6)}

inputSymbols:
    INPUTSYMBOLS s=separated_list(COMMA, SYMBOl) { s } 

stackSymbols:
    STACKSYMBOLS s=separated_list(COMMA, SYMBOl) { s }

states:
    STATES s=separated_list(COMMA, SYMBOl) { s }

initialState:
    INITIALSTATE s=SYMBOl { s }

initialStackSymbol:
    INITIALSTACKSYMBOL s=SYMBOl { s }

transitions:
    TRANSITIONS t=list(transition) { t }

transition:
    LPAREN s1=SYMBOl COMMA s2=option(SYMBOl) COMMA s3=SYMBOl COMMA s4=SYMBOl s5=stack RPAREN { (s1,s2,s3,s4,s5) }

stack:
    s=separated_list(SEMICOLON, SYMBOl) { s }