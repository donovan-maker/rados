ENTRY(_start)
OUTPUT_FORMAT(binary)

SECTIONS {
    . = 0x8400;

    .text : { *(.text*) }
    .rodata : { *(.rodata*) }
    .data : { *(.data*) }
    .bss : {
        *(COMMON)
        *(.bss*)
    }
}