source_filename = "stage0.ll"
target triple = "x86_64-apple-macosx11.0.0"

declare void @llvm.debugtrap() nounwind

declare i64 @syscall0(i64 %sysnum)
declare i64 @syscall1(i64 %sysnum, i64 %arg1)
declare i64 @syscall2(i64 %sysnum, i64 %arg1, i64 %arg2)
declare i64 @syscall3(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3)
declare i64 @syscall4(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4)
declare i64 @syscall5(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5)
declare i64 @syscall6(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5, i64 %arg6)

define void @exit(i32 %rval) noreturn {
  %rval_64 = zext i32 %rval to i64
  call i64 @syscall1(i64 1, i64 %rval_64)
  ret void
}

define i32 @fork() {
  %res = call i64 @syscall0(i64 2)
  %res_32 = trunc i64 %res to i32
  ret i32 %res_32
}

define i64 @read(i32 %fd, ptr %cbuf, i64 %nbyte) {
  %fd_64 = zext i32 %fd to i64
  %cbuf_64 = ptrtoint ptr %cbuf to i64

  %res = call i64 @syscall3(i64 3, i64 %fd_64, i64 %cbuf_64, i64 %nbyte)
  ret i64 %res
}

define i64 @write(i32 %fd, ptr %cbuf, i64 %nbyte) {
  %fd_64 = zext i32 %fd to i64
  %cbuf_64 = ptrtoint ptr %cbuf to i64

  %res = call i64 @syscall3(i64 4, i64 %fd_64, i64 %cbuf_64, i64 %nbyte)
  ret i64 %res
}

; #define O_RDONLY        0x0000          /* open for reading only */
; #define O_WRONLY        0x0001          /* open for writing only */
; #define O_RDWR          0x0002          /* open for reading and writing */
; #define O_ACCMODE       0x0003          /* mask for above modes */
define i32 @open(ptr %path, i32 %flags, i32 %mode) {
  %path_64 = ptrtoint ptr %path to i64
  %flags_64 = zext i32 %flags to i64
  %mode_64 = zext i32 %mode to i64

  %res = call i64 @syscall3(i64 5, i64 %path_64, i64 %flags_64, i64 %mode_64)
  %res_32 = trunc i64 %res to i32
  ret i32 %res_32
}

; ...

; #define PROT_NONE       0x00    /* [MC2] no permissions */
; #define PROT_READ       0x01    /* [MC2] pages can be read */
; #define PROT_WRITE      0x02    /* [MC2] pages can be written */
; #define PROT_EXEC       0x04    /* [MC2] pages can be executed */

; #define MAP_SHARED      0x0001          /* [MF|SHM] share changes */
; #define MAP_PRIVATE     0x0002          /* [MF|SHM] changes are private */

; #define MAP_FILE        0x0000  /* map from file (default) */
; #define MAP_ANON        0x1000  /* allocated from memory, swap space */
; 4096
; #define MAP_ANONYMOUS   MAP_ANON
define ptr @mmap(ptr %addr, i64 %len, i32 %prot, i32 %flags, i32 %fd, i32 %pos) {
  %addr_64 = ptrtoint ptr %addr to i64
  %prot_64 = zext i32 %prot to i64
  %flags_64 = zext i32 %flags to i64
  %fd_64 = zext i32 %fd to i64
  %pos_64 = zext i32 %pos to i64

  %res = call i64 @syscall6(i64 197, i64 %addr_64, i64 %len, i64 %prot_64, i64 %flags_64, i64 %fd_64, i64 %pos_64)
  %res_ptr = inttoptr i64 %res to ptr
  ret ptr %res_ptr
}

define ptr @alloc(ptr %arena_ptr, i64 %size) {
  %arena_end = load ptr, ptr %arena_ptr

  %arena_end_64 = ptrtoint ptr %arena_end to i64
  %new_arena_end_64 = add i64 %arena_end_64, %size
  %new_arena_end = inttoptr i64 %new_arena_end_64 to ptr

  store ptr %new_arena_end, ptr %arena_ptr

  ret ptr %arena_end
}

@self_path.str = constant [17 x i8] c"./stage0/main.ll\00"
@hello_world.str = constant [14 x i8] c"Hello World!\0A\00"

define void @start() noreturn {
  entry:
  %path = getelementptr [17 x i8], ptr @self_path.str, i64 0, i64 0
  %fd = call i32 @open(ptr %path, i32 0, i32 0)

  %arena = call ptr @mmap(ptr null, i64 16000, i32 3, i32 4096, i32 -1, i32 0)
  %arena_ptr = alloca ptr, i64 1
  store ptr %arena, ptr %arena_ptr

  %buf = call ptr @alloc(ptr %arena_ptr, i64 256)

  br label %loop

  loop:
  %bytes = call i64 @read(i32 %fd, ptr %buf, i64 256)
  %eof = icmp eq i64 %bytes, 0

  call i64 @write(i32 1, ptr %buf, i64 %bytes)

  br i1 %eof, label %done, label %loop

  done:
  call void @exit(i32 0)
  ret void
}
