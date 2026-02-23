if exist build rm -rf build
mkdir build

nasm bootloader\stage0.asm -f bin -o build\stage0.bin
nasm bootloader\stage1.asm -f bin -o build\stage1.bin

nasm kernel\kernelentry.asm -f elf64 -o build\kernelentry.o
x86_64-elf-gcc -ffreestanding -nolibc -nostdlib -isystem kernel/include/ -mno-sse -mno-sse2 -mno-mmx -mno-3dnow -m64 -mno-red-zone -c kernel\kernel.cpp -o build\kernel.o
x86_64-elf-ld -T link.ld -o build\kernel.bin build\kernelentry.o build\kernel.o

copy /b build\stage0.bin + build\stage1.bin + build\kernel.bin build\rados.img

qemu-system-x86_64 -m 1G -hda build\rados.img