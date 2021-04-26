module ast

pub struct Attribute {
pub:
	name string
	name_kind AttribKind
	has_arg bool
	arg string
	arg_kind AttribKind
}

pub enum AttribKind {
	string
	name
	number
}