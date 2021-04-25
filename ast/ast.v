module ast

import token
import types

type Expr = StringExpr | NumberExpr | IdentExpr | Unknown | CastExpr

type Stmt = FunctionStmt | ModuleStmt | FunctionCallStmt | IfStmt | CommentStmt | ImportStmt | Unknown | ReturnStmt

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

pub struct IdentExpr {
pub:
	pos token.Position
	name string
}

pub struct FunctionStmt {
pub:
	pos token.Position
	is_pub bool
	name string
	ret types.Type
	parameter []Parameter
	attrs_pos token.Position
	attrs []Attribute
	mod string
	stmts []Stmt
}

pub struct FunctionCallStmt {
pub:
	pos token.Position
	mod string
	name string
	params []Expr
}

pub struct ModuleStmt {
pub:
	pos token.Position
	name string
}

pub struct ImportStmt {
pub:
	pos token.Position
	mod string
	has_as bool
	alias string
}

pub struct Parameter {
pub:
	pos token.Position
	typ types.Type
	name string
}

pub struct IfStmt {
pub:
	pos token.Position
	cond Expr
	stmts []Stmt
	elses []ElseStmt
}

pub struct ElseStmt {
pub:
	pos token.Position
	has_cond bool
	cond Expr
	stmts []Stmt
}

pub struct CommentStmt {
pub:
	pos token.Position
	multiline bool
	msg string
}

pub struct ReturnStmt {
pub:
	pos token.Position
	expr Expr
}

pub struct CastExpr {
pub:
	pos token.Position
	typ types.Type
	expr Expr
}

pub struct Unknown{}