[bits 16]
[org 0x7c00]

jmp 0:setcstozero
setcstozero:
; Move to booted disk to BOOTDISK
mov [BOOTDISK], dl
; Set all of the segments to 0
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
; Set the stack to just below the bootloader
mov ax, 0x7c00
mov sp, ax
; Check if the booted disk was a floppy disk
cmp dl, 0x80
jc invalidbootdisk
; Check if the BIOS can use extended INT 13h functions
mov ah, 0x41
mov bx, 0x55AA
int 13h
jc noextdrivefuncs
cmp bx, 0xAA55
jne noextdrivefuncs
and cx, 1
je noextdrivefuncs
; Read the next sector on the drive
mov ah, 0x42
mov si, kernelDAP
mov dl, byte [BOOTDISK]
int 13h
jc couldntreaddrive
; Jump to stage1
jmp 0:0x7e00

; Print out an error for an invalid boot disk
invalidbootdisk:
push ax
mov si, invalidbootdiskstr
call booterrorprint
mov al, ' '
call printchar
pop ax
xchg ah, al
call printhex
jmp infloop

; Print out an error for there not being extended drive functions
noextdrivefuncs:
push ax
mov si, noextdrivefuncsstr
call booterrorprint
mov al, ' '
call printchar
pop ax
xchg ah, al
call printhex
jmp infloop

; Print out an error for it not being able to read the drive
couldntreaddrive:
push ax
mov si, couldntreaddrivestr
call booterrorprint
mov al, ' '
call printchar
pop ax
xchg ah, al
call printhex
jmp infloop

; Infinite loop
infloop:
cli
hlt
jmp infloop

; DAP for the kernel
align 16
kernelDAP:
db 0x10     ; Size of DAP, always 16 bytes
db 0        ; Unused byte, should always be null
dw 9        ; Number of sectors to be read
dw 0x7e00   ; The offset where the data should be put
dw 0        ; The segment where the data should be put
dq 1        ; Which sector is our count starting from

; Imports
%include "bootloader/print.asm"

; Constants
invalidbootdiskstr: db "Boot with a disk drive and not a floppy disk", 0
noextdrivefuncsstr: db "Extended drive functions are not supported", 0
couldntreaddrivestr: db "Couldn't read data from the drive", 0
BOOTDISK: db 0

; Pad until the signature then add it
times 510-($-$$) db 0
dw 0xAA55