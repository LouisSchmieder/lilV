module main

import os
import scanner
import parser
import fmt
import util
import gen
import time

const (
	tabs = '\t\t\t\t\t\t\t\t\t\t\t'
)

fn main() {
	debug('Testing files...', 0)
	files := os.ls('tests') or { panic(err) }
	for f in files {
		if f.ends_with('.v') {
			compile_file('./tests/$f')
		}
	}
}

fn compile_file(path string) {
	mut total := i64(0)
	debug('Testing `$path`', 1)
	data := os.read_file(path) or { '' }
	mut scan := scanner.create_scanner(data, path)
	mut pars := parser.create_parser(scan)
	debug('`$path` start parsing', 2)
	mut sw := time.new_stopwatch(auto_start: true)
	out, err := pars.parse_file()
	sw.stop()
	debug('`$path` finsh parsing (took ${sw.elapsed().microseconds()} ms)', 2)
	total += sw.elapsed().microseconds()
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


	// format

	debug('`$path` format ast', 2)
	mut f := fmt.create_fmt(out)
	debug('`$path` formatted ast', 2)
	sw.restart()
	res := f.format()
	sw.stop()
	is_formatted := if res != data { 'not ' } else {''}
	debug('`$path` is ${is_formatted}formatted (took ${sw.elapsed().microseconds()} ms)', 3)
	total += sw.elapsed().microseconds()
	os.write_file('${path}.fmted', '$res') or { panic(err) }

	debug('`$path` cgen starting', 2)
	mut g := gen.create_gen([&out])
	sw.restart()
	cr := g.gen()
	sw.stop()
	debug('`$path` cgen finished (took ${sw.elapsed().microseconds()} ms)', 2)
	total += sw.elapsed().microseconds()
	os.write_file('${path}.c', '$cr') or { panic(err) }
	debug('`$path` took to finish the job $total ms', 1)
}

fn debug(msg string, level int) {
	if level <= 0 {
		eprintln(msg)
	} else {
		t := tabs[..level]
		eprintln('$t$msg')
	}
}