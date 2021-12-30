// main.c 
#include <arch/i386/ports.h>
#include <kernel/tty.h>
#include <arch/i386/gdt.h>
#include <arch/i386/idt.h>
#include <arch/i386/timer.h>
#include <arch/i386/keyboard.h>

int kmain(struct multiboot *mboot_ptr) {
    init_gdt();
    init_idt();
    monitor_clear();
    asm volatile("sti");
    monitor_color_test();
    init_timer(50);
    init_keyboard();
    return 0xDEADBABA;
}