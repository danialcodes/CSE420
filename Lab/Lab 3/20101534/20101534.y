%{

#include"symbol_info.h"

#define YYSTYPE symbol_info*

void yyerror(char *s){
	printf("%s\n",s);
}

int yyparse(void);
int yylex(void);
extern FILE *yyin;


ofstream outlog;

int lines=1;

// declare any other variables or functions needed here

%}

%token IF ELSE FOR WHILE DO BREAK CONTINUE RETURN INT FLOAT CHAR VOID DOUBLE SWITCH CASE DEFAULT PRINTLN ADDOP MULOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD SEMICOLON COMMA ID CONST_INT CONST_FLOAT INCOP DECOP ELSE_MARKER

%left ELSE
%nonassoc LOWER_THAN_ELSE

%%

start : program
	{
		outlog<<"At line no: "<<lines<<" start : program "<<endl<<endl;
	}
	;

program : program unit
	{
		outlog<<"At line no: "<<lines<<" program : program unit "<<endl<<endl;
		outlog<<$1->getname()+"\n"+$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"\n"+$2->getname(),"program");
	}
	| unit
	{

		outlog<<"At line no: "<<lines<<" program : unit "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"program");

	}
	;

unit : var_declaration
	{
		outlog<<"At line no: "<<lines<<" unit : var_declaration "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"unit");
	}
	| func_definition
	{
		outlog<<"At line no: "<<lines<<" unit : func_definition "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"unit");
	}
;


func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement
		{	

			outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->getname()<<" "<<$2->getname()<<"("<<$4->getname()<<")\n"<<$6->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname()+" "+$2->getname()+"("+$4->getname()+")\n"+$6->getname(),"func_def");

		}
		| type_specifier ID LPAREN RPAREN compound_statement
		{
			
			outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
			outlog<<$1->getname()<<" "<<$2->getname()<<"()\n"<<$5->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname()+" "+$2->getname()+"()\n"+$5->getname(),"func_def");	
		}
		;

parameter_list : parameter_list COMMA type_specifier ID
	{
		outlog<<"At line no: "<<lines<<" parameter_list : parameter_list COMMA type_specifier ID "<<endl<<endl;
		outlog<<$1->getname()<<", "<<$3->getname()<<" "<<$4->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+", "+$3->getname()+" "+$4->getname(),"param_list");
	}
	| parameter_list COMMA type_specifier
	{
		outlog<<"At line no: "<<lines<<" parameter_list : parameter_list COMMA type_specifier "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+","+$3->getname(),"param_list");
	}
	| type_specifier ID
	{
		outlog<<"At line no: "<<lines<<" parameter_list : type_specifier ID "<<endl<<endl;
		outlog<<$1->getname()<<" "<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+" "+$2->getname(),"param_list");
	}
	| type_specifier
	{
		outlog<<"At line no: "<<lines<<" parameter_list : type_specifier "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"param_list");
	}
	;

compound_statement : LCURL statements RCURL
	{
		outlog<<"At line no: "<<lines<<" compound_statement : LCURL statements RCURL "<<endl<<endl;
		outlog<<"{\n"<<$2->getname()<<"}"<<endl<<endl;
		
		$$ = new symbol_info("{\n"+$2->getname()+"}","comp_stmnt");
	}
	| LCURL RCURL
	{
		outlog<<"At line no: "<<lines<<" compound_statement : LCURL RCURL "<<endl<<endl;
		outlog<<"{\n}\n"<<endl<<endl;
		
		$$ = new symbol_info("{\n}","comp_stmnt");
	}
	;

var_declaration : type_specifier declaration_list SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" var_declaration : type_specifier declaration_list SEMICOLON "<<endl<<endl;
		outlog<<$1->getname()<<" "<<$2->getname()<<";\n"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+" "+$2->getname()+";\n","var_decl");
	}
	;

type_specifier : INT
	{
		outlog<<"At line no: "<<lines<<" type_specifier : INT "<<endl<<endl;
		outlog<<"int"<<endl<<endl;
		
		$$ = new symbol_info("int","type_spec");
	}
	| FLOAT
	{
		outlog<<"At line no: "<<lines<<" type_specifier : FLOAT "<<endl<<endl;
		outlog<<"float"<<endl<<endl;
		
		$$ = new symbol_info("float","type_spec");
	}
	| VOID
	{
		outlog<<"At line no: "<<lines<<" type_specifier : VOID "<<endl<<endl;
		outlog<<"void"<<endl<<endl;
		
		$$ = new symbol_info("void","type_spec");
	}
	;

