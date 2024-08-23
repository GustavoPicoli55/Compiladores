/*
        Etapa 6 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#include "verifica.h"

int verifica_uso(simbol *simbolo, char *natureza, int linha, char *value){
    if(simbolo == NULL){
        imprime_mensagem_erro(ERR_UNDECLARED, value, natureza, 0, linha);
        return ERR_UNDECLARED;
    } 
    if(!strcmp(simbolo->natureza,"identificador") && !strcmp(natureza,"funcao")){
        imprime_mensagem_erro(ERR_VARIABLE, simbolo->token_val.t_value, simbolo->natureza, simbolo->linha, linha);
        return ERR_VARIABLE;
    }
    if(!strcmp(simbolo->natureza,"funcao") && !strcmp(natureza,"identificador")){
        imprime_mensagem_erro(ERR_FUNCTION, simbolo->token_val.t_value, simbolo->natureza, simbolo->linha, linha);
        return ERR_FUNCTION;
    }
    return 0;
}

int verifica_declaracao(simbolTable *tabela, char *chave, int linha){
     simbol *simbolo = simbolTable_search(tabela,chave);
     if(simbolo != NULL){
        imprime_mensagem_erro(ERR_DECLARED, simbolo->token_val.t_value, simbolo->natureza, simbolo->linha, linha);
        return ERR_DECLARED;
    }
    return 0;
}

void imprime_mensagem_erro(int erro, char *value, char *natureza, int linha_dec, int linha_usa){
    if(strcmp(natureza,"identificador") == 0){
        strcpy(natureza,"variavel");
    }
    switch(erro){
        case ERR_UNDECLARED:
            printf("Erro encontrado na linha %d. A %s '%s' não foi declarada.\n", linha_usa, natureza, value);
            return;
        case ERR_DECLARED:
            printf("Erro encontrado na linha %d. Foi encontrada declaracao previa da %s '%s' na linha %d.\n", linha_usa, natureza, value, linha_dec);
            return;
        case ERR_VARIABLE:
            printf("Erro encontrado na linha %d. A variavel '%s', declarada na linha %d, foi utilizada como função.\n", linha_usa, value, linha_dec);
            return;
        case ERR_FUNCTION:
            printf("Erro encontrado na linha %d. A funcao '%s', declarada na linha %d, foi utilizada como variável.\n", linha_usa, value, linha_dec);
            return;
    }
}

char *infere_tipo(char *tipo1, char *tipo2){
    if(tipo1 == tipo2){
        return tipo1;
    } else if(tipo1 == "float" || tipo2 == "float"){
        return "float";
    } else if(tipo1 == "int" || tipo2 == "int"){
        return "int";
    }
}