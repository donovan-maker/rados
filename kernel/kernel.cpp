#include "vortexglib.cpp"

extern "C" void kmain() {
    setupvga();
    fillscreen(0x0);
    fontstr("Hello world from the Ra-dos kernel!", 0, 0, 0xF);

    fontstr("The kernel is halting with nothing else to do.", 0, 10, 0xF);
    while (1) {};
}