declaration_list : declaration_list COMMA ID
	{
		outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID "<<endl<<endl;
		outlog<<$1->getname()<<", "<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+", "+$3->getname(),"decl_list");
	}
	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
	{
		outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<", "<<$3->getname()<<"["<<$5->getname()<<"]"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+", "+$3->getname()+"["+$5->getname()+"]","decl_list");
	}
	| ID
	{
		outlog<<"At line no: "<<lines<<" declaration_list : ID "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"decl_list");
	}
	| ID LTHIRD CONST_INT RTHIRD
	{
		outlog<<"At line no: "<<lines<<" declaration_list : ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"["+$3->getname()+"]","decl_list");
	}
	;

statements : statement
	{
		outlog<<"At line no: "<<lines<<" statements : statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"stmnts");
	}
	| statements statement
	{
		outlog<<"At line no: "<<lines<<" statements : statements statement "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname(),"stmnts");
	}
	;



statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement
		{
	    	outlog<<"At line no: "<<lines<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl<<endl;
			outlog<<"for("<<$3->getname()<<$4->getname()<<$5->getname()<<")\n"<<$7->getname()<<endl<<endl;
			
			$$ = new symbol_info("for("+$3->getname()+$4->getname()+$5->getname()+")\n"+$7->getname(),"stmnt");
		}
		| var_declaration
		{
			outlog<<"At line no: "<<lines<<" statement : var_declaration "<<endl<<endl;
			outlog<<$1->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname(),"stmnt");
		}
		| expression_statement
		{
			outlog<<"At line no: "<<lines<<" statement : expression_statement "<<endl<<endl;
			outlog<<$1->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname(),"stmnt");
		}
		| compound_statement
		{
			outlog<<"At line no: "<<lines<<" statement : compound_statement "<<endl<<endl;
			outlog<<$1->getname()<<endl<<endl;
			
			$$ = new symbol_info($1->getname(),"stmnt");
		}

		| IF LPAREN expression RPAREN ELSE_MARKER statement %prec LOWER_THAN_ELSE
		{
			outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement "<<endl<<endl;
			outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
			
			$$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname(),"stmnt");
		}
		| IF LPAREN expression RPAREN statement ELSE statement
		{
			outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement ELSE statement "<<endl<<endl;
			outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<"else\n"<<$7->getname()<<endl<<endl;
			
			$$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname()+"else\n"+$7->getname(),"stmnt");
		}
		| WHILE LPAREN expression RPAREN statement
		{
			outlog<<"At line no: "<<lines<<" statement : WHILE LPAREN expression RPAREN statement "<<endl<<endl;
			outlog<<"while("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
			
			$$ = new symbol_info("while("+$3->getname()+")\n"+$5->getname(),"stmnt");
		}
		| PRINTLN LPAREN ID RPAREN SEMICOLON
		{
			outlog<<"At line no: "<<lines<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON "<<endl<<endl;
			outlog<<"printf("<<$3->getname()<<");\n"<<endl<<endl;
			
			$$ = new symbol_info("printf("+$3->getname()+");\n","stmnt");
		}
		| RETURN expression SEMICOLON
		{
			outlog<<"At line no: "<<lines<<" statement : RETURN expression SEMICOLON "<<endl<<endl;
			outlog<<"return "<<$2->getname()<<";\n"<<endl<<endl;
			
			$$ = new symbol_info("return "+$2->getname()+";\n","stmnt");
		}
		;


expression_statement : SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" expression_statement : SEMICOLON "<<endl<<endl;
		outlog<<";\n"<<endl<<endl;
		
		$$ = new symbol_info(";\n","exp_stmnt");
	}
	| expression SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" expression_statement : expression SEMICOLON "<<endl<<endl;
		outlog<<$1->getname()<<";\n"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+";\n","exp_stmnt");
	}
	;

variable : ID
	{
		outlog<<"At line no: "<<lines<<" variable : ID "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"var");
	}
	| ID LTHIRD expression RTHIRD
	{
		outlog<<"At line no: "<<lines<<" variable : ID LTHIRD expression RTHIRD "<<endl<<endl;
		outlog<<$1->getname()+"["+$3->getname()+"]"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"["+$3->getname()+"]","var");
	}
	;
