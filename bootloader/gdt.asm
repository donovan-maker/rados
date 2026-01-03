[bits 16]

gdtnulldesc:
dd 0
dd 0
gdtcodedesc:
dw 0xFFFF       ; Limit
dw 0x0000       ; Base (low)
db 0x00         ; Base (med)
db 10011010b    ; Flags
db 11001111b    ; Flags + upper limit
db 0x00         ; Base (high)
gdtdatadesc:
dw 0xFFFF
dw 0x0000
db 0x00
db 10010010b
db 11001111b
db 0x00
gdtend:

gdtdescriptor:
gdtsize:
dw gdtend-gdtnulldesc-1
dd gdtnulldesc

codeseg equ gdtcodedesc - gdtnulldesc
dataseg equ gdtdatadesc - gdtnulldesc