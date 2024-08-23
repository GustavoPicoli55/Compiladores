/*
        Etapa 6 - Compiladores (2024/1) - Lucas M. Schnorr
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

void *gera_assembly(opIloc *op){

    static int regA = 0;
    static char* regChar;

    if(!strcmp(op->operacao, "storeAI")){
        if(!strcmp(op->arg2, "rbss")){
            printf("\tmovl   %%%s, %s(%%rip)\n", "eax", op->arg1);
        }else{
            printf("\tmovl   %%%s, %d(%%rbp)\n", "eax", (-1 * atoi(op->arg3)) - 4);
        }
        regA = 0;
    } else if(!strcmp(op->operacao, "loadI")){
        if(regA == 0){
            regChar = "eax";
            regA = 1;
        } else{
            regChar = "edx";
        }
        printf("\tmovl    $%s, %%%s\n", op->arg1, regChar);
    } else if(!strcmp(op->operacao, "cmp_NE")){
        printf("\tcmpl     %%edx, %%eax\n");
        printf("\tsetne    %%al\n");
        printf("\tmovzbl   %%al, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "nop")){
        printf(".%s:\n", op->arg1);
    } else if(!strcmp(op->operacao, "jumpI")){
        printf("\tjmp .%s\n", op->arg1);
        regA = 0;
    } else if(!strcmp(op->operacao, "or")){
        printf("\torl      %%edx, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "and")){
        printf("\tandl     %%edx, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "cmp_EQ")){
        printf("\tcmpl     %%edx, %%eax\n");
        printf("\tsetl     %%al\n");
        printf("\tmovzbl   %%al, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "cmp_GE")){
        printf("\tcmpl     %%edx, %%eax\n");
        printf("\tsetl     %%al\n");
        printf("\tmovzbl   %%al, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "cmp_LE")){
        printf("\tcmpl     %%edx, %%eax\n");
        printf("\tsetl     %%al\n");
        printf("\tmovzbl   %%al, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "cmp_GT")){
        printf("\tcmpl     %%edx, %%eax\n");
        printf("\tsetl     %%al\n");
        printf("\tmovzbl   %%al, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "cmp_LT")){
        printf("\tcmpl     %%edx, %%eax\n");
        printf("\tsetl     %%al\n");
        printf("\tmovzbl   %%al, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "add")){
        printf("\taddl     %%edx, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "sub")){
        printf("\tsubl     %%edx, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "mult")){
        printf("\timull    %%edx, %%eax\n");
        regA = 0;
    } else if(!strcmp(op->operacao, "div")){
        printf("\tmovl     %%edx, %%ecx\n");
        printf("\tcltd\n");
        printf("\tidivl    %%ecx\n");
    } else if(!strcmp(op->operacao, "multI")){  
        if(regA == 1){
            regChar = "eax";
            regA = 1;
        } else{
            regChar = "edx";
        }
        printf("\tnegl    %%%s\n", regChar);
    } else if(!strcmp(op->operacao, "loadAI")){
        if(regA == 0){
            regChar = "eax";
            regA = 1;
        } else{
            regChar = "edx";
        }
        if(!strcmp(op->arg1, "rbss")){
            printf("\tmovl   %s(%%rip), %%%s\n",  op->arg3, regChar);   
        } else{
            printf("\tmovl   %d(%%rbp), %%%s\n", (-1 * atoi(op->arg2)) - 4, regChar) ;
        }
    } else if(!strcmp(op->operacao, "cbr")){
        printf("\tje    .%s\n", op->arg3);
        regA = 0;
    } else if(!strcmp(op->operacao, "return")){
        if(!strcmp(op->arg2,"rbss")){
            printf("\tmovl   %s(%%rip), %%eax\n", op->arg1);
        } else if(!strcmp(op->arg2,"rfp")){
            printf("\tmovl   %d(%%rbp), %%eax\n", (-1 * atoi(op->arg3)) - 4);
        } else{
            printf("\tmovl   $%s, %%eax\n", op->arg1);
        }
        printf("\tpopq   %%rbp\n");
        printf("\tret\n");
    }
}