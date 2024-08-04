/*
        Etapa 4 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
*/

#include "simbol.h"

simbol *simbol_new(int linha, const char *natureza, const char *tipo, vl *token_val){
    simbol *s = (simbol*)malloc(sizeof(simbol));
    if(s != NULL){
        s->linha = linha;
        s->natureza = strdup(natureza);
        s->tipo = strdup(tipo);
        s->token_val.t_line = token_val->t_line;
        s->token_val.t_type = token_val->t_type;
        s->token_val.t_value = token_val->t_value;
    }
    return s;
}

simbolTable *simbolTable_new(){
    simbolTable *t = (simbolTable*)malloc(sizeof(simbolTable));
    if(t != NULL){
        t->simbols = NULL;
        t->num_simbols = 0;
    }
    return t;
}

void simbolTable_add(simbolTable *t, simbol *s){
    if(t == NULL || s == NULL) {
        return;
    }
    t->num_simbols++;
    t->simbols = realloc(t->simbols, t->num_simbols * sizeof(simbol));
    t->simbols[t->num_simbols-1] = s;
}

simbol *simbolTable_search(simbolTable *t, char *chave){
    if(t == NULL){
        return NULL;
    }
    int i;
    for(i = 0; i < t->num_simbols; i++){
        if(strcmp(t->simbols[i]->token_val.t_value, chave) == 0){
            return t->simbols[i];
        }
    }
    return NULL;
}

void simbolTable_free(simbolTable *t){
    if(t == NULL){
        return;
    }
    int i;
    for(i = 0; i < t->num_simbols; i++){
        free(t->simbols[i]);
    }
    free(t->simbols);
    free(t);
}

tableStack *tableStack_new(){
    tableStack *ts = (tableStack*)malloc(sizeof(tableStack));
    if(ts != NULL){
        ts->topo = NULL;
        ts->prox = NULL;
    }   
    return ts;
}

void tableStack_push(tableStack **ts, simbolTable *nova_tabela){
    if(nova_tabela == NULL){
        return;
    }
    if(*ts == NULL){
        *ts = tableStack_new();
    }
    if((*ts)->topo != NULL){
        tableStack *prox = tableStack_new();
        prox->topo = (*ts)->topo;
        prox->prox = (*ts)->prox;
        (*ts)->prox = prox;
    }
    (*ts)->topo = nova_tabela;
}

void tableStack_pop(tableStack *ts){
    if(ts == NULL){
        return;
    }
    simbolTable_free(ts->topo);
    if(ts->prox != NULL){
        tableStack *aux = ts->prox;
        ts->topo = aux->topo;
        ts->prox = aux->prox;
        free(aux);
    } else{
        free(ts);
        ts = NULL;
    }
}

simbol *tableStack_search(tableStack *ts, char *chave){
    if(ts == NULL){
        return NULL;
    }
    tableStack *aux = ts;
    while(aux != NULL){
        simbol *simbolo = simbolTable_search(aux->topo, chave);
        if( simbolo != NULL){
            return simbolo;
        }
        aux = aux->prox;
    }
    return NULL;
}

void tableStack_free(tableStack *ts){
    if(ts == NULL){
        return;
    }
    tableStack_free(ts->prox);
    simbolTable_free(ts->topo);
    free(ts);
}