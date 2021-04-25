module test

fn test (test i8) int {
	return int(test)
}

['test': 123; abc]
fn main () {
	abc := 123
	test (abc)
}
