[![CI](https://github.com/LouisSchmieder/lilV/actions/workflows/ci.yml/badge.svg)](https://github.com/LouisSchmieder/lilV/actions/workflows/ci.yml)

# lilV
A small V compiler in V

## Process
Windows isn't supported yet

### Parser
The parser parses the following statements for now:
- FunctionStmt
- ModuleStmt
- FunctionCallStmt
- IfStmt
- CommentStmt
- ImportStmt
- ReturnStmt
- ConstStmt
- DeclareStmt

And the following expressions:
- StringExpr
- NumberExpr
- IdentExpr
- CastExpr

### Gen
The gen generates like in normal V C code, for now the code isn't completely valid, but this step is reached soon.
Examples of C code you can see in `/tests` folder

### Fmt
The fmt tool creates a V file from the ast which got parsed from the original file. It's an other concept of formatation atm.
Examples of fmt'd files you can see in `/tests` folder (with this fileending `.v.fmted`)

### Ast
For now the ast is printed too in the `/tests`. It's done that anyone can see the structure, so it's not important, just nice :)


## Why?!
Because I'm bored and want to learn a bit more about compilers

## Goals
There are no goals, maybe to build a little program idk
