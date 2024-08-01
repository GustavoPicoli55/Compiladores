
 
# Etapa 3 - Compiladores (2024/1) - Lucas M. Schnorr
# Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941

CC=gcc
CFLAGS=-I.
OBJ = main.o parser.o ast.o
CLN = lex.yy.c parser.tab.c etapa3 parser.tab.h saida.dot

all: bison scanner etapa3

bison: parser.y
	bison -d parser.y

scanner: scanner.l parser.tab.c
	lex scanner.l

etapa3: parser.tab.c lex.yy.c
	$(CC) -c lex.yy.c parser.tab.c main.c ast.c $(CFLAGS)
	$(CC) -o $@ lex.yy.o parser.tab.o main.o ast.o $(CFLAGS)

clean:
	rm *.o $(CLN)

run: 
	@./etapa3 < teste.txt

rund:
	@./etapa3 < teste.txt | ./output2dot.sh | xdot -
