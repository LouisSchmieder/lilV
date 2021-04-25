module parser

import ast
import token

fn (mut p Parser) function(is_pub bool, attrs []ast.Attribute, attrs_pos token.Position) ast.FunctionStmt {
	p.next()
	pos := p.tok.pos
	name := p.get_name()
	parameter := p.parameter()
	p.next()
	mut ret := p.get_type()
	stmts := p.parse_block()
	return ast.FunctionStmt{
		pos: pos
		is_pub: is_pub
		name: name
		ret: ret
		parameter: parameter
		attrs: attrs
		attrs_pos: attrs_pos
		mod: p.mod
		stmts: stmts
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