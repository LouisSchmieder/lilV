module parser

import ast
import token

fn (mut p Parser) consts(is_pub bool) ast.ConstStmt {
	pos := p.pos()
	p.next()
	if p.tok.kind != .lpar {
		c := [p.parse_const_line()]
		return ast.ConstStmt {
			pos: pos
			is_pub: is_pub
			consts: c
		}
	}
	p.next()
	mut consts := []ast.Const{}
	for p.tok.kind == .name {
		consts << p.parse_const_line()
	}
	p.expect(.rpar)
	p.next()
	return ast.ConstStmt{
		pos: pos
		is_pub: is_pub
		consts: consts
	}
}

fn (mut p Parser) parse_const_line() ast.Const {
	pos := p.pos()
	name := p.get_name()
	p.next()
	p.expect(.assign)
	p.next()
	expr := p.expr()
	return ast.Const{
		pos: pos
		name: name
		expr: expr
	}
}

fn (mut p Parser) decl_stmt(pos token.Position, name string) ast.DeclareStmt {
	p.next()
	expr := p.expr()
	return ast.DeclareStmt{
		pos: pos
		name: name
		expr: expr
	}
}