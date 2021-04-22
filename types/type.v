module types

enum Kind {
	struct_
	sumtype
}

pub struct Type {
pub:
	mod string
	name string
	tname string
	bname string // backend name
	kind Kind
}