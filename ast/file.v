module ast

import types

pub struct File {
pub:
	stmts []Stmt
pub mut:
	table &types.Table
}