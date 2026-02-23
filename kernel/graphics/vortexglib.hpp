#pragma once
#include "font.h"
#include "vga.hpp"

void fontchar(char c, size_t x, size_t y, uint8_t color);
void fontstr(const char *s, size_t x, size_t y, uint8_t color);