module error

import token

pub enum Level {
	warn
	error
}

pub struct Error {
pub:
	pos token.Position
	len int
	level Level
	msg string
}