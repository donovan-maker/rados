#include "vga.hpp"

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

template<typename T>
T min(const T& a, const T& b) {
    return (a < b) ? a : b;
}

template<typename T>
T max(const T& a, const T& b) {
    return (a > b) ? a : b;
}

void DrawSquareFast(int x1, int y1, int x2, int y2, uint8_t color) {
    int left = min(x1, x2);
    int right = max(x1, x2);
    int top = min(y1, y2);
    int bottom = max(y1, y2);
    int leftByte = left >> 3;
    int rightByte = right >> 3;
    uint8_t leftMask  = 0xFF >> (left & 7);
    uint8_t rightMask = 0xFF << (7 - (right & 7));
    for (int plane = 0; plane < 4; plane++) {
        setplane(plane);
        uint8_t planeColor = (color & (1 << plane)) ? 0xFF : 0x00;
        for (int y = top; y <= bottom; y++) {
            uint16_t row = y * 80;
            if (leftByte == rightByte) {
                setbitmask(leftMask & rightMask);
                VGA_MEMORY[row + leftByte] = planeColor;
            } else {
                setbitmask(leftMask);
                VGA_MEMORY[row + leftByte] = planeColor;
                setbitmask(0xFF);
                for (int b = leftByte + 1; b < rightByte; b++)
                    VGA_MEMORY[row + b] = planeColor;
                setbitmask(rightMask);
                VGA_MEMORY[row + rightByte] = planeColor;
            }
        }
    }
    setbitmask(0xFF);
}