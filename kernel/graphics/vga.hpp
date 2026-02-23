#pragma once

#include "../cpu/ports.hpp"

#define VGA_GC_INDEX 0x3CE
#define VGA_GC_DATA 0x3CF
#define VGA_SC_INDEX 0x3C4
#define VGA_SC_DATA 0x3C5
#define VGA_MEMORY ((uint8_t*)0xA0000)

void setupvga(void);
void putpixel(int x, int y, uint8_t color);
void fillscreen(uint8_t color);
void DrawSquareFast(int x1, int y1, int x2, int y2, uint8_t color);