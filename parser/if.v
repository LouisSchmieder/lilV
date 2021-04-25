module parser

import ast

fn (mut p Parser) parse_if() ast.IfStmt {
	p.expect(.key_if)
	pos := p.tok.pos
	p.next()
	expr := p.expr()
	stmts := p.parse_block()
	mut elses := []ast.ElseStmt{}
	for {
		p.next()
		epos := p.tok.pos
		if p.tok.kind != .key_else {
			break
		}
		p.next()
		has_cond := p.tok.kind == .key_if
		mut e := ast.Expr(ast.Unknown{})
		if has_cond {
			p.next()
			e = p.expr()
		}
		block := p.parse_block()
		elses << ast.ElseStmt{
			pos: epos
			has_cond: has_cond
			cond: e
			stmts: block
		}
	}
	return ast.IfStmt{
		pos: pos
		cond: expr
		stmts: stmts
		elses: elses
	}
}