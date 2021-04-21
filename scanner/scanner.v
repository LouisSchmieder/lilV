module scanner

import token

struct Scanner {
	data []byte
	filename string
mut:
	pos int
	line_nr int
	char_nr int
	lit []byte
}

pub fn create_scanner(input string, filename string) &Scanner {
	return &Scanner{
		data: input.bytes()
		filename: filename
		pos: 0
		line_nr: 0
		char_nr: 0
		lit: []byte{len: 1}
	}
}

pub fn (mut s Scanner) scan() token.Token {
	s.lit = []byte{len: 1}
	mut c := s.next(false)

	for {
		if c == 0 {
			return token.create_token(.eof, s.filename, s.line_nr, s.char_nr, s.lit)
		} else if c == ` ` || c == `\t` {
			c = s.next(false)
			continue
		} else if c == `\n` {
			c = s.next(false)
			s.char_nr = 0
			s.line_nr++
			continue
		}
		break
	}
	match c {
		`+` {
			if c == s.th_next() {
				s.next(true)
				return token.create_token(.inc, s.filename, s.line_nr, s.char_nr, s.lit)
			}
			return token.create_token(.plus, s.filename, s.line_nr, s.char_nr, s.lit)
		}
		`-` {
			if c == s.th_next() {
				s.next(true)
				return token.create_token(.dec, s.filename, s.line_nr, s.char_nr, s.lit)
			}
			return token.create_token(.minus, s.filename, s.line_nr, s.char_nr, s.lit)
		}
		`'`, `"` {
			ch := c
			for {
				c = s.next(true)
				if c == ch {
					break
				}
			}
			return token.create_token(.string, s.filename, s.line_nr, s.char_nr, s.lit)
		}
		else {
			if s.is_number(c) {
				for s.is_number(s.th_next()) {
					s.next(true)
				}
				return token.create_token(.number, s.filename, s.line_nr, s.char_nr, s.lit)
			} else if s.is_name(c) {
				for s.is_name(s.th_next()) {
					s.next(true)
				}
				return token.create_token(.name, s.filename, s.line_nr, s.char_nr, s.lit)
			}
		}
	}
	return token.create_token(.unknown, s.filename, s.line_nr, s.char_nr, s.lit)
}

fn (mut s Scanner) next(app bool) byte {
	mut b := byte(0)
	if s.pos < s.data.len {
		b = s.data[s.pos]
		if app {
			s.lit << b
		} else {	
			s.lit[0] = b
		}
		s.pos++
		s.char_nr++
	}
	return b
}

fn (mut s Scanner) th_next() byte {
	mut b := byte(0)
	if s.pos < s.data.len {
		b = s.data[s.pos]
	}
	return b
}

fn (mut s Scanner) is_number(b byte) bool {
	return (b >= `0` && b <= `9`)
}

fn (mut s Scanner) is_name(b byte) bool {
	return s.is_number(b) || b == `_` || (b >= `a` && b <= `z`) || (b >= `A` && b <= `Z`)
} 