#include <arch/i386/keyboard.h>

static void keyboard_callback() {
    uint8_t code =  inb(0x60);
    monitor_write_hex(code);
}

void init_keyboard() {
    register_interrupt_handler(IRQ1,&keyboard_callback);
}