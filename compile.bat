if not exist build mkdir build
nasm bootloader/stage0.asm -f bin -o build/stage0.bin
nasm bootloader/stage1.asm -f bin -o build/stage1.bin
copy /b build\stage0.bin + build\stage1.bin build\bootloader.bin

qemu-system-x86_64 -m 1G -hda build/bootloader.bin