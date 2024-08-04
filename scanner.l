%{
	/*
        Etapa 4 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342941
	*/
	#include "parser.tab.h"
	#include "ast.h"

	vl* new_vl(int l, char* t, char* v){
    	vl* res = (vl*)malloc(sizeof(vl));
    	res->t_line = l;
    	res->t_type = strdup(t);
    	res->t_value = strdup(v);
    	return res;
	}
%}

%option noyywrap
%option yylineno
%x comment

%%

 /*Reconhecimento de literais*/
"false"					{ yylval.valor_lexico = new_vl(yylineno, "literal", yytext); return TK_LIT_FALSE;  	}   
"true" 					{ yylval.valor_lexico = new_vl(yylineno, "literal", yytext); return TK_LIT_TRUE;    }
[0-9]+					{ yylval.valor_lexico = new_vl(yylineno, "literal", yytext); return TK_LIT_INT;     }
[0-9]*"."[0-9]+			{ yylval.valor_lexico = new_vl(yylineno, "literal", yytext); return TK_LIT_FLOAT;   }

 /*Reconhecimento de palavrass reservadas*/
"int"                   {return TK_PR_INT;	}       
"float"                 {return TK_PR_FLOAT;	}     
"bool"					{return TK_PR_BOOL;		}	 
"if"                    {return TK_PR_IF;		}        
"else"                  {return TK_PR_ELSE;		}      
"while"                 {return TK_PR_WHILE;	}     
"return"                {return TK_PR_RETURN;	}

 /*Reconhecimento de caracteres especias*/
"-" 					{return *yytext;		}
"!" 					{return *yytext;		}
"*" 					{return *yytext;		}
"/" 					{return *yytext;		}
"%" 					{return *yytext;		}
"+" 					{return *yytext;		}
"<" 					{return *yytext;		}
">" 					{return *yytext;		}
"{"						{return *yytext;		}
"}" 					{return *yytext;		}
"(" 					{return *yytext;		}
")" 					{return *yytext;		}
"=" 					{return *yytext;		}
"," 					{return *yytext;		}
";" 					{return *yytext;		}  

 /*Reconhecimento de operadores logicos*/
"<="                    {return TK_OC_LE;		}  
">="                    {return TK_OC_GE;  		}
"=="                    {return TK_OC_EQ;  		}	
"!="                    {return TK_OC_NE;  		}
"&"						{return TK_OC_AND; 		}
"|"						{return TK_OC_OR;  		}

 /*Reconhecimento de identificadores*/
[a-z_][a-z0-9_]*  		{ yylval.valor_lexico = new_vl(yylineno, "identificador", yytext); return TK_IDENTIFICADOR; 	}

 /*Ignorar "nao-caracteres"*/
[ \t]+ {}
[ \r]+ {}
\/\/(.)* {}

 /*Reconhecimento de inicio de comentario multi-line*/
"/*"    BEGIN(comment);

 /*Ignorar nova linha*/
\n {}

 /*Reconnhece erro*/
.						{return TK_ERRO;		}

 /*Tratamento dos comentarios multi-line*/
<comment>[^*\n]*       
<comment>"*"+[^*/\n]*  
<comment>\n yylineno;
<comment>"*"+"/"        BEGIN(INITIAL);

%%

//Funcao que retorna numero atual de linhas
int get_line_number(void){
	return yylineno;
}