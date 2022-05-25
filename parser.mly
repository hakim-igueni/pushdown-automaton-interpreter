%{
open Ast
%}

%token <char> SYMBOL
%token COMMA SEMICOLON LPAREN RPAREN EOF
%token INPUTSYMBOLS STACKSYMBOLS STATES INITIALSTATE INITIALSTACKSYMBOL TRANSITIONS

%start<Ast.automaton> automate

%%


automate:
    d=declarations t=transitions EOF { { declarations=d; transitions=t } }

declarations:
    s1=inputSymbols s2=stackSymbols s3=states s4=initialState s5=initialStackSymbol {
        {
            inputSymbols=s1;
            stackSymbols=s2;
            states=s3;
            initialState=s4;
            initialStackSymbol=s5
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

transitions:
    TRANSITIONS t=list(transition) { t }

transition:
    LPAREN s1=SYMBOL COMMA s2=option(SYMBOL) COMMA s3=SYMBOL COMMA s4=SYMBOL COMMA s5=stack RPAREN {
        {
            currentState=s1;
            inputSymbol=s2;
            stackTop=s3;
            nextState=s4;
            newStackTop=s5
        }
    }

stack:
    s=separated_list(SEMICOLON, SYMBOL) { s }
