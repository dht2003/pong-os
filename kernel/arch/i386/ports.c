#include <arch/i386/ports.h>

// Writes a byte to the specified port 
void outb(uint16_t port, uint8_t value) {
    asm volatile("outb %1, %0" : : "dN" (port), "a" (value));
}

// Reads a byte from the specified port
uint8_t inb(uint16_t port) {
    uint8_t ret;
    asm volatile("inb %1,%0" : "=a" (ret) : "dN" (port));
    return ret;
}

// Reads a word from the specifiend port 
uint16_t inw(uint16_t port) {
    uint16_t ret;
    asm volatile("inw %1, %0" : "=a" (ret) : "dN" (port));
    return ret;
}

