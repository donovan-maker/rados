;; REMEMBER, THE SOURCE OF ALL PROBLEMS IS PROBABLY LINE 192

[org 0x7e00]
[bits 16]
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
; If it is a type 1 region move it to a buffer
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
; Set the video mode to 12h
mov ax, 0x0012
int 10h
; Enter protected mode
; Disable interrupts
cli
; Enable the A20 line
in al, 0x92
or al, 2
out 0x92, al
; Load the gdt
lgdt [gdtdescriptor]
; Set the PE bit
mov eax, cr0
or eax, 1
mov cr0, eax
; Flush the pipeline to jump to protected mode
jmp codeseg:startprotectedmode

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

; Imports
%include "bootloader/print.asm"
%include "bootloader/gdt.asm"

; Strings
readmemerrorstr: db "Couldn't get the free memory regions properly", 0

[bits 32]

startprotectedmode:
; Set all of the data segments
mov ax, dataseg
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax
; Check if the A20 line was enabled
pushad
mov edi,0x107c00
mov esi,0x007c00
mov [esi],esi
mov [edi],edi
cmpsd
popad
je longbooterror
; Move the kernel to a better location
mov esi, 0x00008200
mov edi, 0x00100000
mov ecx, (6*512)/4 ; CHANGE WHEN NEEDED
rep movsd
; Detect CPUID
; Set the CPUID flag
pushfd
pop eax
mov ecx, eax
xor eax, 1<<21
push eax
popfd
; Detect if it is still set
pushfd
pop eax
push ecx
popfd
xor eax, ecx
; And if the flag did not change tell the user
je longbooterror
; Detect long mode
mov eax, 0x80000000
cpuid
cmp eax, 0x80000001
jb longbooterror
mov eax, 0x80000001
cpuid
test edx, 1<<29
je longbooterror
; Setup identity paging
mov edi, 0x1000
mov cr3, edi
mov dword [edi], 0x2003
add edi, 0x1000
mov dword [edi], 0x3003
add edi, 0x1000
mov dword [edi], 0x4003
add edi, 0x1000
mov ebx, 0x00000003
mov ecx, 512
.setentry:
mov dword [edi], ebx
add ebx, 0x1000
add edi, 8
loop .setentry
mov eax, cr4
or eax, 1<<5
mov cr4, eax
mov ecx, 0xC0000080
rdmsr
or eax, 1 << 8
wrmsr
mov eax, cr0
or eax, 1<<31
mov cr0, eax
; Edit the GDT to be 64 bits
mov [gdtcodedesc+6], byte 10101111b
mov [gdtdatadesc+6], byte 10101111b
; Jump to long mode
jmp codeseg:startlongmode

longbooterror:
jmp $

[bits 64]

startlongmode:
; Set up the stack
mov rsp, 0x90000
mov rbp, rsp
; Jump to the kernel
mov rax, 0x100000
jmp rax

times (512*2)-($-$$) db 0