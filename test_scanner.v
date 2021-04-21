import scanner

const (
	hello_world = "module main
	
	fn main() {
		a := 123456
		eprintln('test')
	}"
)

fn main() {
	mut scan := scanner.create_scanner(hello_world, 'testing')
	mut tok := scan.scan()
	for tok.kind != .eof {
		eprintln(tok)
		tok = scan.scan()
	}
}