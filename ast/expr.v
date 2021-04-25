module ast

import types

pub fn (mut file File) get_type(expr Expr) types.Type {
	match expr {
		StringExpr {
			return file.table.find_type('string') or {types.Type{}}
		}
		NumberExpr {
			return file.table.find_type('int') or {types.Type{}}
		}
		CastExpr {
			return expr.typ
		}
		IdentExpr {
			return file.get_type(expr.expr)
		}
		else {
			return types.Type{}
		}
	}
}