module fmt

import ast
import strings
import error
import token

const (
	tabs = '\t\t\t\t\t\t\t\t\t\t\t'
)

pub struct Fmt {
mut:
	builder strings.Builder
	level int
	file &ast.File
	last_pos token.Position
	pos token.Position
	next_nl int
}

pub fn create_fmt(file &ast.File) &Fmt {
	return &Fmt {
		builder: strings.new_builder(1024)
		level: 0
		file: file
		next_nl: 0
	}
}

pub fn (mut f Fmt) format() string {
	for stmt in f.file.stmts {
		f.stmt(stmt)
	}
	f.builder.write_string('\n')
	return f.builder.str()
}

fn (mut f Fmt) up() {
	f.level++
}

fn (mut f Fmt) down() {
	f.level--
}

fn (mut f Fmt) nl() {
	f.next_nl++
}

fn (mut f Fmt) write(s string, data ...bool) {
	if (f.pos.line_nr > f.last_pos.line_nr) || (data.len > 0 && data[0]) {
		f.builder.write_string('\n'.repeat(f.next_nl + 1)) 
		f.builder.write_string(tabs[..f.level])
		f.next_nl = 0
	}
	f.builder.write_string(s)
	f.last_pos = f.pos
}

fn (mut f Fmt) stmt(stmt ast.Stmt) {
	match stmt {
		ast.ModuleStmt {
			f.module_stmt(stmt)
		}
		ast.CommentStmt {
			f.comment_stmt(stmt)
		}
		ast.ImportStmt {
			f.import_stmt(stmt)
		}
		ast.FunctionStmt {
			f.function_stmt(stmt)
		}
		ast.FunctionCallStmt {
			f.function_call_stmt(stmt)
		}
		ast.IfStmt {
			f.if_stmt(stmt)
		}
		else {}
	}
}

fn (mut f Fmt) expr(expr ast.Expr) {
	match expr {
		ast.StringExpr {
			f.string_expr(expr)
		}
		ast.NumberExpr {
			f.number_expr(expr)
		}
		ast.IdentExpr {
			f.ident_expr(expr)
		}
		else {}
	}
}

fn (mut f Fmt) module_stmt(stmt ast.ModuleStmt) {
	f.pos = stmt.pos
	f.write('module $stmt.name')
	f.nl()
}

fn (mut f Fmt) comment_stmt(stmt ast.CommentStmt) {
	f.pos = stmt.pos
	mut msg := stmt.msg.replace_each(['/*', '', '*/', '', '//', '']).trim_space()
	if !stmt.multiline {
		f.write('// $msg')
	}
}

fn (mut f Fmt) import_stmt(stmt ast.ImportStmt) {
	f.pos = stmt.pos
	f.write('import $stmt.mod')
	if stmt.has_as {
		f.write(' as $stmt.alias')
	}
	f.nl()
}

fn (mut f Fmt) attributes(attrs []ast.Attribute, pos token.Position) {
	f.pos = pos
	f.write('[')
	for i, attr in attrs {
		match attr.name_kind {
			.string {
				f.write('\'$attr.name\'')
			}
			else {
				f.write('$attr.name')
			}
		}
		if attr.has_arg {
			match attr.arg_kind {
				.string {
					f.write(': \'$attr.arg\'')
				}
				else {
					f.write(': $attr.arg')
				}
			}
		}
		if i < attrs.len - 1 {
			f.write('; ')
		}
	}
	f.write(']')
}

fn (mut f Fmt) function_stmt(stmt ast.FunctionStmt) {
	if stmt.attrs.len > 0 {
		f.attributes(stmt.attrs, stmt.attrs_pos)
	}
	f.pos = stmt.pos
	if stmt.is_pub {
		f.write('pub ')
	}
	f.write('fn $stmt.name ')
	f.write('(')
	for i, param in stmt.parameter {
		f.write('$param.name $param.typ.name')
		if i < stmt.parameter.len - 1 {
			f.write(', ')
		}
	}
	f.write(')')

	if f.file.table.get_idx(stmt.ret.name) != 9 {
		f.write(' $stmt.ret.name')
	}

	f.write(' {')
	f.up()

	for s in stmt.stmts {
		f.stmt(s)
	}

	f.down()
	f.pos = stmt.pos
	f.write('}', stmt.stmts.len > 0)
	f.nl()
}

fn (mut f Fmt) function_call_stmt(stmt ast.FunctionCallStmt) {
	f.pos = stmt.pos
	if stmt.mod != '' {
		f.write('${stmt.mod}.')
	}
	f.write('${stmt.name} (')

	for i, expr in stmt.params {
		f.expr(expr)
		if i > stmt.params.len - 1 {
			f.write(', ')
		}
	}

	f.write(')')
}

fn (mut f Fmt) if_stmt(stmt ast.IfStmt) {
	f.pos = stmt.pos
	f.write('if ')
	f.expr(stmt.cond)
	f.write(' {')
	f.up()
	for s in stmt.stmts {
		f.stmt(s)
	}
	f.down()
	for el in stmt.elses {
		f.else_stmt(el)
	}
	f.write('} ', true)
}

fn (mut f Fmt) else_stmt(stmt ast.ElseStmt) {
	f.pos = stmt.pos
	f.write('} else')
	if stmt.has_cond {
		f.write(' if ')
		f.expr(stmt.cond)
	}
	f.write(' {')
	f.up()
	for s in stmt.stmts {
		f.stmt(s)
	}
	f.down()
}

fn (mut f Fmt) string_expr(expr ast.StringExpr) {
	f.write(expr.str)
}

fn (mut f Fmt) number_expr(expr ast.NumberExpr) {
	f.write(expr.num)
}

fn (mut f Fmt) ident_expr(expr ast.IdentExpr) {
	f.write(expr.name)
}
