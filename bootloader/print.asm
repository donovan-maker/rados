[bits 16]

printchar:
mov ah, 0x0E
int 0x10
ret

print:
.loop:
lodsb ; Load a single byte from SI into AL
cmp al, 0 ; Check if end of string
je .done
call printchar ; Print the character
jmp .loop
.done:
ret

printhex:
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
ret

booterrorprint:
push si
mov si, booterrorcode
call print
pop si
call print
ret