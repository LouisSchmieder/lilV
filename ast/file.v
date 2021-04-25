module ast

import types

pub struct File {
pub:
	mod string
	stmts []Stmt
pub mut:
	table &types.Table
}