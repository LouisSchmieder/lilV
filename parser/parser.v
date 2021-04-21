module parser

import scanner
import error
import token
import ast

struct Parser {
mut:
	s &scanner.Scanner
	err []error.Error
	tok token.Token
	stmts []ast.Stmt
}

pub fn create_parser(s &scanner.Scanner) &Parser {
	return &Parser{
		s: s
		err: []error.Error{}
		stmts: []ast.Stmt{}
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
	}, p.err
}

fn (mut p Parser) parse_module() {
	mut name := 'main'
	if p.tok.kind == .key_module {
		p.next()
		name = p.get_name()
	}
	p.stmts << ast.ModuleStmt{
		pos: p.pos()
		name: name
	}
}

fn (mut p Parser) parse_top_stmt() {
	match p.tok.kind {
		.key_fn {
			p.stmts << p.function()
		}
		else {
			p.error('Unexpected top level stmt: `$p.tok.lit`')
		}
	}
}

fn (mut p Parser) next() {
	p.tok = p.s.scan()
}

fn (mut p Parser) get_name() string {
	if p.expect(.name) {
		return p.tok.lit
	}
	return ''
}

fn (mut p Parser) get_type() string {
	if p.expect(.name) {
		return p.tok.lit
	}
	return ''
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