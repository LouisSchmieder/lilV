module parser

import ast
import types

fn (mut p Parser) function(is_pub bool, attrs []ast.Attribute) ast.FunctionStmt {
	p.next()
	pos := p.tok.pos
	name := p.get_name()
	parameter := p.parameter()
	p.next()
	mut ret := p.get_type()
	p.expect(.lcbr)
	p.next()

	// mut stmts := []ast.Stmt{}

	/*for {
		stmts << p.parse_stmt() or {
			break
		}
	}`*/

	//p.next()
	p.expect(.rcbr)
	return ast.FunctionStmt{
		pos: pos
		is_pub: is_pub
		name: name
		ret: ret
		parameter: parameter
		attrs: attrs
	}
}

fn (mut p Parser) parameter() []ast.Parameter {
	mut params := []ast.Parameter{}
	p.next()
	p.expect(.lpar)
	p.next()
	for p.tok.kind != .rpar {
		pos := p.tok.pos
		name := p.get_name()
		p.next()
		typ := p.get_type()
		params << ast.Parameter{
			pos: pos
			typ: typ
			name: name
		}
		if p.tok.kind != .comma {
			break
		}
	}
	p.expect(.rpar)
	return params
}