#include "common.h"

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

void *memcpy(void *dest,const void *src, size_t n) {
    char *dp =  dest;
    const char *sp = src;
    while (n--) 
        *dp++ = *sp++;
    return dp;
}

void *memset(void *dest,int32_t value,size_t n) {
    char *dp = dest;
    while (n--) 
        *dp = value;
    return dp;
}

size_t strlen(string s) {
    uint32_t len = 0;
    while (*s++ != '\0')  len++;
    return len;
}

int32_t strcmp(string s1, string s2) {
    while(*s1 != '\0' && (*s1++ == *s2++));
    return (int32_t) *s1 - (int32_t) *s2;
}

char *strcpy(char *dest, const char * src) {
    while (*src != '\0')
       *dest++ = *src++;
    return dest; 
}