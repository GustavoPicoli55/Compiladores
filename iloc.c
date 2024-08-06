/*
        Etapa 5 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#include "iloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


char *new_label(){
    static int num_label = 1;
    char *str = calloc(1, sizeof(char)*(num_label/10+2));
    sprintf(str, "L%d", num_label);
    num_label++;
    return str;
}


char *gera_temp(){
    static int num_temp = 1;
    char *str = calloc(1, sizeof(char)*(num_temp/10+2));
    sprintf(str, "r%d",num_temp);
    num_temp++;
    return str;
}

opIloc *geraOperacao(char *operacao, char* arg1, char* arg2, char* arg3){
    opIloc *op = (opIloc*)malloc(sizeof(opIloc));
    if(op != NULL){
        op->operacao = operacao;
        op->arg1 = arg1;
        op->arg2 = arg2;
        op->arg3 = arg3;
    }

    return op;
}

listOpIloc *listOpIloc_new(){
    listOpIloc *lop = (listOpIloc*)malloc(sizeof(listOpIloc));
    if(lop != NULL){
        lop->operacoes = NULL;
        lop->num_operacoes = 0;
    }
    return lop;
}

void listOpIloc_add(listOpIloc *lop, opIloc *op){
    if(lop == NULL || op == NULL) {
        return;
    }
    lop->num_operacoes++;
    lop->operacoes = realloc(lop->operacoes, lop->num_operacoes * sizeof(opIloc));
    lop->operacoes[lop->num_operacoes-1] = op;
}

listOpIloc *listOpIloc_merge(listOpIloc *lop1, listOpIloc *lop2){
    listOpIloc *lopf = listOpIloc_new();

    if(lop1 == NULL){
        if(lop2 != NULL){ 
            lopf = lop2;
        }       
    }else{
        lopf = lop1;
        if(lop2 != NULL){
            int i;
            for(i = 0; i < lop2->num_operacoes; i++){
                listOpIloc_add(lopf,lop2->operacoes[i]);
            }
        }   
    }
    
    return lopf;    
}

void *gera_cod(opIloc *op){

    if(!strcmp(op->operacao, "storeAI")){
        printf("%s %s => %s, %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "loadI")){
        printf("%s %s => %s\n", op->operacao, op->arg1, op->arg2);
    } else if(!strcmp(op->operacao, "cmp_NE")){
        printf("%s %s, %s -> %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "nop")){
        printf("%s:\n%s\n", op->arg1, op->operacao);
    } else if(!strcmp(op->operacao, "jumpI")){
        printf("%s -> %s\n", op->operacao, op->arg1);
    } else if(!strcmp(op->operacao, "or")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "and")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "cmp_EQ")){
        printf("%s %s, %s -> %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "cmp_GE")){
        printf("%s %s, %s -> %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "cmp_LE")){
        printf("%s %s, %s -> %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "cmp_GT")){
        printf("%s %s, %s -> %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "cmp_LT")){
        printf("%s %s, %s -> %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "add")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "sub")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "mult")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "div")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "multI")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "loadAI")){
        printf("%s %s, %s => %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    } else if(!strcmp(op->operacao, "cbr")){
        printf("%s %s -> %s, %s\n", op->operacao, op->arg1, op->arg2, op->arg3);
    }

}