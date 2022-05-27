MENHIR=menhir
OCAMLC=ocamlc
OCAMLLEX=ocamllex

SOURCES = ast.ml parser.ml lexer.ml parser3.ml lexer3.ml printer.ml interpreter.ml checker.ml main.ml

OBJECTS = $(SOURCES:.ml=.cmo)

.PHONY: clean all

all: main

main: ast.cmo parser.cmi parser.cmo lexer.cmo parser3.cmo lexer3.cmo printer.cmo interpreter.cmo checker.cmo main.cmo
	$(OCAMLC) -o $@ $(OBJECTS)

%.cmo: %.ml
	$(OCAMLC) -c $< -o $@

%.cmi: %.mli
	$(OCAMLC) -c $< -o $@

%.ml %.mli: %.mly
	rm -f $(<:.mly=.conflicts)
	$(MENHIR) -v --infer $<

%.ml: %.mll
	$(OCAMLLEX) $<

parser.mly: ast.ml

parser3.mly: ast.ml

lexer.mll: parser.ml

lexer3.mll: parser3.ml

clean:
	rm -fr parser.mli parser.ml lexer.ml parser3.mli parser3.ml lexer3.ml *.cmo *.cmi *~ *.automaton *.conflicts main

parser.cmo: ast.cmo parser.cmi
lexer.cmo: parser.cmo

parser3.cmo: ast.cmo parser3.cmi
lexer3.cmo: parser3.cmo

interpreter.cmo: ast.cmo printer.cmo
checker.cmo: ast.cmo printer.cmo
main.cmo: parser.cmo lexer.cmo printer.cmo interpreter.cmo
