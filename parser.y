%{
    /*
        Etapa 3 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
	*/
	#include <stdio.h>
	#include <stdlib.h>

	#include "ast.h"

	int yylex(void);
	void yyerror (char const *mensagem);
	extern int get_line_number(void);

%}

%code requires { #include "ast.h" }

%union {
	ast *node;
    vl *valor_lexico; 
}

%define parse.error verbose

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token<valor_lexico> TK_IDENTIFICADOR
%token<valor_lexico> TK_LIT_INT
%token<valor_lexico> TK_LIT_FLOAT
%token<valor_lexico> TK_LIT_FALSE
%token<valor_lexico> TK_LIT_TRUE
%token TK_ERRO

%type<node> programa
%type<node> lista_de_elemento
%type<node> elemento
%type<node> variavel_global
%type<node> tipo
%type<node> lista
%type<node> funcao
%type<node> cabecalho
%type<node> lista_de_parametros
%type<node> parametro
%type<node> corpo
%type<node> sequencia
%type<node> comando
%type<node> declaracao_variavel
%type<node> comando_atribuicao
%type<node> chamada_funcao
%type<node> comando_retorno
%type<node> comando_controle_fluxo
%type<node> condicional
%type<node> iterativa
%type<node> lista_de_expressoes
%type<node> expressao
%type<node> eo0
%type<node> eo1
%type<node> eo2
%type<node> eo3
%type<node> eo4
%type<node> eo5
%type<node> eo6
%type<node> eo7
%type<node> operando
%type<node> literal


%%
//Um programa pode estar vazio ou conter elementos
programa: 
		lista_de_elemento 	{ exporta($1); }
	|		 				{ printf("Programa vazio\n"); }					;

//Elementos podem ser um ou mais
lista_de_elemento: 	
		elemento lista_de_elemento	{ if($1 != NULL) $$ = $1;
								  	  else if($2 != NULL) $$ = $2;
								  	  else $$ = NULL; 
								  	  if($2 != NULL & $1 != NULL) ast_add_child($1,$2);}
			  
	|	elemento					{ $$ = $1; };
//Ao adicionar na arvore verifica se elementos sao nulos, adicionando
//apenas os que nao sao, colocando os posteriores como filhos dos anteriores


//Elementos podem ser uma de duas coisas
elemento: 
		variavel_global		{ $$ = $1; }
	|	funcao				{ $$ = $1; };

variavel_global: 
		tipo lista ',' 		{ $$ = $2; };

tipo:	
		TK_PR_INT 			{ $$ = NULL; }
	|	TK_PR_FLOAT			{ $$ = NULL; }
	|	TK_PR_BOOL			{ $$ = NULL; };

//Listas possuem um ou mais identificadores
lista: 
		TK_IDENTIFICADOR ';' lista 	{ $$ = $3; }
	|	TK_IDENTIFICADOR			{ $$ = NULL; };
//Variaveis nao sao adicionadas a arvore, por isso retornam nulo

funcao: 
		cabecalho corpo			{ $$ = $1; if($2 != NULL) ast_add_child($$,$2); };

cabecalho: 
		lista_de_parametros TK_OC_OR tipo '/' TK_IDENTIFICADOR { $$ = ast_new($5->t_value); };
//Adiciona identificador da funcao na arvore

lista_de_parametros: 
		'(' parametro ')'	{ $$ = $2; };

//A lista de parametros pode estar vazia, assim como possuir um ou mais parametros
parametro: 
		tipo TK_IDENTIFICADOR ';' parametro 	{ $$ = NULL; }
	|	tipo TK_IDENTIFICADOR 					{ $$ = NULL; }			
	|											{ $$ = NULL; };
//Parametros nao sao adicionados a arvore

corpo: 
		'{' sequencia '}'		{ $$ = $2; };
	|	'{' '}'					{ $$ = NULL; };
//Retorna nulo caso vazio

//O corpo da funcao pode tanto estar vazio quanto contar um ou mais comandos
sequencia:
		comando ',' sequencia	{ if($1 != NULL) $$ = $1;
								  else if($3 != NULL) $$ = $3;
								  else $$ = NULL; 
								  if($3 != NULL & $1 != NULL) ast_add_child($1,$3); };
								  
	|	comando ','				{ $$ = $1; }

comando: 	
		corpo					{ $$ = $1; }
	|	declaracao_variavel 	{ $$ = $1; }
	| 	comando_atribuicao 		{ $$ = $1; }
	|	chamada_funcao 			{ $$ = $1; }
	|	comando_retorno 		{ $$ = $1; }
	|	comando_controle_fluxo	{ $$ = $1; };

//Similar a declaracao de variaveis globais
declaracao_variavel: 
		tipo lista 							{ $$ = $2;};

//Atribuir valores a variaveis
comando_atribuicao: 
		TK_IDENTIFICADOR '=' expressao 		{ $$ = ast_new("=");ast_add_child($$,ast_new($1->t_value));ast_add_child($$,$3); };
//Adiciona atribuicao a arvore, junto com seus dois filhos

//Chamar funcoes dentro de uma funcao
chamada_funcao: 
		TK_IDENTIFICADOR '(' lista_de_expressoes ')'  { char msgFunc[6] = "call "; strcat(msgFunc, $1->t_value); $$ = ast_new(msgFunc);
														if($3 != NULL) ast_add_child($$,$3); };
//Adiciona chamada de funcao a arvore, concatenando call ao nome da funcao

//return ...    
comando_retorno: 
		TK_PR_RETURN expressao 				{ $$ = ast_new("return"); ast_add_child($$,$2); };

//Comandos de IF e While, respectivamente
comando_controle_fluxo: 
		condicional { $$ = $1; }
	|	iterativa	{ $$ = $1; };

condicional:	
		TK_PR_IF '(' expressao ')' corpo { $$ = ast_new("if");ast_add_child($$,$3);ast_add_child($$,$5); }					
	|	TK_PR_IF '(' expressao ')' corpo TK_PR_ELSE corpo	{ $$ = ast_new("if");ast_add_child($$,$3);ast_add_child($$,$5);ast_add_child($$,$7); };

iterativa: TK_PR_WHILE '(' expressao ')' corpo { $$ = ast_new("while");ast_add_child($$,$3);ast_add_child($$,$5); };

//Construtor de lista de expressões
lista_de_expressoes:
		expressao ';' lista_de_expressoes	 { $$ = $1;
											   if($3 != NULL) ast_add_child($$,$3); }
	|	expressao							 { $$ = $1; };
	|										 { $$ = NULL; };

//Construtor da expressao
expressao:  eo7 			{ $$ = $1; };

//Quanto mais acima, menor a prioridade
//Menor prioridade '|'
eo7: 
		eo6         		{ $$ = $1; }    	
	|	eo7 TK_OC_OR eo6   	{ $$ = ast_new("|"); ast_add_child($$,$1);ast_add_child($$,$3); };

eo6: 
		eo5         		{ $$ = $1; }   	
	|	eo6 TK_OC_AND eo5  	{ $$ = ast_new("&"); ast_add_child($$,$1);ast_add_child($$,$3); };

eo5: 
		eo4         		{ $$ = $1; }        
	|	eo5 TK_OC_EQ eo4    { $$ = ast_new("=="); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo5 TK_OC_NE eo4    { $$ = ast_new("!="); ast_add_child($$,$1);ast_add_child($$,$3); };

eo4: 
		eo3         	 { $$ = $1; }    
	|	eo4 TK_OC_LE eo3 { $$ = ast_new("<="); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo4 TK_OC_GE eo3 { $$ = ast_new(">="); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo4 '<' eo3      { $$ = ast_new("<"); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo4 '>' eo3      { $$ = ast_new(">"); ast_add_child($$,$1);ast_add_child($$,$3); };

eo3: 
		eo2         { $$ = $1; }
	|	eo3 '+' eo2 { $$ = ast_new("+"); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo3 '-' eo2 { $$ = ast_new("-"); ast_add_child($$,$1);ast_add_child($$,$3); };

eo2: 
		eo1			{ $$ = $1; }
	|	eo2 '*' eo1 { $$ = ast_new("*"); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo2 '/' eo1 { $$ = ast_new("/"); ast_add_child($$,$1);ast_add_child($$,$3); }
	|	eo2 '%' eo1 { $$ = ast_new("%"); ast_add_child($$,$1);ast_add_child($$,$3); };
     
eo1:
		operando	{ $$ = $1; }
	|	'!' eo0		{ $$ = ast_new("!"); ast_add_child($$,$2); }
	|	'-' eo0     { $$ = ast_new("-"); ast_add_child($$,$2); };

//Maior prioridade
eo0:
		operando	{ $$ = $1; }
	|	'!' eo1 	{ $$ = ast_new("!"); ast_add_child($$,$2); }
	|	'-' eo1     { $$ = ast_new("-"); ast_add_child($$,$2); };

//'()' quebra a prioridade iniciando uma nova expressao
operando:	
		'(' expressao ')' 	{ $$ = $2; }
	|	TK_IDENTIFICADOR 	{ $$ = ast_new($1->t_value); }
	|	literal 			{ $$ = $1; }
	|	chamada_funcao		{ $$ = $1; };

literal:	
		TK_LIT_INT		{ $$ = ast_new($1->t_value); }
	|	TK_LIT_FLOAT 	{ $$ = ast_new($1->t_value); }
	| 	TK_LIT_FALSE 	{ $$ = ast_new($1->t_value); }
	| 	TK_LIT_TRUE		{ $$ = ast_new($1->t_value); };

%%

void yyerror (char const *mensagem){
	printf("Erro na linha %d.\n%s \n", get_line_number(), mensagem);
}