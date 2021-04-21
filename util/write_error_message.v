module util

import error

pub fn write_error_message(error error.Error, file string) {
	mut lines := file.split_into_lines()
	mut low := error.pos.line_nr - 1
	if low < 0 {
		low = 0
	}
	mut high := error.pos.line_nr + 2
	if high >= lines.len {
		high = lines.len - 1
	}
	lines = lines[low..high]
	eprintln('-------------------------------------------------------')
	eprintln(error.pos)
	eprintln(error.msg)
	eprintln(lines[0])
	eprintln(lines[1])
	for i in 0..error.pos.char_nr {
		if lines[1][i] == `\t` {
			eprint('\t')
		} else {
			eprint(' ')
		}
	}
	for _ in 0..error.len {
		eprint('~')
	}
	eprintln('')
	if lines.len > 2 {
		eprintln(lines[2])
	}
}