expression : logic_expression
	{
		outlog<<"At line no: "<<lines<<" expression : logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"exp");
	}
	| variable ASSIGNOP logic_expression
	{
		outlog<<"At line no: "<<lines<<" expression : variable ASSIGNOP logic_expression "<<endl<<endl;
		outlog<<$1->getname()+"="+$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"="+$3->getname(),"exp");
	}
	;

logic_expression : rel_expression
	{
		outlog<<"At line no: "<<lines<<" logic_expression : rel_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"logic_exp");
	}
	| rel_expression LOGICOP rel_expression
	{
		outlog<<"At line no: "<<lines<<" logic_expression : rel_expression LOGICOP rel_expression "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()+$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"logic_exp");
	}
	;

rel_expression : simple_expression
	{
		outlog<<"At line no: "<<lines<<" rel_expression : simple_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"rel_exp");
	}
	| simple_expression RELOP simple_expression
	{
		outlog<<"At line no: "<<lines<<" rel_expression : simple_expression RELOP simple_expression "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()+$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"rel_exp");
	}
	;

simple_expression : term
	{
		outlog<<"At line no: "<<lines<<" simple_expression : term "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"simple_exp");
	}
	| simple_expression ADDOP term
	{
		outlog<<"At line no: "<<lines<<" simple_expression : simple_expression ADDOP term "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()+$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"simple_exp");
	}
	;

term : unary_expression
	{
		outlog<<"At line no: "<<lines<<" term : unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"term");
	}
	| term MULOP unary_expression
	{
		outlog<<"At line no: "<<lines<<" term : term MULOP unary_expression "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()+$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"term");
	}
	;

unary_expression : ADDOP unary_expression
	{
		outlog<<"At line no: "<<lines<<" unary_expression : ADDOP unary_expression "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname(),"unary_exp");
	}
	| NOT unary_expression
	{
		outlog<<"At line no: "<<lines<<" unary_expression : NOT unary_expression "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname(),"unary_exp");
	}
	| factor
	{
		outlog<<"At line no: "<<lines<<" unary_expression : factor "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"unary_exp");
	}
	;

factor : variable
	{
		outlog<<"At line no: "<<lines<<" factor : variable "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"factor");
	}
	| ID LPAREN argument_list RPAREN
	{
		outlog<<"At line no: "<<lines<<" factor : ID LPAREN argument_list RPAREN "<<endl<<endl;
		outlog<<$1->getname()+"("+$3->getname()+")"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"("+$3->getname()+")","factor");
	}
	| LPAREN expression RPAREN
	{
		outlog<<"At line no: "<<lines<<" factor : LPAREN expression RPAREN "<<endl<<endl;
		outlog<<"("+$2->getname()+")"<<endl<<endl;
		
		$$ = new symbol_info("("+$2->getname()+")","factor");
	}
	| CONST_INT
	{
		outlog<<"At line no: "<<lines<<" factor : CONST_INT "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"factor");
	}
	| CONST_FLOAT
	{
		outlog<<"At line no: "<<lines<<" factor : CONST_FLOAT "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"factor");
	}
	| variable INCOP
	{
		outlog<<"At line no: "<<lines<<" factor : variable INCOP "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname(),"factor");
	}
	| variable DECOP
	{
		outlog<<"At line no: "<<lines<<" factor : variable DECOP "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname(),"factor");
	}
	;

argument_list : arguments
	{
		outlog<<"At line no: "<<lines<<" argument_list : arguments "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"arg_list");
	}
	
	;

arguments : arguments COMMA logic_expression
	{
		outlog<<"At line no: "<<lines<<" arguments : arguments COMMA logic_expression "<<endl<<endl;
		outlog<<$1->getname()+$2->getname()+$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"args");
	}
	| logic_expression
	{
		outlog<<"At line no: "<<lines<<" arguments : logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"args");
	}
	;

%%

int main(int argc, char *argv[])
{
	if(argc != 2) 
	{
        printf("Please input file name:\n");
		return 0;
	}
	yyin = fopen(argv[1], "r");
	
	
	if(yyin == NULL)
	{
		cout<<"Couldn't open file"<<endl;
		return 0;
	}
    else{
		outlog.open("20101534_log.txt", ios::trunc);
		yyparse();
		outlog<< "\nTotal lines: "+to_string(lines);
		//print number of lines
		outlog.close();
		fclose(yyin);
	}
	return 0;

	
}