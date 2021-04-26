module parser

import token
import ast

fn (mut p Parser) parse_struct(ip bool, attrs []ast.Attribute, attrs_pos token.Position) ast.StructStmt {
	p.next()
	pos := p.pos()
	name := p.get_name()
	p.next()
	p.expect(.lcbr)
	p.next()
	// parse fields
	mut fields := []ast.StructField{}
	mut is_pub := false
	mut is_mut := false
	for p.tok.kind != .rcbr {
		if p.tok.kind != .name {
			if p.tok.kind == .key_pub {
				p.next()
				is_pub = true
				is_mut = false
				if p.tok.kind == .key_mut {
					p.next()
					is_mut = true
				}
				p.expect(.colon)
			} else if p.tok.kind == .key_mut {
				p.next()
				is_pub = false
				is_mut = true
				p.expect(.colon)
			} else {
				p.expect(.name)
			}
			p.next()
		}
		field_pos := p.pos()
		field_name := p.get_name()
		p.next()
		field_type := p.get_type()
		a, ap := p.parse_attributes()
		fields << ast.StructField {
			pos: field_pos
			name: field_name
			typ: field_type
			is_pub: is_pub
			is_mut: is_mut
			attrs: a
			attrs_pos: ap
		}
	}
	p.next()
	if p.table.get_idx(name) != 0 {
		p.errorp('Type `$name` already exists', pos, name.len)
		return ast.StructStmt{}
	}
	return ast.StructStmt {
		pos: pos
		is_pub: ip
		name: name
		attrs: attrs
		attrs_pos: attrs_pos
		fields: fields
	}
}

fn (mut p Parser) parse_sumtype(is_pub bool) ast.SumtypeStmt {
	p.next()
	p.next = false
	pos := p.pos()
	name := p.get_name()
	p.next()
	p.expect(.assign)
		p.next()
	mut names := []string{}
	for p.tok.kind == .name {
		names << p.get_name()
		p.next()
		if p.tok.kind != .pipe {
			break
		}
		p.next()
	}
	return ast.SumtypeStmt{
		pos: pos
		is_pub: is_pub
		name: name
		names: names
	}
}