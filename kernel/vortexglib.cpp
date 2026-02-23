// Modified from BreezeOS (https://github.com/atlassoftware-cpu/BreezeOS)

#pragma once
#include "font.h"
#include "vga.cpp"

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