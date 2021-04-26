module main

pub type ABC = byte | int | Name | Test | abc | string | u64 | test2

[abc]
struct Name {
	test u32
mut:
	field byte [help]
	nums []int
pub:
	abc int
pub mut:
	cd u64
}