@build:
  llvm-link \
    -o bin/linked.bc \
    stage0/*

  opt \
    -O0 \
    -o bin/optimized.bc \
    bin/linked.bc

  llc \
    -filetype obj \
    -o bin/stage0.o \
    bin/optimized.bc

  ld \
    -static \
    -e _start \
    -o bin/stage0 \
    bin/stage0.o

@disasm:
  llvm-objdump -d bin/stage0 --x86-asm-syntax=intel

@debug:
  lldb bin/stage0
