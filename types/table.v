module types

pub struct Table {
pub mut:
	types []Type
	type_idx map[string]int
}

pub fn create_default_table() &Table {
	mut table := &Table{
	}
	// add builtins
	table.register_builtin('i8', .struct_)
	table.register_builtin('i16', .struct_)
	table.register_builtin('int', .struct_)
	table.register_builtin('i64', .struct_)
	table.register_builtin('u8', .struct_)
	table.register_builtin('u16', .struct_)
	table.register_builtin('u32', .struct_)
	table.register_builtin('u64', .struct_)
	table.register_builtin('string', .struct_)
	table.register_builtin('void', .struct_)

	return table
}

pub fn (mut table Table) register_type(mod string, name string, kind Kind) {
	typ := Type{
		mod: mod
		name: name
		tname: '${mod}.$name'
		bname: '${mod}__$name'
		kind: kind
	}
	table.types << typ
	table.type_idx['${mod}.$name'] = table.types.len - 1
}

pub fn (mut table Table) find_type(name string) ?Type {
	if name !in table.type_idx {
		return error('Unkown type `$name`')
	}
	return table.types[table.type_idx[name]]
}

pub fn (mut table Table) get_idx(name string) int {
	return table.type_idx[name]
}

fn (mut table Table) register_builtin(name string, kind Kind) {
	typ := Type{
		mod: ''
		name: name
		tname: name
		bname: name
		kind: kind
	}
	table.types << typ
	table.type_idx[name] = table.types.len - 1
}