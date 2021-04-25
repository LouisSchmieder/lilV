module gen

import strings
import ast
import error
import types

struct Gen {
mut:
	builder strings.Builder
	headers strings.Builder
	functions strings.Builder
	types strings.Builder
	files []&ast.File
	file &ast.File
	table &types.Table
}

pub fn create_gen(files []&ast.File) &Gen {
	return &Gen{
		builder: strings.new_builder(4096)
		headers: strings.new_builder(256)
		functions: strings.new_builder(1024)
		types: strings.new_builder(1024)
		files: files
		file: 0
		table: 0
	}
}

pub fn (mut g Gen) gen() string {
	for file in g.files {
		g.file = file
		g.table = file.table
		g.gen_file()
	}
	mut end := ''
	end += g.headers.str()
	end += g.types.str()
	end += g.functions.str()
	end += g.builder.str()
	return end	
}

fn (mut g Gen) gen_file() {
	g.gen_types()
	for stmt in g.file.stmts {
		g.stmt(stmt)
	}
}

fn (mut g Gen) gen_types() {
	for typ in g.table.types {
		g.twrite('typedef ')
		info := typ.info
		match info {
			types.Builtin {
				g.twrite(info.cbase)
			}
			types.Struct {
				g.twrite('struct {')

				g.twrite('}')
			}
			else {}
		}
		g.twriteln(' $typ.bname;')
	}
}

fn (mut g Gen) write(str string) {
	g.builder.write_string(str)
}

fn (mut g Gen) writeln(str string) {
	g.builder.writeln(str)
}

fn (mut g Gen) hwrite(str string) {
	g.headers.write_string(str)
}

fn (mut g Gen) hwriteln(str string) {
	g.headers.writeln(str)
}

fn (mut g Gen) fwrite(str string) {
	g.functions.write_string(str)
}

fn (mut g Gen) fwriteln(str string) {
	g.functions.writeln(str)
}

fn (mut g Gen) twrite(str string) {
	g.types.write_string(str)
}

fn (mut g Gen) twriteln(str string) {
	g.types.writeln(str)
}

fn (mut g Gen) stmt(stmt ast.Stmt) {
	match stmt {
		ast.FunctionStmt{
			g.function_stmt(stmt)
		}
		ast.FunctionCallStmt {
			g.function_call_stmt(stmt)
		}
		ast.ReturnStmt{
			g.return_stmt(stmt)
		}
		ast.IfStmt {
			g.if_stmt(stmt)
		}
		else {}
	}
}

fn (mut g Gen) expr(expr ast.Expr) {
	match expr {
		ast.IdentExpr {
			g.write('$expr.name')
		}
		ast.CastExpr {
			g.write('(($expr.typ.bname)')
			g.expr(expr.expr)
			g.write(')')
		}
		ast.NumberExpr {
			g.write('$expr.num')
		}
		ast.StringExpr {
			g.write('"$expr.str"')
		}
		else {}
	}
}

fn (mut g Gen) function_stmt(stmt ast.FunctionStmt) {
	name := '${stmt.mod}__$stmt.name'
	typ := stmt.ret.bname
	mut line := '$typ ${name}('

	for i, p in stmt.parameter {
		line += '$p.typ.bname $p.name'
		if i > stmt.parameter.len - 1 {
			line += ', '
		}
	}
	line += ')'
	g.fwriteln('$line;')
	g.writeln('$line {')

	for s in stmt.stmts {
		g.stmt(s)
	}

	g.writeln('}')
}

fn (mut g Gen) function_call_stmt(stmt ast.FunctionCallStmt) {
	name := '${stmt.mod}__$stmt.name'
	g.write('${name}(')
	for expr in stmt.params {
		g.expr(expr)
	}
	g.writeln(');')
}

fn (mut g Gen) return_stmt(stmt ast.ReturnStmt) {
	g.write('return ')
	g.expr(stmt.expr)
	g.writeln(';')
}

fn (mut g Gen) if_stmt(stmt ast.IfStmt) {
	g.write('if (')
	g.expr(stmt.cond)
	g.writeln('){')
	for s in stmt.stmts {
		g.stmt(s)
	}
	for el in stmt.elses {
		g.else_stmt(el)
	}
	g.writeln('}')
}

fn (mut g Gen) else_stmt(stmt ast.ElseStmt) {
	g.write('} else')
	if stmt.has_cond {
		g.write(' if(')
		g.expr(stmt.cond)
		g.write(')')	
	}
	g.writeln(' {')
	for s in stmt.stmts {
		g.stmt(s)
	}
}