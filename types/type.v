module types

pub enum Kind {
	struct_
	sumtype
	builtin
}

pub type Info = Struct | SumType | Builtin

pub struct Type {
pub:
	mod string
	name string
	tname string
	bname string // backend name
	kind Kind
	info Info
mut:
	is_array bool
}

pub fn (mut t Type) set_array() {
	t.is_array = true
}

pub fn (t Type) bname() string {
	arr := if t.is_array { 'Array_' } else { '' }
	return '$arr$t.bname'
}

pub fn (t Type) name() string {
	arr := if t.is_array { '[]' } else { '' }
	return '$arr$t.tname'
}

pub fn (t Type) tname() string {
	arr := if t.is_array { 'Array_' } else { '' }
	return '$arr$t.tname'
}

pub struct Struct {
pub:
	name string
	fields []StructField
}

pub struct StructField {
pub:
	name string
	typ Type
	is_pub bool
	is_mut bool
}

pub struct SumType {
pub:
	name string
	types []Type
}

pub struct Builtin {
pub:
	cbase string
}