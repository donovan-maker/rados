if not exist build mkdir build
nasm bootloader/stage0.asm -f bin -o build/stage0.bin

qemu-system-x86_64 -hda build/stage0.bin