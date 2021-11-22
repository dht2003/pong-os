// main.c 
#include "common.h"
#include "monitor.h"
#include "gdt.h"
#include "idt.h"
#include "timer.h"

int main(struct multiboot *mboot_ptr) {
    init_gdt();
    init_idt();
    monitor_clear();
    init_timer(50);
    return 0xDEADBABA;
}