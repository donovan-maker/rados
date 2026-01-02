[org 0x7e00]
; Read the amount of free memory (uses 32-bit registers)
xor ax, ax
mov es, ax
mov ds, ax
mov ebx, 0
readmemregion:
mov di, readmembuffer
mov edx, 0x534D4150
mov eax, 0xE820
mov ecx, 24
int 15h
jc readmemerror
cmp eax, 0x534D4150
jne readmemerror
cmp cl, 20
jc readmemerror
cmp bx, 0
je endmemregionread
push bx
; If it is a type 1 region add the size to the total memory
mov eax, [readmembuffer+16]
cmp eax, 1
jne readmemregion
mov eax, [readmembuffer+8]
mov ecx, [totalmemory]
add ecx, eax
mov [totalmemory], ecx
; And then move it to a buffer
mov ecx, [readmembuffercount]
cmp ecx, 16
je skipbufferadd
mov eax, 24
xor edx, edx
mul ecx
add eax, readmembuffer1
mov esi, readmembuffer
mov edi, eax
mov ecx, 24
cld
rep movsb
mov al, byte [readmembuffercount]
add al, 1
mov [readmembuffercount], al
skipbufferadd:
pop bx
jmp readmemregion
endmemregionread:
; Print out the total free memory
xor edx, edx
mov eax, [totalmemory]
mov ebx, 1024
div ebx
xor edx, edx
div ebx
mov ebx, 1
add eax, ebx
call printdec32
mov si, MBstr
call print
jmp infloop

; Print out an error for it not being able to read the memory regions
readmemerror:
mov si, readmemerrorstr
call booterrorprint
jmp infloop

; Infinite loop
infloop:
cli
hlt
jmp infloop

; Free memory reading buffers
readmembuffer:
dq 0    ; Base address
dq 0    ; Length of region
dd 0    ; Region type
dd 0    ; ACPI 3.0 extended field
readmembuffercount: db 0 ; How many of these buffers are used
readmembuffer1:
dq 0
dq 0
dd 0
dd 0
readmembuffer2:
dq 0
dq 0
dd 0
dd 0
readmembuffer3:
dq 0
dq 0
dd 0
dd 0
readmembuffer4:
dq 0
dq 0
dd 0
dd 0
readmembuffer5:
dq 0
dq 0
dd 0
dd 0
readmembuffer6:
dq 0
dq 0
dd 0
dd 0
readmembuffer7:
dq 0
dq 0
dd 0
dd 0
readmembuffer8:
dq 0
dq 0
dd 0
dd 0
readmembuffer9:
dq 0
dq 0
dd 0
dd 0
readmembuffer10:
dq 0
dq 0
dd 0
dd 0
readmembuffer11:
dq 0
dq 0
dd 0
dd 0
readmembuffer12:
dq 0
dq 0
dd 0
dd 0
readmembuffer13:
dq 0
dq 0
dd 0
dd 0
readmembuffer14:
dq 0
dq 0
dd 0
dd 0
readmembuffer15:
dq 0
dq 0
dd 0
dd 0
readmembuffer16:
dq 0
dq 0
dd 0
dd 0

; Total memory
totalmemory: dd 0

; Imports
%include "bootloader/print.asm"

; Strings
readmemerrorstr: db "Couldn't get the free memory regions properly", 0
MBstr: db "MB free", 0

times (512*2)-($-$$) db 0