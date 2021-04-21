import parser
import scanner
import util

const (
	hello_world = "module test

fn main() {
	a := 123456
	eprintln('test')
}"
)

fn main() {
	mut scan := scanner.create_scanner(hello_world, 'testing')
	mut parser := parser.create_parser(scan)
	_, err := parser.parse_file()
	if err.len > 0 {
		for error in err {
			util.write_error_message(error, hello_world)
		}
	}
}