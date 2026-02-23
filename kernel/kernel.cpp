#include "graphics/vortexglib.hpp"

extern "C" void kmain() {
    setupvga();
    fillscreen(0x0);
    fontstr("Hello world from the Ra-dos kernel!", 0, 0, 0xF);

    fontstr("The kernel is halting with nothing else to do.", 0, 10, 0xF);

    //DrawSquareFast(10, 10, 400, 280, 0xF);
    //DrawSquareFast(65, 45, 544, 234, 0x4);
    //DrawSquareFast(123, 321, 243, 12, 0x8);
    while (1) {};
}