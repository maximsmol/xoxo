; https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf
; The kernel interface uses %rdi, %rsi, %rdx, %r10, %r8 and %r9.
; the kernel destroys %rcx and %r11
; Only values of class INTEGER or class MEMORY are passed to the kernel.

attributes #0 = { alwaysinline }

define available_externally i64 @syscall0(i64 %sysnum) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},~{rcx},~{r11}" (
    i64 %sysnum
  )
  ret i64 %res
}

define available_externally i64 @syscall1(i64 %sysnum, i64 %arg1) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},{rdi},~{rcx},~{r11}" (
    i64 %sysnum,
    i64 %arg1
  )
  ret i64 %res
}

define available_externally i64 @syscall2(i64 %sysnum, i64 %arg1, i64 %arg2) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},{rdi},{rsi},~{rcx},~{r11}" (
    i64 %sysnum,
    i64 %arg1,
    i64 %arg2
  )
  ret i64 %res
}

define available_externally i64 @syscall3(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},{rdi},{rsi},{rdx},~{rcx},~{r11}" (
    i64 %sysnum,
    i64 %arg1,
    i64 %arg2,
    i64 %arg3
  )
  ret i64 %res
}

define available_externally i64 @syscall4(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},{rdi},{rsi},{rdx},{r10},~{rcx},~{r11}" (
    i64 %sysnum,
    i64 %arg1,
    i64 %arg2,
    i64 %arg3,
    i64 %arg4
  )
  ret i64 %res
}

define available_externally i64 @syscall5(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},~{rcx},~{r11}" (
    i64 %sysnum,
    i64 %arg1,
    i64 %arg2,
    i64 %arg3,
    i64 %arg4,
    i64 %arg5
  )
  ret i64 %res
}

define available_externally i64 @syscall6(i64 %sysnum, i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4, i64 %arg5, i64 %arg6) #0 {
  %res = call i64 asm sideeffect inteldialect "
    add rax, 0x2000000
    syscall
  ", "={rax},{rax},{rdi},{rsi},{rdx},{r10},{r8},{r9},~{rcx},~{r11}" (
    i64 %sysnum,
    i64 %arg1,
    i64 %arg2,
    i64 %arg3,
    i64 %arg4,
    i64 %arg5,
    i64 %arg6
  )
  ret i64 %res
}
