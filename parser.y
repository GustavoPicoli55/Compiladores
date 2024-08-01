%{
    /*
        Etapa 2 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
	*/
	#include <stdio.h>
	#include <stdlib.h>

	int yylex(void);
	void yyerror (char const *mensagem);
	extern int get_line_number(void);

%}
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
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO

%%
//Um programa pode estar vazio ou conter elementos
programa: 
		lista_de_elemento 	|
							;

//Elementos podem ser um ou mais
lista_de_elemento: 	
		lista_de_elemento elemento	| 
		elemento					;

//Elementos podem ser uma de duas coisas
elemento: 
		variavel_global | 
		funcao			;

variavel_global: 
		tipo lista ',' ;

tipo:	TK_PR_INT 	| 
		TK_PR_FLOAT | 
		TK_PR_BOOL	;

//Listas possuem um ou mais identificadores
lista: 
		TK_IDENTIFICADOR ';' lista 	| 
		TK_IDENTIFICADOR		;

funcao: 
		cabecalho corpo;

cabecalho: 
		lista_de_parametros TK_OC_OR tipo '/' TK_IDENTIFICADOR;

lista_de_parametros: 
		'(' parametro ')';

//A lista de parametros pode estar vazia, assim como possuir um ou mais parametros
parametro: 
		tipo TK_IDENTIFICADOR ';' parametro | 
		tipo TK_IDENTIFICADOR 				| 
											;

corpo: 
		'{' sequencia '}';

//O corpo da funcao pode tanto estar vazio quanto contar um ou mais comandos
sequencia:
		  						| 
		  comando ',' sequencia	;

comando: 	
		declaracao_variavel 	| 
		comando_atribuicao 		| 
		chamada_funcao 			| 
		comando_retorno 		| 
		comando_controle_fluxo	;

//Similar a declaracao de variaveis globais
declaracao_variavel: 
		tipo lista;

//Atribuir valores a variaveis
comando_atribuicao: 
		TK_IDENTIFICADOR '=' expressao ;

//Chamar funcoes dentro de uma funcao
chamada_funcao: 
		TK_IDENTIFICADOR '(' expressao ')';

//return ...    
comando_retorno: 
		TK_PR_RETURN expressao;

//Comandos de IF e While, respectivamente
comando_controle_fluxo: 
		condicional | 
		iterativa	;

condicional:	
		TK_PR_IF '(' expressao ')' corpo					| 
		TK_PR_IF '(' expressao ')' corpo TK_PR_ELSE corpo	;

iterativa: TK_PR_WHILE '(' expressao ')' corpo;

//Construtor da expressao
expressao:  eo7 ;

//Quanto mais acima, menor a prioridade
//Menor prioridade '|'
eo7: 
	eo6             	|
	eo7 TK_OC_OR eo6   	;

eo6: 
	eo5             	|
	eo6 TK_OC_AND eo5  	;

eo5: 
	eo4                 |
	eo5 TK_OC_EQ eo4    |
	eo5 TK_OC_NE eo4    ;

eo4: 
	eo3              |
	eo4 TK_OC_LE eo3 |
	eo4 TK_OC_GE eo3 |
	eo4 '<' eo3      |
	eo4 '>' eo3      ;

eo3: 
	eo2         |
	eo3 '+' eo2 |
	eo3 '-' eo2 ;

eo2: 
	eo1			|
	eo2 '*' eo1 |
	eo2 '/' eo1 |
	eo2 '%' eo1 ;
     
eo1:
	operando	|
	'!' eo0     |
	'-' eo0     ;

//Maior prioridade
eo0:
	operando    |
	'!' eo1     |
	'-' eo1     ;

//'()' quebra a prioridade iniciando uma nova expressao
operando:	
		'(' expressao ')' 	| 
		TK_IDENTIFICADOR 	| 
		literal 			| 
		chamada_funcao		;

literal:	
		TK_LIT_INT		| 
		TK_LIT_FLOAT 	| 
		TK_LIT_FALSE 	| 
		TK_LIT_TRUE		;

%%

void yyerror (char const *mensagem){
	printf("Erro na linha %d.\n%s \n", get_line_number(), mensagem);
}