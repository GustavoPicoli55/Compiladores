
 
# Etapa 5 - Compiladores (2024/1) - Lucas M. Schnorr
# Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941

CC=gcc
CFLAGS=-I.
OBJ = main.o parser.o ast.o
CLN = lex.yy.c parser.tab.c etapa5 parser.tab.h saida.dot saida.txt a.out

all: bison scanner etapa5

bison: parser.y
	bison -d parser.y

scanner: scanner.l parser.tab.c
	lex scanner.l

etapa5: parser.tab.c lex.yy.c
	$(CC) -c lex.yy.c parser.tab.c main.c ast.c simbol.c verifica.c iloc.c $(CFLAGS)
	$(CC) -o $@ lex.yy.o parser.tab.o main.o ast.o simbol.o verifica.o iloc.o $(CFLAGS)

clean:
	rm *.o $(CLN)

run: 
	@./etapa5 < teste.txt > saida.txt

rund:
	@./etapa5 < teste.txt | ./output2dot.sh | xdot -

debug: bison scanner
	cc -g lex.yy.c parser.tab.c main.c ast.c simbol.c verifica.c iloc.c $(CFLAGS)
	gdb a.out