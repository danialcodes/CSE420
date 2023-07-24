%option noyywrap

%{

    #include<bits/stdc++.h>
    using namespace std;

    ofstream yyoutlog; //output filestream for log file

    // define necessary c++ variables and functions here (if any)
    int lines=1; //to keep track of line numbers
%}

/* Regular Definitions */

delim [ \t\n]

/* write regular expressions for whitespace and newline */
ws [ \t\r]
newline [\n]

letter [a-zA-Z]
digit [0-9]

/* write regular expressions for id, float and integers */

id ({letter}|"_")({letter}|"_"|{digit})*
int_literal {digit}+
float_literal {digit}*"."{digit}*


keywords if|else|for|range|break|not|catch|try|except|True|False|def|return|finally|and|or|print|in|continue|pass|None

/* regular expressions for operators */
addop "+"|"-"
incop "+="|"-="
relop "<"|">"|"<="|">="|"=="|"!="


%%

{ws} { /* ignore whitespace */ }

{newline} {
			lines++;
    }

{keywords}  {
    int len = yyleng;
	char yytextUpper[len];
    strncpy(yytextUpper, yytext,len);
    yytextUpper[len] = '\0';

    for (int i = 0; yytextUpper[i]; i++) {
        yytextUpper[i] = toupper(yytextUpper[i]);
    }

    yyoutlog << "Line no " + to_string(lines) + ": Token <" + yytextUpper + "> Lexeme " + yytext + " found" + "\n"+"\n";
}


{int_literal} {
			yyoutlog <<"Line no "+to_string(lines)+": Token <CONST_INT> Lexeme "+yytext+" found"+"\n"+"\n";
		}
{float_literal} {
			yyoutlog <<"Line no "+to_string(lines)+": Token <CONST_FLOAT> Lexeme "+yytext+" found"+"\n"+"\n";
		}


{addop} {
			yyoutlog <<"Line no "+to_string(lines)+": Token <ADDOP> Lexeme "+yytext+" found"+"\n"+"\n";
		}
{incop} {
			yyoutlog <<"Line no "+to_string(lines)+": Token <INCOP> Lexeme "+yytext+" found"+"\n"+"\n";
		}
{relop} {
			yyoutlog << "Line no "+to_string(lines)+": Token <RELOP> Lexeme "+yytext+" found"+"\n"+"\n";
		}
"=" {
			yyoutlog <<"Line no "+to_string(lines)+": Token <ASSIGNOP> Lexeme "+yytext+" found"+"\n"+"\n";
		}

"(" {
			yyoutlog <<"Line no "+to_string(lines)+": Token <LPAREN> Lexeme "+yytext+" found"+"\n"+"\n";
		}
")" {
			yyoutlog <<"Line no "+to_string(lines)+": Token <RPAREN> Lexeme "+yytext+" found"+"\n"+"\n";
		}
"{" {
			yyoutlog <<"Line no "+to_string(lines)+": Token <LCURL> Lexeme "+yytext+" found"+"\n"+"\n";
		}
"}" {
			yyoutlog << "Line no "+to_string(lines)+": Token <RCURL> Lexeme "+yytext+" found"+"\n"+"\n";
		}
"[" {
			yyoutlog << "Line no "+to_string(lines)+": Token <LTHIRD> Lexeme "+yytext+" found"+"\n"+"\n";
		}
"]" {
			yyoutlog << "Line no "+to_string(lines)+": Token <RTHIRD> Lexeme "+yytext+" found"+"\n"+"\n";
		}
":" {
			yyoutlog << "Line no "+to_string(lines)+": Token <COLON> Lexeme "+yytext+" found"+"\n"+"\n";
		}
{id} {
            yyoutlog << "Line no "+to_string(lines)+": Token <ID> Lexeme "+yytext+" found"+"\n"+"\n";
        }
%%

int main(int argc, char *argv[])
{

	if(argc != 2) //check if file name is given
	{
        printf("Please input file name:\n");
		return 0;
	}

	yyin = fopen(argv[1], "r"); //the file to be read must be assigned to yyin

	if(yyin == NULL) // file does not exist
	{
		printf("Error: File not found.\n");
        return 0;
	}
	else{
		yyoutlog.open("20101534_log.txt", ios::trunc); // remember to rename the log file as mentioned in the spec
	
		yylex(); // start reading the input file in a loop
	
		//print total number of lines found in the input file
		yyoutlog<< "\nTotal lines: "+to_string(lines);
		yyoutlog.close(); // close the log file
	
		fclose(yyin); // close the input file
	}

	
}