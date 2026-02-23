// Modified from BreezeOS (https://github.com/atlassoftware-cpu/BreezeOS)

#pragma once
#include "font.h"
#include "vga.cpp"

template<typename T>
T min(const T& a, const T& b) {
    return (a < b) ? a : b;
}

template<typename T>
T max(const T& a, const T& b) {
    return (a > b) ? a : b;
}

void DrawSquare(uint64_t startX, uint64_t startY, uint64_t endX, uint64_t endY, uint32_t color) {
    uint64_t x1 = min(startX, endX);
    uint64_t x2 = max(startX, endX);
    uint64_t y1 = min(startY, endY);
    uint64_t y2 = max(startY, endY);

    for (uint64_t x = x1; x <= x2; ++x) {
        for (uint64_t y = y1; y <= y2; ++y) {
            putpixel(x, y, color);
        }
    }
}

void fontchar(char c, size_t x, size_t y, uint8_t color) {
    const uint8_t *glyph = FONT[(uint8_t)c];

    for (size_t yy = 0; yy < 8; yy++) {
        for (size_t xx = 0; xx < 8; xx++) {
            if (glyph[yy] & (1 << xx)) {
                putpixel(x + xx, y + yy, color);
            }
        }
    }
}

void fontstr(const char *s, size_t x, size_t y, uint8_t color) {
    char c;

    while ((c = *s++) != 0) {
        fontchar(c, x, y, color);
        x += 8;
    }
}