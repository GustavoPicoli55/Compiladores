
 
# Etapa 6 - Compiladores (2024/1) - Lucas M. Schnorr
# Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941

CC=gcc
CFLAGS=-I.
OBJ = main.o parser.o ast.o
CLN = lex.yy.c parser.tab.c etapa6 parser.tab.h saida.dot saida.s a.out saida

all: bison scanner etapa6

bison: parser.y
	bison -d parser.y

scanner: scanner.l parser.tab.c
	lex scanner.l

etapa6: parser.tab.c lex.yy.c
	$(CC) -c lex.yy.c parser.tab.c main.c ast.c simbol.c verifica.c iloc.c asmger.c $(CFLAGS)
	$(CC) -o $@ lex.yy.o parser.tab.o main.o ast.o simbol.o verifica.o iloc.o asmger.o $(CFLAGS)

clean:
	rm *.o $(CLN)

run: 
	@./etapa6 < teste.txt > saida.s

rund:
	@./etapa6 < teste.txt | ./output2dot.sh | xdot -

debug: bison scanner
	cc -g lex.yy.c parser.tab.c main.c ast.c simbol.c verifica.c iloc.c $(CFLAGS)
	gdb a.out

monta:
	@./etapa6 < teste.txt > saida.s
	@gcc saida.s -o saida
	@./saida