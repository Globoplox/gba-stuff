#!/bin/bash
set -ve

arm-none-eabi-gcc -c startup.S -mthumb -mthumb-interwork -DHEADER_TITLE=\""Test"\" -DHEADER_CODE=\""ATSE"\" -DHEADER_MAKER=\""GX"\" -o startup.o

crystal build --error-trace \
        --cross-compile --mcpu arm7tdmi --target arm-none-eabi \
        --prelude=empty --emit=llvm-ir main.cr -o main

cat main.ll | opt -o main.bc

llc --enable-no-trapping-fp-math main.bc -filetype=obj -o main.o

# Couldn't find another way to prevent insertion of exception handling stuff.
arm-none-eabi-objcopy --remove-section '.ARM.exidx' main.o    
arm-none-eabi-gcc main.o startup.o -mthumb -mthumb-interwork -T gba.ld -nostartfiles -ffreestanding -fno-exceptions -fno-unwind-tables -nostdlib -o test.elf
# Remove annoying noise to help debug
#arm-none-eabi-strip test.elf
arm-none-eabi-objcopy -v -O binary test.elf test.gba
mgba test.gba
