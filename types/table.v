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
	table.register_builtin('i8', 'signed char', .builtin)
	table.register_builtin('i16', 'signed short', .builtin)
	table.register_builtin('int', 'signed long', .builtin)
	table.register_builtin('i64', 'signed long long', .builtin)
	table.register_builtin('byte', 'unsigned char', .builtin)
	table.register_builtin('u16', 'unsigned short', .builtin)
	table.register_builtin('u32', 'unsigned long', .builtin)
	table.register_builtin('u64', 'unsigned long long', .builtin)
	table.register_builtin('charptr', 'char *', .builtin)
	table.register_builtin('voidptr', 'void *', .builtin)
	table.register_builtin('void_', 'void', .builtin)

	return table
}

pub fn (mut table Table) register_type(mod string, name string, kind Kind, info Info) {
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

fn (mut table Table) register_builtin(name string, cbase string, kind Kind) {
	typ := Type{
		mod: ''
		name: name
		tname: name
		bname: name
		kind: kind
		info: Builtin{
			cbase: cbase
		}
	}
	table.types << typ
	table.type_idx[name] = table.types.len - 1
}