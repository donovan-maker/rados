# Tools
NASM := nasm
GCC := x86_64-elf-gcc
LD := x86_64-elf-ld
QEMU := qemu-system-x86_64

# Directories
BUILD := build
KERNEL := kernel
BOOTLOADER := bootloader

# Bootloader files
BOOT0 := $(BOOTLOADER)/stage0.asm
BOOT1 := $(BOOTLOADER)/stage1.asm

# Kernel files (recursive up to 5 levels)
KERNEL_CPP_SRCS := $(wildcard $(KERNEL)/*.cpp) \
                   $(wildcard $(KERNEL)/*/*.cpp) \
                   $(wildcard $(KERNEL)/*/*/*.cpp) \
                   $(wildcard $(KERNEL)/*/*/*/*.cpp) \
                   $(wildcard $(KERNEL)/*/*/*/*/*.cpp)

KERNEL_ASM_SRCS := $(wildcard $(KERNEL)/*.asm) \
                   $(wildcard $(KERNEL)/*/*.asm) \
                   $(wildcard $(KERNEL)/*/*/*.asm) \
                   $(wildcard $(KERNEL)/*/*/*/*.asm) \
                   $(wildcard $(KERNEL)/*/*/*/*/*.asm)

# Kernel object files
KERNEL_CPP_OBJS := $(patsubst $(KERNEL)/%.cpp,$(BUILD)/%.o,$(KERNEL_CPP_SRCS))
KERNEL_ASM_OBJS := $(patsubst $(KERNEL)/%.asm,$(BUILD)/%.o,$(KERNEL_ASM_SRCS))
KERNEL_OBJS := $(KERNEL_ASM_OBJS) $(KERNEL_CPP_OBJS)

# Output
IMG := $(BUILD)/rados.img
KERNEL_BIN := $(BUILD)/kernel.bin
STAGE0_BIN := $(BUILD)/stage0.bin
STAGE1_BIN := $(BUILD)/stage1.bin

# Flags
NASM_FLAGS_BIN := -f bin
NASM_FLAGS_ELF := -f elf64
GCC_FLAGS := -ffreestanding -nostdlib -nostdinc -I$(KERNEL)/include -m64 -mno-red-zone -mno-sse -mno-sse2 -mno-mmx -mno-3dnow -c

# Default target
all: $(IMG)
	$(QEMU) -m 1G -hda $(IMG)

# Bootloader
$(STAGE0_BIN): $(BOOT0)
	@mkdir -p $(BUILD)
	$(NASM) $(NASM_FLAGS_BIN) $< -o $@

$(STAGE1_BIN): $(BOOT1)
	@mkdir -p $(BUILD)
	$(NASM) $(NASM_FLAGS_BIN) $< -o $@

# Kernel ASM objects
$(BUILD)/%.o: $(KERNEL)/%.asm
	@mkdir -p $(dir $@)
	$(NASM) $(NASM_FLAGS_ELF) $< -o $@

# Kernel CPP objects
$(BUILD)/%.o: $(KERNEL)/%.cpp
	@mkdir -p $(dir $@)
	$(GCC) $(GCC_FLAGS) $< -o $@

# Link kernel
$(KERNEL_BIN): $(KERNEL_OBJS)
	$(LD) -T link.ld -o $@ $(KERNEL_OBJS)

# Combine everything into image
$(IMG): $(STAGE0_BIN) $(STAGE1_BIN) $(KERNEL_BIN)
	@echo "Creating final image..."
	cat $(STAGE0_BIN) $(STAGE1_BIN) $(KERNEL_BIN) > $(IMG)

# Clean
clean:
	rm -rf $(BUILD)

.PHONY: all clean