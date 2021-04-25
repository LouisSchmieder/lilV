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
	consts strings.Builder
	types strings.Builder
	files []&ast.File
	file &ast.File
	table &types.Table
	writer &strings.Builder
}

pub fn create_gen(files []&ast.File) &Gen {
	return &Gen{
		builder: strings.new_builder(4096)
		headers: strings.new_builder(256)
		functions: strings.new_builder(1024)
		types: strings.new_builder(1024)
		consts: strings.new_builder(1024)
		files: files
		file: 0
		table: 0
		writer: 0
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
	end += g.consts.str()
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

fn (mut g Gen) wrln(str string) {
	g.writer.writeln(str)
}

fn (mut g Gen) wr(str string) {
	g.writer.write_string(str)
}

fn (mut g Gen) write(str string) {
	g.writer = &g.builder
	g.wr(str)
}

fn (mut g Gen) writeln(str string) {
	g.writer = &g.builder
	g.wrln(str)
}

fn (mut g Gen) hwrite(str string) {
	g.writer = &g.headers
	g.wr(str)
}

fn (mut g Gen) hwriteln(str string) {
	g.writer = &g.headers
	g.wrln(str)
}

fn (mut g Gen) fwrite(str string) {
	g.writer = &g.functions
	g.wr(str)
}

fn (mut g Gen) fwriteln(str string) {
	g.writer = &g.functions
	g.wrln(str)
}

fn (mut g Gen) twrite(str string) {
	g.writer = &g.types
	g.wr(str)
}

fn (mut g Gen) twriteln(str string) {
	g.writer = &g.types
	g.wrln(str)
}

fn (mut g Gen) cwrite(str string) {
	g.writer = &g.consts
	g.wr(str)
}

fn (mut g Gen) cwriteln(str string) {
	g.writer = &g.consts
	g.wrln(str)
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
		ast.ConstStmt {
			g.const_stmt(stmt)
		}
		ast.DeclareStmt {
			g.decl_stmt(stmt)
		}
		else {}
	}
}

fn (mut g Gen) expr(expr ast.Expr) {
	match expr {
		ast.IdentExpr {
			g.wr('$expr.name')
		}
		ast.CastExpr {
			g.wr('(($expr.typ.bname)')
			g.expr(expr.expr)
			g.wr(')')
		}
		ast.NumberExpr {
			g.wr('$expr.num')
		}
		ast.StringExpr {
			str := expr.str.all_before_last('\'')[1..]
			g.wr('"$str"')
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

fn (mut g Gen) const_stmt(stmt ast.ConstStmt) {
	for c in stmt.consts {
		name := '${g.file.mod}__$c.name'
		g.cwrite('#define $name ')
		g.expr(c.expr)
		g.cwriteln('')
	}
}

fn (mut g Gen) decl_stmt(stmt ast.DeclareStmt) {
	typ := g.file.get_type(stmt.expr).bname
	g.write('$typ $stmt.name = ')
	g.expr(stmt.expr)
	g.writeln(';')
}