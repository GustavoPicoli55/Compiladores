%{
	/*
        Etapa 1 - Compiladores (2024/1) - Lucas M. Schnorr
		Grupo S: Gustavo Picoli - 00332780 e Nathan Mattes - 00342940
	*/
	#include "tokens.h"
%}

%option noyywrap
%option yylineno
%x comment

%%

"false"					{return TK_LIT_FALSE;  	}   
"true" 					{return TK_LIT_TRUE;    }
[0-9]+					{return TK_LIT_INT;     }
[0-9]*"."[0-9]+			{return TK_LIT_FLOAT;   }
"int"                   {return TK_PR_INT;		}       
"float"                 {return TK_PR_FLOAT;	}     
"bool"					{return TK_PR_BOOL;		}	 
"if"                    {return TK_PR_IF;		}        
"else"                  {return TK_PR_ELSE;		}      
"while"                 {return TK_PR_WHILE;	}     
"return"                {return TK_PR_RETURN;	}

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

"<="                    {return TK_OC_LE;		}  
">="                    {return TK_OC_GE;  		}
"=="                    {return TK_OC_EQ;  		}	
"!="                    {return TK_OC_NE;  		}
"&"						{return TK_OC_AND; 		}
"|"						{return TK_OC_OR;  		}

[a-z_][a-z0-9_]*  		{return TK_IDENTIFICADOR; 	}

[ \t]+ {}
[ \r]+ {}
\/\/(.)* {}
"/*"    BEGIN(comment);
\n {}
.						{return TK_ERRO;		}

<comment>[^*\n]*       
<comment>"*"+[^*/\n]*  
<comment>\n yylineno;
<comment>"*"+"/"        BEGIN(INITIAL);

%%

int get_line_number(void){
	return yylineno;
}