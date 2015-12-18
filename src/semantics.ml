open Ast
open Sast

exception Except of string

let builtin_functions = 
	[ {
		sname = "print";
		sformals = [];
		sbody = [];
		srtype = Inttype; (*TEMPORARY*) 
		builtin = true; } ]

type environment = {
	function_table : Sast.sfunc_decl list;
	symbol_table : Ast.var_decl list;
	checked_statements : Ast.statement list;
}

let root_env = {
	function_table = builtin_functions;
	symbol_table = [];
	checked_statements = [];
}

let name_to_sname env name =
	let sname =
		if name = "reserved" then (raise (Except("'reserved' is a reserved function name!")))
		else 
			if name = "main" then ("reserved")
			else name
	in
	try
		let func = List.find (fun f -> f.sname = sname) env.function_table in
		if func.builtin then (raise (Except(func.sname ^ " is a built in function!")))
		else raise (Except(func.sname ^ " is already defined!"))
	with Not_found -> sname

let formal_to_sformal sformals (formal: Ast.var_decl) =
	let found = List.exists (fun sf -> formal.vname = sf.vname) sformals in
	if found then raise (Except("Formal parameter '" ^ formal.vname ^ "' is already defined!"))
	else formal :: sformals

let analyze_vdecl env (vdecl: Ast.var_decl) =
	let found = List.exists (fun symbol -> symbol.vname = vdecl.vname) env.symbol_table in
	if found then raise (Except("Variable '" ^ vdecl.vname ^ "' is already defined!"))
	else vdecl

let check_for_main name =
	let new_name = 
		if name = "main" then "reserved"
		else name
	in new_name

(*let check_type env expression =
	match expression with
		Int(i) -> Inttype
		| String(s) -> Stringtype
		| Var(v) -> (* FIND IN TABLE *)
		| Binop(e1, o, e2) -> (* TO DO *)
		| Assign(a, e) -> Assign(a, e
		| Call(c, el) -> check_for_main c el

let check_formals formal expression =
	if formal.dtype <> check_type expression then raise (Except("Function parameter type mismatch!"))*)

let analyze_expression env (expression: Ast.expression) = (* DO TYPE CHECKING!!! *)
	match expression with
		Int(i) -> 				Int(i)
		
		| String(s) -> 			String(s)
		
		| Var(v) -> 			let found = List.exists (fun symbol -> symbol.vname = v) env.symbol_table in
								if found then (Var(v))
								else raise (Except("Symbol '" ^ v ^ "' is uninitialized!"))
		
		| Binop(e1, o, e2) -> 	(*let type1 = check_type env e1
							  	and type2 = check_type env e2
							  	in let sametype = type1 = type2 in
							  	if sametype then (Binop(e1, o, e2))
							  	else raise (Except("binop type mismatch!"))*)
								Binop(e1, o, e2)
		| Assign(a, e) -> 		(*try let vdecl = List.find (fun s -> s.vname = a) env.symbol_table in
									let dtype = vdecl.dtype in
									let etype = check_type env e in
									let sametype = dtype = etype in
									if sametype then (Assign(a, e))
									else raise Except("Symbol '" ^ a ^ "' is of type " ^ dtype ^ ", not of type " ^ etype ^ ".")
						  		with raise (Except("Symbol '" ^ a ^ "' not initialized!"))*)
								Assign(a, e)
		| Call(c, el) -> 		(*let name = check_for_main c in
						 		try let func = List.find (fun f -> f.sname = sname) env.function_table in
						 			try List.iter2 checkformals func.formals el
						 			with raise (Except("Wrong argument length to function '" ^ func ^ "'."))
						 		with raise (Except("Function '" ^ c ^ "' not found!"))*)
								Call(check_for_main c, el)

let analyze_statement env (statement: Ast.statement) =
	match statement with
		Expr(e) -> let checked_expression = analyze_expression env e in
				   let checked_statement = Expr(checked_expression) in
				   let new_env = { function_table = env.function_table;
								   symbol_table = env.symbol_table; 
								   checked_statements = checked_statement :: env.checked_statements; }
				   in new_env 
		| Vdecl(v) -> let checked_vdecl = analyze_vdecl env v in
					  let checked_statement = Vdecl(checked_vdecl) in
					  let new_env = { function_table = env.function_table;
									  symbol_table = checked_vdecl :: env.symbol_table; 
									  checked_statements = checked_statement :: env.checked_statements; } 
					  in new_env
		| Ret(r) -> let checked_expression = analyze_expression env r in
							 let checked_statement = Ret(checked_expression) in
							 let new_env = { function_table = env.function_table;
										 	 symbol_table = env.symbol_table;
										 	 checked_statements = checked_statement :: env.checked_statements; }
							 in new_env (* TO DO *)
					

let fdecl_to_sfdecl env (fdecl: Ast.func_decl) =
	let checked_name = name_to_sname env fdecl.name in
	let checked_formals = List.fold_left formal_to_sformal [] fdecl.formals in
	let func_env = { function_table = env.function_table; 
					 symbol_table = checked_formals; 
					 checked_statements = []; }
	in 
	let func_env = List.fold_left analyze_statement func_env fdecl.body in
	let sfdecl = { sname = checked_name;
				   sformals = List.rev checked_formals;
				   sbody = List.rev func_env.checked_statements;
				   srtype = fdecl.rtype;
				   builtin = false; }
	in
	let new_env = { function_table = sfdecl :: env.function_table; 
					symbol_table = env.symbol_table;
					checked_statements = env.checked_statements; }
	in
	new_env

let analyze_line env (line: Ast.line) =
	match line with
		Stmt(s) -> analyze_statement env s
		| Fdecl(f) -> fdecl_to_sfdecl env f

let analyze (program: Ast.program) =
	let new_env = List.fold_left analyze_line root_env program.lines in
	let sprogram = { sfunc_decls = new_env.function_table; 
					 statements = List.rev new_env.checked_statements; }
	in sprogram