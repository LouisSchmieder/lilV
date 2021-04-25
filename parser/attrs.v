module parser

import ast
import token

fn (mut p Parser) parse_attributes() ([]ast.Attribute, token.Position) {
	if p.tok.kind != .lsbr {
		return []ast.Attribute{}, p.pos()
	}
	pos := p.pos()
	mut attrs := []ast.Attribute{}
	for {
		p.next()
		attrs << p.parse_attribute()
		if p.tok.kind == .semicolon {
			continue
		} else {
			break
		}
	}
	p.expect(.rsbr)
	p.next()
	return attrs, pos
}

fn (mut p Parser) parse_attribute() ast.Attribute {
	mut name := ''
	mut kind := ast.AttributeKind.name
	if p.tok.kind == .string {
		kind = .string
		name = p.tok.lit[1..p.tok.lit.len - 1]
	} else if p.tok.kind == .name {
		name = p.tok.lit
	} else if p.tok.kind == .number {
		name = p.tok.lit
		kind = .number
	} else {
		p.expect(.name)
		return ast.Attribute{}
	}
	p.next()
	if p.tok.kind != .colon {
		return ast.Attribute{
			name: name
			name_kind: kind
			has_arg: false
		}
	}
	p.next()
	mut arg := ''
	mut arg_kind := ast.AttributeKind.name
	if p.tok.kind == .string {
		arg_kind = .string
		arg = p.tok.lit[1..p.tok.lit.len - 1]
	} else if p.tok.kind == .name {
		arg = p.tok.lit
	} else if p.tok.kind == .number {
		arg = p.tok.lit
		arg_kind = .number
	} else {
		p.expect(.name)
		return ast.Attribute{}
	}
	p.next()
	return ast.Attribute{
		name: name
		name_kind: kind
		has_arg: true
		arg: arg
		arg_kind: arg_kind

	}
}