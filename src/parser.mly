%{ open Ast %}


%token SEMI LPAREN RPAREN LBRACE RBRACE COMMA COLON /*AT*/
/*%token POWER */
%token PLUS MINUS TIMES DIVIDE
/*%token MOD */
%token ASSIGN /* AASSIGN SASSIGN MASSIGN DASSIGN */
%token EQ GEQ GT LEQ LT
/*%token RETURN WHILE WHEN IF ELSE ELSEIF VOID NULL BREAK*/
/*%token AND OR NOT */
%token INTD STRINGD /* FLOATD PERCENT ARRAY STRING CURR STOCK ORDER PF */ FUNC
%token <int> INT
/* %token <float> FLOAT */
/*%token <string> STRING*/
/* %token <percent> FLOAT
%token <currency> FLOAT */
%token <string> VAR
%token EOF

/* %nonassoc ELSE */
%right ASSIGN /* AASSIGN SASSIGN MASSIGN DASSIGN */
%left EQ
%left GEQ GT LEQ LT
%left PLUS MINUS
%left TIMES DIVIDE /* MOD POWER */
/*%left OR*/
/*%left AND*/

%start /*expression*/ program
%type /*<Ast.expression> expression*/ <Ast.program> program


%%
program:
  decls EOF { $1 }

decls:
	| decls vdecl 			{ ($2 :: fst $1), snd $1 }
  | decls fdecl     {fst $1, ($2 :: snd $1) }

fdecl:
  FUNC /*type*/ VAR LPAREN args RPAREN COLON
  LBRACE statement_list RBRACE
  {
    {
      (*rtype = $2;*)
      name = $2;
      formals = $4;
      body = List.rev $8;
    }
  }

args:
  { [] }
  | arg_list {List.rev $1}

arg_list:
  VAR   { [$1] }
  | arg_list COMMA VAR /* would this be an expression */  {$3 :: $1}

/* vdecl_list:
  { [] }
  | vdecl_list vdecl  { $2 :: $1} */

vdecl:
  INTD VAR SEMI  {$2}
  | STRINGD VAR SEMI {$2}
  /* TODO dont forget other types!!! */

statement_list:
  { [] }
  | statement_list statement  {$2 :: $1}

statement:
  expression SEMI { Expr($1) }

expression:
 INT  {Int($1)}
 | VAR  {Var($1)}
 | expression PLUS expression  { Binop($1, Add, $3) }
 | expression MINUS  expression { Binop($1, Sub, $3) }
 | expression TIMES expression { Binop($1, Mult, $3 ) }
 | expression DIVIDE expression { Binop($1, Div, $3) }
 | expression EQ expression { Binop($1, Equal, $3) }
 | expression LT expression { Binop($1, Less, $3) }
 | expression LEQ expression { Binop($1, Leq, $3) }
 | expression GT expression { Binop($1, Greater, $3) }
 | expression GEQ expression { Binop($1, Geq, $3) }
 | VAR ASSIGN expression  { Assign($1, $3) }
 | VAR LPAREN expression RPAREN { Call($1, $3)} /* should be able to call multiple parameters */
 | LPAREN expression RPAREN   { $2 }

/*type:
  INTD { "int" }*/
