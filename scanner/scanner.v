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
	mut c, _ := s.next(false)

	if c == 0 {
		return token.create_token(.eof, s.filename, s.line_nr, s.char_nr, s.lit)
	}
	char_nr := s.char_nr
	match c {
		`+` {
			if c == s.th_next() {
				s.next(true)
				return token.create_token(.inc, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.plus_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.plus, s.filename, s.line_nr, char_nr, s.lit)
		}
		`-` {
			if c == s.th_next() {
				s.next(true)
				return token.create_token(.dec, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.plus_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.minus, s.filename, s.line_nr, char_nr, s.lit)
		}
		`*` {
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.mult_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.mul, s.filename, s.line_nr, char_nr, s.lit)
		}
		`/` {
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.div_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.div, s.filename, s.line_nr, char_nr, s.lit)
		}
		`%` {
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.mod_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.mod, s.filename, s.line_nr, char_nr, s.lit)
		}
		`^` {
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.xor_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.xor, s.filename, s.line_nr, char_nr, s.lit)
		}
		`|` {
			if c == s.th_next() {
				s.next(true)
				return token.create_token(.logical_or, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.or_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.pipe, s.filename, s.line_nr, char_nr, s.lit)
		}
		`&` {
			if c == s.th_next() {
				s.next(true)
				return token.create_token(.and, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.and_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.amp, s.filename, s.line_nr, char_nr, s.lit)
		}
		`:` {
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.decl_assign, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.colon, s.filename, s.line_nr, char_nr, s.lit)
		}
		`!` {
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.ne, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `i` {
				s.next(true)
				if s.th_next() == `s` {
					return token.create_token(.not_is, s.filename, s.line_nr, char_nr, s.lit)
				} else if s.th_next() == `n` {
					return token.create_token(.not_in, s.filename, s.line_nr, char_nr, s.lit)
				}
			}
			return token.create_token(.not, s.filename, s.line_nr, char_nr, s.lit)
		}
		`'`, `"` {
			ch := c
			for {
				c, _ = s.next(true)
				if c == ch {
					break
				}
			}
			return token.create_token(.string, s.filename, s.line_nr, char_nr, s.lit)
		}
		`=` {
			if c == s.th_next() {
				return token.create_token(.eq, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.assign, s.filename, s.line_nr, char_nr, s.lit)
		}
		`>` {
			if s.th_next() == c {
				s.next(true)
				if s.th_next() == `=` {
					s.next(true)
					return token.create_token(.right_shift_assign, s.filename, s.line_nr, char_nr, s.lit)
				}
				return token.create_token(.right_shift, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `=` {
				return token.create_token(.ge, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.gt, s.filename, s.line_nr, char_nr, s.lit)
		}
		`<` {
			if s.th_next() == c {
				s.next(true)
				if s.th_next() == `=` {
					s.next(true)
					return token.create_token(.left_shift_assign, s.filename, s.line_nr, char_nr, s.lit)
				}
				return token.create_token(.left_shift, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `=` {
				s.next(true)
				return token.create_token(.le, s.filename, s.line_nr, char_nr, s.lit)
			}
			if s.th_next() == `-` {
				s.next(true)
				return token.create_token(.arrow, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.lt, s.filename, s.line_nr, char_nr, s.lit)
		}
		`~` {
			return token.create_token(.bit_not, s.filename, s.line_nr, char_nr, s.lit)
		}
		`?` {
			return token.create_token(.question, s.filename, s.line_nr, char_nr, s.lit)
		}
		`,` {
			return token.create_token(.comma, s.filename, s.line_nr, char_nr, s.lit)
		}
		`;` {
			return token.create_token(.semicolon, s.filename, s.line_nr, char_nr, s.lit)
		}
		`#` {
			return token.create_token(.hash, s.filename, s.line_nr, char_nr, s.lit)
		}
		`$` {
			return token.create_token(.dollar, s.filename, s.line_nr, char_nr, s.lit)
		}
		`@` {
			return token.create_token(.at, s.filename, s.line_nr, char_nr, s.lit)
		}
		`{` {
			return token.create_token(.lcbr, s.filename, s.line_nr, char_nr, s.lit)
		}
		`(` {
			return token.create_token(.lpar, s.filename, s.line_nr, char_nr, s.lit)
		}
		`[` {
			return token.create_token(.lsbr, s.filename, s.line_nr, char_nr, s.lit)
		}
		`}` {
			return token.create_token(.rcbr, s.filename, s.line_nr, char_nr, s.lit)
		}
		`)` {
			return token.create_token(.rpar, s.filename, s.line_nr, char_nr, s.lit)
		}
		`]` {
			return token.create_token(.rsbr, s.filename, s.line_nr, char_nr, s.lit)
		}
		`.` {
			if s.th_next() == c {
				s.next(true)
				if s.th_next() == c {
					s.next(true)
					return token.create_token(.ellipsis, s.filename, s.line_nr, char_nr, s.lit)
				}
				return token.create_token(.dotdot, s.filename, s.line_nr, char_nr, s.lit)
			}
			return token.create_token(.dot, s.filename, s.line_nr, char_nr, s.lit)
		}
		else {
			if s.is_number(c) {
				for s.is_number(s.th_next()) {
					s.next(true)
				}
				return token.create_token(.number, s.filename, s.line_nr, char_nr, s.lit)
			} else if s.is_name(c) {
				for s.is_name(s.th_next()) {
					_, e := s.next(true)
					if e {
						break
					}
				}
				if string(s.lit) in token.keywords {
					return token.create_token(token.keywords[string(s.lit)], s.filename, s.line_nr, char_nr, s.lit)
				}
				return token.create_token(.name, s.filename, s.line_nr, char_nr, s.lit)
			}
		}
	}
	return token.create_token(.unknown, s.filename, s.line_nr, char_nr, s.lit)
}

// gets the next byte in string and increases values
fn (mut s Scanner) next(app bool) (byte, bool) {
	mut b := byte(0)
	mut ba := false
	if s.pos < s.data.len {
		b = s.data[s.pos]
		if s.pos + 1 < s.data.len {
			ba = s.validate(s.data[s.pos+1])
		} else {
			ba = true
		}
		if app {
			s.lit << b
		} else {	
			s.lit[0] = b
		}
		s.pos += s.next_i()
		s.char_nr++
	}
	return b, ba
}

// returns the theoretical next byte
fn (mut s Scanner) th_next() byte {
	mut b := byte(0)
	if s.pos < s.data.len {
		b = s.data[s.pos]
	}
	return b
}

fn (mut s Scanner) validate(c byte) bool {
	return c == ` ` || c == `\t` || c == `\n` || c == `\r`
}

// calculates the addition to index
fn (mut s Scanner) next_i() int {
	mut i := 1
	if s.pos + i >= s.data.len {
		return 1
	}
	mut c := s.data[s.pos + i]
	for s.validate(c) && (s.pos + i < s.data.len) {
		i++
		c = s.data[s.pos + i]
	}
	return i
}

fn (mut s Scanner) is_number(b byte) bool {
	return (b >= `0` && b <= `9`)
}

fn (mut s Scanner) is_name(b byte) bool {
	return s.is_number(b) || b == `_` || (b >= `a` && b <= `z`) || (b >= `A` && b <= `Z`)
} 