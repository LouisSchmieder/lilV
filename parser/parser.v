module parser

import scanner
import error
import token
import types
import ast

struct Parser {
mut:
	s &scanner.Scanner
	table &types.Table
	err []error.Error
	tok token.Token
	stmts []ast.Stmt
	mod string
}

pub fn create_parser(s &scanner.Scanner) &Parser {
	return &Parser{
		s: s
		err: []error.Error{}
		stmts: []ast.Stmt{}
		table: types.create_default_table()
	}
}

pub fn (mut p Parser) parse_file() (ast.File, []error.Error) {
	p.next()
	p.parse_module()

	p.next()
	for p.tok.kind != .eof {
		p.parse_top_stmt()
		p.next()
	}

	return ast.File{
		stmts: p.stmts
		table: p.table
	}, p.err
}

fn (mut p Parser) parse_module() {
	mut name := 'main'
	if p.tok.kind == .key_module {
		p.next()
		name = p.get_name()
	}
	p.mod = name
	p.stmts << ast.ModuleStmt{
		pos: p.pos()
		name: name
	}
}

fn (mut p Parser) parse_top_stmt() {
	mut is_pub := false
	tmp := p.tok
	attrs := p.parse_attributes()
	if p.tok.kind == .key_pub {
		is_pub = true
	}
	if p.tok.kind !in [.key_fn, .key_enum, .key_struct] {
		if attrs.len > 0 {
			tmp_2 := p.tok
			p.tok = tmp
			p.error('Unexpected attribute')
			p.tok = tmp_2
		}
	}
	match p.tok.kind {
		.key_fn {
			p.stmts << p.function(is_pub, attrs)
		}
		else {
			p.error('Unexpected top level stmt: `$p.tok.lit`')
		}
	}
}

fn (mut p Parser) parse_stmt() ?ast.Stmt {
	if p.tok.kind != .name {
		return error('')
	}
	pos := p.tok.pos
	mut mod := p.tok.lit
	mut function := p.tok.lit
	p.next()
	if p.tok.kind == .dot {
		p.next()
		p.expect(.name)
		function = p.tok.lit
		p.next()
	}
	p.expect(.lpar)

	mut parameter := []ast.Expr{}

	for {
		p.next()
		parameter << p.expr()
		p.next()
		if p.tok.kind != .comma {
			break
		}
	}
	p.expect(.rpar)
	p.next()

	if mod == function {
		mod = p.mod
	}

	return ast.FunctionCallStmt{
		name: function
		mod: mod
		pos: pos
		params: parameter
	}
}

fn (mut p Parser) expr() ast.Expr {
	pos := p.tok.pos
	match p.tok.kind {
		.string {
			return ast.StringExpr{
				pos: pos
				str: p.tok.lit
			}
		}
		.number {
			return ast.NumberExpr{
				pos: pos
				num: p.tok.lit
			}
		}
		.name {
			return ast.IdentExpr{
				pos: pos
				name: p.tok.lit
			}
		}
		else {
			return ast.StringExpr{}
		}
	}
}

fn (mut p Parser) next() {
	p.tok = p.s.scan()
	if p.tok.kind == .comment {
		// do nothing for now
		p.next()
	}
}

fn (mut p Parser) get_name() string {
	if p.expect(.name) {
		return p.tok.lit
	}
	return ''
}

fn (mut p Parser) get_type() types.Type {
	mut lit := ''
	if p.tok.kind != .name {
		typ := p.table.find_type('void') or {
			p.error(err.msg)
			return types.Type{}
		}
		return typ
	}
	lit += p.tok.lit
	tmp := p.tok
	p.next()
	for p.tok.kind == .dot {
		lit += '.'
		p.next()
		p.expect(.name)
		lit += p.tok.lit
		p.next()
	}
	typ := p.table.find_type(lit) or {
		tmp_2 := p.tok
		p.tok = tmp
		p.tok.lit = lit
		p.error(err.msg)
		p.tok = tmp_2
		return types.Type{}
	}
	return typ
}

fn (mut p Parser) expect(kind token.Kind) bool {
	if p.tok.kind != kind {
		p.error('Unexpected token `$p.tok.lit` expected `$kind`')
		return false
	}
	return true
}

fn (mut p Parser) pos() token.Position {
	return p.tok.pos
}

fn (mut p Parser) error(msg string) {
	p.err << error.Error{
		pos: p.tok.pos
		len: p.tok.lit.len
		level: .error
		msg: msg
	}
}