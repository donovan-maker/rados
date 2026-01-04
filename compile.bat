if not exist build mkdir build

nasm bootloader/stage0.asm -f bin -o build/stage0.bin
nasm bootloader/stage1.asm -f elf64 -o build/stage1.o
x86_64-elf-gcc -ffreestanding -mno-red-zone -m64 -c "kernel/kernel.cpp" -o "build/kernel.o"
ld -o build/kernel.tmp -Ttext 0x7e00 build/stage1.o build/kernel.o
objcopy -O binary build/kernel.tmp build/kernel.bin
copy /b build\stage0.bin + build\kernel.bin build\rados.img

qemu-system-x86_64 -m 1G -hda build/rados.img