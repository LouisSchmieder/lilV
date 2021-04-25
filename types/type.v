module types

enum Kind {
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
}

pub struct Struct {}

pub struct SumType {}

pub struct Builtin {
pub:
	cbase string
}