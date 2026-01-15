[bits 64]
global _start
extern kmain

_start:
cli
mov rbp, 0
call kmain
jmp $