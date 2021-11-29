// main.c 
#include "common.h"
#include "monitor.h"
#include "gdt.h"
#include "idt.h"
#include "timer.h"
#include "keyboard.h"

int main(struct multiboot *mboot_ptr) {
    init_gdt();
    init_idt();
    monitor_clear();
    asm volatile("sti");
    monitor_color_test();
    init_timer(50);
    init_keyboard();
    return 0xDEADBABA;
}