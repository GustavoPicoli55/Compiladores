/*
        Etapa 5 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#ifndef _SIMBOL_H
#define _SIMBOL_H

#include "ast.h"

#define SIZE_OF_INT 4

struct _simbol {
    int linha;
    char* natureza;
    char* tipo;
    vl token_val;
    char shift[SIZE_OF_INT*8+1];
    char *escopo;
} typedef simbol; 

struct _simbolTable {
	simbol** simbols;
    int num_simbols;
    char *escopo;
} typedef simbolTable;
    
struct _tableStack {
    simbolTable *topo;
    struct _tableStack *prox;
} typedef tableStack;

/*
 * Função simbol_new, cria novo simbolo.
 */
simbol *simbol_new(int linha, const char *natureza, const char *tipo, vl *  token_val);

/*
 * Função simbolTable_new, cria nova tabela de simbolos.
 */
simbolTable *simbolTable_new();

/*
 * Função simbolTable_add, adiciona novo simbolo a uma tabela.
 */
void simbolTable_add(simbolTable *t, simbol *s);

/*
 * Função simbolTable_search, procura um simbolo numa tabela.
 */
simbol *simbolTable_search(simbolTable *t, char *chave);

/*
 * Função sibolTable_free, desaloca uma tabela e seus simbolos.
 */
void simbolTable_free(simbolTable *t);

/*
 * Função tableStack_new, cria nova pilha de tabelas de simbolos.
 */
tableStack *tableStack_new();

/*
 * Função tableStack_push, adiciona nova tabela ao topo de uma pilha.
 */
void tableStack_push(tableStack **ts, simbolTable *nova_tabela);

/*
 * Função tableStack_pop, desaloca a tabela do topo de uma pilha.
 */
void tableStack_pop(tableStack *ts);

/*
 * Função tableStack_search, procura um simbolo em uma pilha de tabelas.
 */
simbol *tableStack_search(tableStack *ts, char *chave);

/*
 * Função tableStack_free, libera recursivamente uma pilha, suas tabelas e simbolos.
 */
void tableStack_free(tableStack *ts);

#endif // _SIMBOL_H