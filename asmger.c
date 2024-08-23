/*
        Etapa 6 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#include "asmger.h"

void cria_cod_seg(listOpIloc *codigo){
	if(codigo == NULL){
		return;
	}
    printf("\tpushq  %%rbp\n");
    printf("\tmovq   %%rsp, %%rbp\n");
  	int i;
	for(i = 0; i < codigo->num_operacoes; i++){
		gera_assembly(codigo->operacoes[i]);
	}
}

void cria_dado_seg(simbolTable *dados){
    if(dados == NULL){
        return;
    }
    int i;
    int aux = 0;
    for(i = 0; i < dados->num_simbols; i++){
        if(!strcmp(dados->simbols[i]->natureza,"funcao")){
            if(aux == 0){
                printf("\t.text\n");
            }
            printf("\t.globl  %s\n",dados->simbols[i]->token_val.t_value);
            printf("\t.type   %s, @function\n",dados->simbols[i]->token_val.t_value);
            printf("%s:\n",dados->simbols[i]->token_val.t_value);
            aux++;
        } else{
            printf("\t.globl  %s\n",dados->simbols[i]->token_val.t_value);
            if(i == 0){
                printf("\t.bss\n");
            }
            printf("\t.align 4\n");
            printf("\t.type   %s, @object\n",dados->simbols[i]->token_val.t_value);
            printf("\t.size   %s, 4\n",dados->simbols[i]->token_val.t_value);
            printf("%s:\n",dados->simbols[i]->token_val.t_value);
            printf("\t.zero   4\n");
        }
    }
}


void exporta(listOpIloc *codigo, simbolTable *dados){
	printf("\t.text\n");
	cria_dado_seg(dados);
	cria_cod_seg(codigo);
}