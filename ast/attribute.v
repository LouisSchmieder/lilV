module ast

pub struct Attribute {
pub:
	name string
	name_kind AttributeKind
	has_arg bool
	arg string
	arg_kind AttributeKind
}

pub enum AttributeKind {
	string
	name
	number
}