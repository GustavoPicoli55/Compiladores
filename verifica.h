/*
        Etapa 4 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#ifndef _VERIFICA_H
#define _VERIFICA_H
#define ERR_UNDECLARED 10
#define ERR_DECLARED 11
#define ERR_VARIABLE 20
#define ERR_FUNCTION 21

#include "simbol.h"

/*
 * Função verifica_uso, verifica se o uso de uma funcao ou variavel esta sendo feita corretamente.
 */
int verifica_uso(simbol *simbolo, char *natureza, int linha, char *value);

/*
 * Função verifica_declaracao, verifica se uma funcao ou variavel ja foi declarada.
 */
int verifica_declaracao(simbolTable *tabela, char *chave, int linha);

/*
 * Função imprime_mensagem_erro, imprime na tela os erros em linguagem natural;
 */
void imprime_mensagem_erro(int erro, char *value, char *natureza, int linha_dec, int linha_usa);

/*
 * Função infere_tipo, infere o tipo de dados de uma operacao a partir de seus filhos.
 */
char *infere_tipo(char *tipo1, char *tipo2);

#endif // _VERIFICA_H