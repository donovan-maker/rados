[bits 16]

booterrorcode: db "Bootloader Error: ", 0
hexascii: db '0123456789ABCDEF', 0
invalidbootdiskstr: db "Boot with a disk drive and not a floppy disk", 0
noextdrivefuncsstr: db "Extended drive functions are not supported", 0
couldntreaddrivestr: db "Couldn't read data from the drive", 0
BOOTDISK: db 0