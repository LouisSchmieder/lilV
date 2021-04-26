module ast

import token
import types

type Expr = StringExpr | NumberExpr | IdentExpr | Unknown | CastExpr

type Stmt = FunctionStmt | ModuleStmt | FunctionCallStmt | IfStmt | CommentStmt | ImportStmt | Unknown | ReturnStmt | ConstStmt | DeclareStmt | StructStmt | IncludeStmt | FlagStmt | SumtypeStmt

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
	expr Expr
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

pub struct ConstStmt {
pub:
	pos token.Position
	is_pub bool
	consts []Const
}

pub struct Const {
pub:
	pos token.Position
	name string
	expr Expr
}

pub struct DeclareStmt {
pub:
	pos token.Position
	name string
	expr Expr
}

pub struct StructStmt {
pub:
	pos token.Position
	is_pub bool
	name string
	attrs []Attribute
	attrs_pos token.Position
	fields []StructField
}

pub struct StructField {
pub:
	pos token.Position
	name string
	typ types.Type
	is_pub bool
	is_mut bool
	attrs []Attribute
	attrs_pos token.Position
}

pub struct IncludeStmt {
pub:
	pos token.Position
	include string
}

pub struct SumtypeStmt {
pub:
	pos token.Position
	is_pub bool
	name string
	names []string
	types []types.Type
}

pub struct FlagStmt {
	pos token.Position
	str string
}

pub struct Unknown{}