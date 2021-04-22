module main

import os
import scanner
import parser
import util

fn main() {
	args := os.args[1..]
	compile_file(args[0])
}

fn compile_file(path string) {
	data := os.read_file(path) or { '' }
	mut scan := scanner.create_scanner(data, path)
	mut pars := parser.create_parser(scan)
	f, err := pars.parse_file()
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
}