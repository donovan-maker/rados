[bits 32]

print32:
.print32loop:
lodsb ; Load a single byte from ESI into AL
cmp al, 0 ; Check if end of string
je .print32done
mov [ebx], byte al ; Print the character
add ebx, 2
jmp .print32loop
.print32done:
ret

[bits 64]

print64:
.print64loop:
lodsb ; Load a single byte from RSI into AL
cmp al, 0 ; Check if end of string
je .print64done
mov [rbx], byte al ; Print the character
add rbx, 2
jmp .print64loop
.print64done:
ret

[bits 32]