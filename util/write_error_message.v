module util

import error

pub fn write_error_message(error error.Error, file string) {
	mut lines := file.split_into_lines()
	mut first_line := ''
	mut main_line := lines[error.pos.line_nr]
	mut last_line := ''
	if error.pos.line_nr > 0 {
		first_line = lines[error.pos.line_nr - 1]
	}
	if error.pos.line_nr + 1 < lines.len {
		last_line = lines[error.pos.line_nr + 1]
	}
	mut before := '     '
	eprintln('$error.pos.file:$error.pos.line_nr:$error.pos.char_nr: $error.level: $error.msg')
	if first_line != '' {
		before = calc_before(error.pos.line_nr - 1)
		eprintln('$before | $first_line')
	}
	before = calc_before(error.pos.line_nr)
	eprintln('$before | $main_line')
	eprint('      | ')
	for i in 0..error.pos.char_nr {
		if main_line[i] == `\t` {
			eprint('\t')
		} else {
			eprint(' ')
		}
	}
	for _ in 0..error.len {
		eprint('~')
	}
	eprintln('')
	if last_line != '' {
			before = calc_before(error.pos.line_nr + 1)
		eprintln('$before | $last_line')
	}
}

fn calc_before(i int) string {
	mut str := ''
	l := 5 - i.str().len
	for _ in 0..l {
		str += ' '
	}
	str += i.str()
	return str
}