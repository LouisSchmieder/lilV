module ast

import token
import types

type Expr = StringExpr | NumberExpr | IdentExpr | Unknown

type Stmt = FunctionStmt | ModuleStmt | FunctionCallStmt | IfStmt | Unknown

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

pub struct Unknown{}