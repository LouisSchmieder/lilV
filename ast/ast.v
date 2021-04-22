module ast

import token
import types

type Expr = StringExpr | NumberExpr

type Stmt = FunctionStmt | ModuleStmt

pub struct StringExpr {
pub:
	pos token.Position
	str string
}

pub struct NumberExpr {
pub:
	pos token.Position
	num string
}

pub struct FunctionStmt {
pub:
	pos token.Position
	is_pub bool
	name string
	ret types.Type
	parameter []Parameter
	attrs []Attribute
	mod string
	stmts []Stmt
}

pub struct ModuleStmt {
pub:
	pos token.Position
	name string
}

pub struct Parameter {
pub:
	pos token.Position
	typ types.Type
	name string
}