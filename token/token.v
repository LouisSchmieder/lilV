module token

pub struct Token {
pub:
	kind Kind
	pos Position
	lit string
}

pub enum Kind {
	unknown
	eof
	name // user
	number // 123
	string // 'foo'
	str_inter // 'name=$user.name'
	chartoken // `A` - rune
	plus // +
	minus // -
	mul // *
	div // /
	mod // %
	xor // ^
	pipe // |
	inc // ++
	dec // --
	and // &&
	logical_or // ||
	not // !
	bit_not // ~
	question // ?
	comma // ,
	semicolon // ;
	colon // :
	arrow // <-
	amp // &
	hash // #
	dollar // $
	at // @
	str_dollar
	left_shift // <<
	right_shift // >>
	not_in // !in
	not_is // !is
	assign // =
	decl_assign // :=
	plus_assign // +=
	minus_assign // -=
	div_assign // /=
	mult_assign // *=
	xor_assign // ^=
	mod_assign // %=
	or_assign // |=
	and_assign // &=
	right_shift_assign // <<=
	left_shift_assign // >>=
	lcbr // {
	rcbr // }
	lpar // (
	rpar // )
	lsbr // [
	rsbr // ]
	eq // ==
	ne // !=
	gt // >
	lt // <
	ge // >=
	le // <=
	comment
	nl
	dot // .
	dotdot // ..
	ellipsis // ...
	keyword_beg
	key_as
	key_asm
	key_assert
	key_atomic
	key_break
	key_const
	key_continue
	key_defer
	key_else
	key_enum
	key_false
	key_for
	key_fn
	key_global
	key_go
	key_goto
	key_if
	key_import
	key_in
	key_interface
	key_is
	key_match
	key_module
	key_mut
	key_shared
	key_lock
	key_rlock
	key_none
	key_return
	key_select
	key_sizeof
	key_likely
	key_unlikely
	key_offsetof
	key_struct
	key_true
	key_type
	key_typeof
	key_dump
	key_orelse
	key_union
	key_pub
	key_static
	key_unsafe
	keyword_end
	_end_
}

pub fn create_token(kind Kind, file string, line_nr int, char_nr int, lit []byte) Token {
	return Token{
		kind: kind
		pos: Position{
			file: file
			line_nr: line_nr
			char_nr: char_nr
		}
		lit: string(lit)
	}
}