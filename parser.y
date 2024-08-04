%{
    /*
        Etapa 4 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
	*/
	#include <stdio.h>
	#include <stdlib.h>
	#include "verifica.h"

	int yylex(void);
	void yyerror (char const *mensagem);
	extern int get_line_number(void);

	tableStack *pilha;
	char *last_type;
%}




%code requires { #include "ast.h" 
				 #include "simbol.h" }

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
%type<node> push
%type<node> pop


%%
//Um programa pode estar vazio ou conter elementos
programa: 
		push lista_de_elemento pop	{ exporta($2); }
	|		 				{ exporta(NULL); };

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
		TK_PR_INT 			{ last_type = "int"; $$ = NULL; }
	|	TK_PR_FLOAT			{ last_type = "float"; $$ = NULL; }
	|	TK_PR_BOOL			{ last_type = "bool"; $$ = NULL; };

//Listas possuem um ou mais identificadores
lista: 
		TK_IDENTIFICADOR ';' lista 	{ int erro = verifica_declaracao(pilha->topo,$1->t_value,$1->t_line);
                                      if(erro != 0) exit(erro);
									  simbolTable_add(pilha->topo,simbol_new($1->t_line,$1->t_type,last_type,$1));
									  $$ = $3; }
	|	TK_IDENTIFICADOR			{ int erro = verifica_declaracao(pilha->topo,$1->t_value,$1->t_line);
                                      if(erro != 0) exit(erro);
									  simbolTable_add(pilha->topo,simbol_new($1->t_line,$1->t_type,last_type,$1));
									  $$ = NULL; };
//Variaveis nao sao adicionadas a arvore, por isso retornam nulo

funcao: 
		cabecalho push corpo pop	{ $$ = $1;
									  if($3 != NULL) ast_add_child($$,$3); };

//Adiciona identificador da funcao na arvore
cabecalho: 
		lista_de_parametros TK_OC_OR tipo '/' TK_IDENTIFICADOR { int erro = verifica_declaracao(pilha->topo,$5->t_value,$5->t_line);
                                      							 if(erro != 0) exit(erro);
																 simbolTable_add(pilha->topo,simbol_new($5->t_line,"funcao",last_type,$5));
																 $$ = ast_new($5->t_value,$5->t_type); };

lista_de_parametros: 
		'(' parametro ')'	{ $$ = $2; };

//A lista de parametros pode estar vazia, assim como possuir um ou mais parametros
parametro: 
		tipo TK_IDENTIFICADOR ';' parametro 	{ int erro = verifica_declaracao(pilha->topo,$2->t_value,$2->t_line);
                                      			  if(erro != 0) exit(erro);
									  			  simbolTable_add(pilha->topo,simbol_new($2->t_line,$2->t_type,last_type,$2));
												  $$ = NULL; }
	|	tipo TK_IDENTIFICADOR 					{ int erro = verifica_declaracao(pilha->topo,$2->t_value,$2->t_line);
                                      			  if(erro != 0) exit(erro);
									  			  simbolTable_add(pilha->topo,simbol_new($2->t_line,$2->t_type,last_type,$2));
												  $$ = NULL; }			
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
		push corpo pop			{ $$ = $2; }
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
		TK_IDENTIFICADOR '=' expressao 		{ simbol *simbolo = tableStack_search(pilha,$1->t_value);
											  int erro = verifica_uso(simbolo,$1->t_type,$1->t_line,$1->t_value);
											  if(erro != 0) exit(erro);		
											  $$ = ast_new("=",simbolo->tipo);
											  ast_add_child($$,ast_new($1->t_value,simbolo->tipo));
											  ast_add_child($$,$3); };
//Adiciona atribuicao a arvore, junto com seus dois filhos

//Chamar funcoes dentro de uma funcao
chamada_funcao: 
		TK_IDENTIFICADOR '(' lista_de_expressoes ')'  { simbol *simbolo = tableStack_search(pilha,$1->t_value);
											  			int erro = verifica_uso(simbolo,"funcao",$1->t_line,$1->t_value);
											  			if(erro != 0) exit(erro);		
														char msgFunc[6] = "call "; 
														strcat(msgFunc, $1->t_value); 
														$$ = ast_new(msgFunc,simbolo->tipo);
														if($3 != NULL) ast_add_child($$,$3); };
//Adiciona chamada de funcao a arvore, concatenando call ao nome da funcao

//return ...    
comando_retorno: 
		TK_PR_RETURN expressao 				{ $$ = ast_new("return",$2->type); 
											  ast_add_child($$,$2); };

//Comandos de IF e While, respectivamente
comando_controle_fluxo: 
		condicional { $$ = $1; }
	|	iterativa	{ $$ = $1; };

condicional:	
		TK_PR_IF '(' expressao ')' push corpo pop { $$ = ast_new("if","bool");
													ast_add_child($$,$3);
													ast_add_child($$,$6); }					
	|	TK_PR_IF '(' expressao ')' push corpo pop TK_PR_ELSE push corpo pop	{ $$ = ast_new("if","bool");
																			  ast_add_child($$,$3);
																			  ast_add_child($$,$6);
																			  ast_add_child($$,$10); };

iterativa: TK_PR_WHILE '(' expressao ')' push corpo pop { $$ = ast_new("while","bool");
														  ast_add_child($$,$3);
														  ast_add_child($$,$6); };

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
	|	eo7 TK_OC_OR eo6   	{ $$ = ast_new("|",infere_tipo($1->type,$3->type));
							  ast_add_child($$,$1);
							  ast_add_child($$,$3); };

eo6: 
		eo5         		{ $$ = $1; }   	
	|	eo6 TK_OC_AND eo5  	{ $$ = ast_new("&",infere_tipo($1->type,$3->type));
								   ast_add_child($$,$1);
								   ast_add_child($$,$3); };

eo5: 
		eo4         		{ $$ = $1; }        
	|	eo5 TK_OC_EQ eo4    { $$ = ast_new("==",infere_tipo($1->type,$3->type));
							  ast_add_child($$,$1);
							  ast_add_child($$,$3); }
	|	eo5 TK_OC_NE eo4    { $$ = ast_new("!=",infere_tipo($1->type,$3->type));
							  ast_add_child($$,$1);
							  ast_add_child($$,$3); };

eo4: 
		eo3         	 { $$ = $1; }    
	|	eo4 TK_OC_LE eo3 { $$ = ast_new("<=",infere_tipo($1->type,$3->type));
						   ast_add_child($$,$1);
						   ast_add_child($$,$3); }
	|	eo4 TK_OC_GE eo3 { $$ = ast_new(">=",infere_tipo($1->type,$3->type));
						   ast_add_child($$,$1);
						   ast_add_child($$,$3); }
	|	eo4 '<' eo3      { $$ = ast_new("<",infere_tipo($1->type,$3->type));
						   ast_add_child($$,$1);
						   ast_add_child($$,$3); }
	|	eo4 '>' eo3      { $$ = ast_new(">",infere_tipo($1->type,$3->type));
						   ast_add_child($$,$1);
						   ast_add_child($$,$3); };

eo3: 
		eo2         { $$ = $1; }
	|	eo3 '+' eo2 { $$ = ast_new("+",infere_tipo($1->type,$3->type));
					  ast_add_child($$,$1);
					  ast_add_child($$,$3); }
	|	eo3 '-' eo2 { $$ = ast_new("-",infere_tipo($1->type,$3->type));
					  ast_add_child($$,$1);
					  ast_add_child($$,$3); };

eo2: 
		eo1			{ $$ = $1; }
	|	eo2 '*' eo1 { $$ = ast_new("*",infere_tipo($1->type,$3->type));
					  ast_add_child($$,$1);
					  ast_add_child($$,$3); }
	|	eo2 '/' eo1 { $$ = ast_new("/",infere_tipo($1->type,$3->type)); 
				      ast_add_child($$,$1);
					  ast_add_child($$,$3); }
	|	eo2 '%' eo1 { $$ = ast_new("%",infere_tipo($1->type,$3->type));
					  ast_add_child($$,$1);
					  ast_add_child($$,$3); };
     
eo1:
		operando	{ $$ = $1; }
	|	'!' eo0		{ $$ = ast_new("!",$2->type); ast_add_child($$,$2); }
	|	'-' eo0     { $$ = ast_new("-",$2->type); ast_add_child($$,$2); };

//Maior prioridade
eo0:
		operando	{ $$ = $1; }
	|	'!' eo1 	{ $$ = ast_new("!",$2->type); ast_add_child($$,$2); }
	|	'-' eo1     { $$ = ast_new("-",$2->type); ast_add_child($$,$2); };

//'()' quebra a prioridade iniciando uma nova expressao
operando:	
		'(' expressao ')' 	{ $$ = $2; }
	|	TK_IDENTIFICADOR 	{ simbol *simbolo = tableStack_search(pilha,$1->t_value);
							  int erro = verifica_uso(simbolo,$1->t_type,$1->t_line,$1->t_value);
							  if(erro != 0) exit(erro);		
							  $$ = ast_new($1->t_value,simbolo->tipo); }
	|	literal 			{ $$ = $1; }
	|	chamada_funcao		{ $$ = $1; };

literal:	
		TK_LIT_INT		{ $$ = ast_new($1->t_value,"int"); }
	|	TK_LIT_FLOAT 	{ $$ = ast_new($1->t_value,"float"); }
	| 	TK_LIT_FALSE 	{ $$ = ast_new($1->t_value,"bool"); }
	| 	TK_LIT_TRUE		{ $$ = ast_new($1->t_value,"bool"); };

// Adiciona nova tabela a pilha 
push: { simbolTable *tabela = simbolTable_new();
        tableStack_push(&pilha, tabela);
        $$ = NULL; };

// Remove tabela do topo da pilha
pop: { tableStack_pop(pilha);
       $$ = NULL; };

%%

void yyerror (char const *mensagem){
	printf("Erro na linha %d.\n%s \n", get_line_number(), mensagem);
}