/*
        Etapa 5 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#ifndef _ILOC_H
#define _ILOC_H

struct _opIloc{
    char* operacao;
    char* arg1;
    char* arg2;
    char* arg3;
} typedef opIloc;

struct _listOpIloc{
    opIloc **operacoes;
    int num_operacoes;
} typedef listOpIloc;

/*
 * Função new_label, cria nova label com numero 1 maior que a anterior.
 */
char *new_label();

/*
 * Função gera_temp, cria novo temporario com numero 1 maior que o anterior.
 */
char *gera_temp();

/*
 * Função geraOperacao, cria uma operacao ILOC usando a estrutura opIloc
 */
opIloc *geraOperacao(char *operacao, char* arg1, char* arg2, char* arg3);

/*
 * Função listOpIloc_new, cria uma tabela de operacoes ILOC
 */
listOpIloc *listOpIloc_new();

/*
 * Função listOpIloc_add, adiciona uma nova operacao ILOC a uma tabela
 */
void listOpIloc_add(listOpIloc *lop, opIloc *op);

/*
 * Função listOpIloc_merge, junta duas tabelas de operacoes
 */
listOpIloc *listOpIloc_merge(listOpIloc *lop1, listOpIloc *lop2);

/*
 * Função gera_cod, imprime o codigo de uma operacao
 */
void *gera_cod(opIloc *op);

#endif // _ILOC_H;