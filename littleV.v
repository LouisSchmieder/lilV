module main

import os
import scanner
import parser
import util

const (
	tabs = '\t\t\t\t\t\t\t\t\t\t\t'
)

fn main() {
	debug('Testing files...', 0)
	compile_file('./tests/functions.v')
	compile_file('./tests/comments.v')
	compile_file('./tests/if.v')
}

fn compile_file(path string) {
	debug('Testing `$path`', 1)
	data := os.read_file(path) or { '' }
	mut scan := scanner.create_scanner(data, path)
	mut pars := parser.create_parser(scan)
	debug('`$path` start parsing', 2)
	out, err := pars.parse_file()
	debug('`$path` finsh parsing', 2)
	debug('`$path` has $err.len problems', 2)
	if err.len > 0 {
		warns := err.filter(it.level == .warn)
		debug('`$path` has $warns.len warnings', 3)
		for warn in warns {
			util.write_error_message(warn, data)
		}
		errors := err.filter(it.level == .error)
		debug('`$path` has $errors.len errors', 3)
		for error in errors {
			util.write_error_message(error, data)
		}
		if errors.len > 0 {
			exit(1)
		}
	}
	os.write_file('${path}.pfile', '$out') or { panic(err) }
}

fn debug(msg string, level int) {
	if level <= 0 {
		eprintln(msg)
	} else {
		t := tabs[..level]
		eprintln('$t$msg')
	}
}