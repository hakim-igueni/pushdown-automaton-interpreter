# Un interpréteur pour les automates à pile déterministes

## Compilation et exécution

Étant dans le dossier du projet, exécutez la commande `make` ce qui va générer l'exécutable du projet avec le nom `main`.

Pour lancer le programme, exécutez la commande `./main <path>` tel que `path` correspond au chemin du fichier qui contient la définition de l'automate.

## Division du travail

Abdesselam BENAMEUR:

- Le lexeur de la partie 1 `lexer.mll`
- Le parseur `parser.mly`
- Le Makefile `Makefile`
- L'interpréteur `interpreter.ml`
- Le rapport du projet `README.md`
- Le parseur de la partie 3 `parser3.mly`
- La définition de l'arbre de syntaxe abstraite de la partie 1 et 3 `ast.ml`
- L'interpréteur de la partie 3 `interpreter3.ml`

Hakim IGUENI:

- Correction des bugs dans le parseur
- Les fonctions d'affichage `printer.ml`
- La vérification de la correction et du déterminisme de l'automate `checker.ml`
- Le lexeur de la partie 3 `lexer3.mll`
- L'interpréteur de la partie 3 `interpreter3.ml`
