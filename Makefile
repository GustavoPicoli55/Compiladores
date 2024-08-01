
 
# Etapa 2 - Compiladores (2024/1) - Lucas M. Schnorr
# Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941

CC=gcc
CFLAGS=-I.
OBJ = main.o parser.o
CLN = lex.yy.c parser.tab.c etapa2 parser.tab.h

all: bison scanner etapa2

bison: parser.y
	bison -d parser.y

scanner: scanner.l parser.tab.c
	lex scanner.l

etapa2: parser.tab.c lex.yy.c
	$(CC) -c lex.yy.c parser.tab.c main.c $(CFLAGS)
	$(CC) -o $@ lex.yy.o parser.tab.o main.o $(CFLAGS)

clean:
	rm *.o $(CLN)

run: 
	@./etapa2 < teste.txt

