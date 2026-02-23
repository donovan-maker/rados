#include "cpu/ports.cpp"

#define VGA_GC_INDEX 0x3CE
#define VGA_GC_DATA 0x3CF
#define VGA_SC_INDEX 0x3C4
#define VGA_SC_DATA 0x3C5
#define VGA_MEMORY ((uint8_t*)0xA0000)

void setupvga(void) {
    // Set/Reset = 0
    outb(0x3CE, 0x00);
    outb(0x3CF, 0x00);

    // Enable Set/Reset = 0
    outb(0x3CE, 0x01);
    outb(0x3CF, 0x00);

    // Data Rotate = 0
    outb(0x3CE, 0x03);
    outb(0x3CF, 0x00);

    // WRITE MODE 0
    outb(0x3CE, 0x05);
    outb(0x3CF, 0x00);

    // Graphics mode, A0000
    outb(0x3CE, 0x06);
    outb(0x3CF, 0x05);

    // Bit Mask = all bits
    outb(0x3CE, 0x08);
    outb(0x3CF, 0xFF);
}


static inline void setbitmask(uint8_t mask) {
    outb(VGA_GC_INDEX, 0x08);
    outb(VGA_GC_DATA, mask);
}

static inline void setplane(uint8_t plane) {
    outb(VGA_SC_INDEX, 0x02);
    outb(VGA_SC_DATA, 1 << plane);
}

void putpixel(int x, int y, uint8_t color) {
    uint16_t offset = (y * 80) + (x >> 3);
    uint8_t bitmask = 0x80 >> (x & 7);
    setbitmask(bitmask);
    for (int plane = 0; plane < 4; plane++) {
        setplane(plane);
        volatile uint8_t tmp = VGA_MEMORY[offset];
        VGA_MEMORY[offset] = (color & (1 << plane)) ? 0xFF : 0x00;
    }
}

void fillscreen(uint8_t color) {
    setbitmask(0xFF);
    for (int plane = 0; plane < 4; plane++) {
        setplane(plane);
        uint8_t value = (color & (1 << plane)) ? 0xFF : 0x00;
        for (int i = 0; i < 80 * 480; i++) {
            VGA_MEMORY[i] = value;
        }
    }
}