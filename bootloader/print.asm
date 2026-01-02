[bits 16]

printchar:
mov ah, 0x0E
int 0x10
ret

print:
.printloop:
lodsb ; Load a single byte from SI into AL
cmp al, 0 ; Check if end of string
je .done
call printchar ; Print the character
jmp .printloop
.done:
ret

printhex:
push ax
mov bx, 0
push ax
push bx
mov ah, al
shr ah, 4
mov bl, ah
mov al, [hexascii+bx]
call printchar
pop bx
pop ax
and al, 0xF
mov bl, al
mov al, [hexascii+bx]
call printchar
pop ax
ret

printhex32:
push eax
push cx
mov cx, 4
.printhex32loop:
rol eax, 8
call printhex
loop .printhex32loop
pop cx
pop eax
ret

printdec32:
push bx
push cx
push dx
mov ecx, 0
mov ebx, 10
cmp eax, 0
jne .convertprintdec32
mov al, '0'
call printchar
jmp .doneprintdec32
.convertprintdec32:
.loopprintdec32:
xor edx, edx
div ebx
push dx
inc ecx
test eax, eax
jne .loopprintdec32
.printprintdec32:
pop dx
add dl, '0'
mov al, dl
call printchar
loop .printprintdec32
.doneprintdec32:
pop dx
pop cx
pop bx
ret

booterrorprint:
push si
mov si, booterrorcode
call print
pop si
call print
ret

; Constants
booterrorcode: db "Bootloader Error: ", 0
hexascii: db '0123456789ABCDEF', 0