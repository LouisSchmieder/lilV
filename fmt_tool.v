module main

import os
import scanner
import parser
import fmt
import util

fn main() {
	args := os.args[1..]

	verify := args[0] == '-verify'
	write := args[0] == '-w'
	
	file := args.last()

	data := os.read_file(file) or { '' }
	mut scan := scanner.create_scanner(data, file)
	mut pars := parser.create_parser(scan)
	out, err := pars.parse_file()
	if err.len > 0 {
		warns := err.filter(it.level == .warn)
		for warn in warns {
			util.write_error_message(warn, data)
		}
		errors := err.filter(it.level == .error)
		for error in errors {
			util.write_error_message(error, data)
		}
		if errors.len > 0 {
			exit(1)
		}
	}


	mut f := fmt.create_fmt(out)
	res := f.format()

	if verify {
		is_formatted := res == data
		eprintln('`$file` formatted: $is_formatted')
	} else if write {
		os.write_file(file, res) or {
			panic(err)
		}
		eprintln('Formatted $file')
	} else {
		eprintln(res)
	}
}