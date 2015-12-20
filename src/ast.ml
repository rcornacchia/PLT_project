type binop = Add | Mult | Div | Equal | Neq | Less | Leq | Greater | Geq | Mod | Pow | And | Or | Sub
type unop = Neg | Not

type data_type =
  Inttype
  | Stringtype
  | Floattype
  | Stocktype
  | Voidtype

type var_decl = {
  dtype : data_type;
  vname : string;
}

type expression =
  Int of int
  | String of string
  | Float of float
  | Stock of string
  | Var of string
  | Unop of unop * expression
  | Binop of expression * binop * expression
  | Assign of string * expression
  | Aassign of string * expression
  | Sassign of string * expression
  | Massign of string * expression
  | Dassign of string * expression
  | Call of string * expression list
  | Noexpr (* possibly take out *)

type statement =
  Expr of expression
  | While of expression * statement list
  | When of expression * statement list
  | If of expression * statement list
  | Vdecl of var_decl
  | Ret of expression

type func_decl = {
  rtype : data_type;
  name : string;
  formals : var_decl list;
  body : statement list;
}

type line =
  Stmt of statement
  | Fdecl of func_decl

type program = { 
    lines : line list;
}

let string_of_binop = function
  Add -> "+"
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | Leq -> "<="
  | Greater -> ">"
  | Geq -> ">="
  | Mod -> "%"
  | Pow -> ", "
  | And -> "&&"
  | Or -> "||"

let string_of_unop = function
  Neg -> "-"
  | Not -> "!"

let string_of_data_type = function
  Inttype -> "int"
  | Stringtype -> "string"
  | Floattype -> "float"
  | Stocktype -> "stock"
  | Voidtype -> "void"

let rec string_of_expression = function
  Int(i) -> "Int(" ^ string_of_int i ^ ")"
  | String(s) -> "String(" ^ s ^ ")"
  | Float(f) -> "Float(" ^ string_of_float f ^ ")"
  | Stock(stk) -> "Stock(" ^ stk ^ ")"
  | Var(v) -> "Var(" ^ v ^ ")"
  | Unop(op, e) -> "Unop(" ^ string_of_unop op ^ " " ^ string_of_expression e ^ ")"
  | Binop(e1, o, e2) -> "Binop(" ^ string_of_expression e1 ^ " " ^ string_of_binop o ^ " " ^ string_of_expression e2 ^ ")"
  | Assign(a, e) -> "Assign(" ^ a ^ " = " ^ string_of_expression e ^ ")"
  | Aassign(aa, e) -> "Aassign(" ^ aa ^ " = " ^ string_of_expression e ^ ")"
  | Sassign(sa, e) -> "Sassign(" ^ sa ^ " = " ^ string_of_expression e ^ ")"
  | Massign(ma, e) -> "Massign(" ^ ma ^ " = " ^ string_of_expression e ^ ")"
  | Dassign(da, e) -> "Dassign(" ^ da ^ " = " ^ string_of_expression e ^ ")"
  | Call(c, el) -> c ^ "(" ^ String.concat ", " (List.map string_of_expression el) ^ ")"
  | Noexpr -> ""

let string_of_vdecl (vdecl: var_decl) = 
  "vdecl{" ^ vdecl.vname ^ " -> " ^ string_of_data_type vdecl.dtype ^ "}"

let rec string_of_statement = function
  Expr(e) -> "expression{" ^ string_of_expression e ^ "}"
  | If(expr, slst) -> "if{\n(" ^ 
                      string_of_expression expr ^ 
                      ") statementlist{\nstatement{" ^ 
                      String.concat "}\nstatement{" (List.map string_of_statement slst) ^
                      "}\n}\n}"
  | While(expr, slst) -> "while{\n(" ^ 
                         string_of_expression expr ^ 
                         ") statementlist{\nstatement{" ^ 
                         String.concat "}\nstatement{" (List.map string_of_statement slst) ^
                         "}\n}\n}"
  | When(expr, slst) -> "when{\n(" ^ 
                         string_of_expression expr ^ 
                         ") statementlist{\nstatement{" ^ 
                         String.concat "}\nstatement{" (List.map string_of_statement slst) ^
                         "}\n}\n}"
  | Vdecl(v) -> string_of_vdecl v
  | Ret(r) -> "return{" ^ string_of_expression r ^ "}"

let string_of_fdecl (fdecl: func_decl) =
  "name{" ^ 
  fdecl.name ^ 
  "} rtype{" ^
  string_of_data_type fdecl.rtype ^
  "} formals{" ^ 
  String.concat ", " (List.map string_of_vdecl fdecl.formals) ^ 
  "}\nbody{\nstatement{" ^
  String.concat "}\nstatement{" (List.map string_of_statement fdecl.body) ^
  "}\n}"

let string_of_line = function
  Stmt(s) -> "statement{" ^ string_of_statement s ^ "}"
  | Fdecl(f) -> "fdecl{\n" ^ string_of_fdecl f ^ "\n}"

let string_of_program (prog: program) =
  "program{\nline{\n" ^ String.concat "\n}\nline{\n" (List.map string_of_line prog.lines) ^ "\n}\n}\n"