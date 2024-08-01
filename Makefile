
 
# Etapa 1 - Compiladores (2024/1) - Lucas M. Schnorr
# Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342940

etapa1: lex.yy.o main.o
	gcc -o etapa1 lex.yy.o main.o
main.o: main.c
	gcc -c main.c
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c
lex.yy.c: scanner.l
	flex scanner.l
clear: lex.yy.o main.o etapa1
	rm lex.yy.c lex.yy.o main.o etapa1
