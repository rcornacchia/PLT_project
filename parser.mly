%{ open Ast
%}


%token SEMI LPAREN RPAREN LBRACE RBRACE COMMA COLON AT
%token POWER
%token PLUS MINUS TIMES DIVIDE
%token MOD
%token ASSIGN AASSIGN SASSIGN MASSIGN DASSIGN
%token EQ GEQ GT LEQ LT
%token RETURN WHILE WHEN IF ELSE ELSEIF VOID NULL BREAK
%token AND OR NOT
%token INTD FLOATD PERCENT ARRAY STRING CURR STOCK ORDER PF FUNC
%token <int> INT
%token <float> FLOAT
%token <string> STR
%token <percent> FLOAT
%token <currency> FLOAT
%token EOF

%nonassoc ELSE 
%right ASSIGN AASSIGN SASSIGN MASSIGN DASSIGN
%left EQ
%left GEQ GT LEQ LT
%left PLUS MINUS
%left TIMES DIVIDE MOD
%left OR
%left AND
