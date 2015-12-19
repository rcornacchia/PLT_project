open Ast
open Sast

let check_function name = (* HAVE SOME BUILTIN FUNCTIONALITY HERE *)
  if name = "print" then "System.out.print"
  else name

let compile_dtype = function
  Inttype -> "int"
  | Stringtype -> "String"
  | Floattype -> "double"
  | Voidtype -> "void"

let compile_vdecl (vdecl: Ast.var_decl) =
  compile_dtype vdecl.dtype ^ " " ^ vdecl.vname

let rec compile_sexpression (sexpr: Sast.sexpression) =
  match sexpr.sexpr with 
    Sstring(str) -> str
    | Sint(i) -> string_of_int i
    | Sfloat(f) -> string_of_float f
    | Sbinop(expr1, op, expr2) -> (match op with 
                                    Pow -> "Math.pow(" ^ compile_sexpression expr1 ^ Ast.string_of_op op ^ compile_sexpression expr2 ^ ")"
                                    | And -> compile_sexpression expr1 ^ " " ^ Ast.string_of_op op ^ " " ^ compile_sexpression expr2 (* num to bool!! *)
                                    | Or -> compile_sexpression expr1 ^ " " ^ Ast.string_of_op op ^ " " ^ compile_sexpression expr2 (* num to bool!! *)
                                    | _ -> compile_sexpression expr1 ^ " " ^ Ast.string_of_op op ^ " " ^ compile_sexpression expr2)
    | Sassign(var, expr) -> var ^ " = " ^ compile_sexpression expr
    | Saassign(avar, aexpr) -> avar ^ " += " ^ compile_sexpression aexpr
    | Ssassign(svar, sexpr) -> svar ^ " -= " ^ compile_sexpression sexpr
    | Smassign(mvar, mexpr) -> mvar ^ " *= " ^ compile_sexpression mexpr
    | Sdassign(dvar, dexpr) -> dvar ^ " /= " ^ compile_sexpression dexpr
    | Svar(str) -> str
    | Scall(name, exprlst) -> check_function name ^ "(" ^ String.concat ", " (List.map compile_sexpression exprlst) ^ ")"
    | Snoexpr -> ""

let compile_sstatement = function
  Sexpr(expr) -> compile_sexpression expr ^ ";"
  | Svdecl(v) -> compile_vdecl v ^ ";"
  | Sret(r) -> "return " ^ compile_sexpression r ^ ";"

let compile_sfdecl (func: Sast.sfunc_decl) =
  if func.builtin then ("")
  else "public static " ^
       compile_dtype func.srtype ^
       " " ^
       func.sname ^
       "(" ^
       String.concat ", " (List.map compile_vdecl func.sformals) ^
       ") {\n" ^
       String.concat "\n" (List.map compile_sstatement func.sbody) ^
       "\n}"

let compile (sprogram: Sast.sprogram) (filename: string) =
  "import java.lang.Math;\npublic class " ^ (* IMPORT FINL JAVA FILES *)
  filename ^ 
  " {\n" ^
  String.concat "\n" (List.map compile_sfdecl sprogram.sfunc_decls) ^
  "\npublic static void main(String[] args) {\n" ^
  String.concat "\n" (List.map compile_sstatement sprogram.sstatements) ^
  "\n}\n}"