typedef signed char i8;
typedef signed short i16;
typedef signed long int;
typedef signed long long i64;
typedef unsigned char byte;
typedef unsigned short u16;
typedef unsigned long u32;
typedef unsigned long long u64;
typedef char * charptr;
typedef void * voidptr;
typedef void void_;
int test__test(i8 test);
void_ test__main();
int test__test(i8 test) {
return ((int)test);
}
void_ test__main() {
test__test(123);
}
