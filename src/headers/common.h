#ifndef COMMON_H
#define COMMON_H

#include <stdint.h>
#include <stddef.h>

#define lEightShift(val) (val << 8)
#define rEightShift(val) (val >> 8) 
#define byteMask(val) (val & 0xFF)
#define fourBitMask(val) (val & 0x0F)
#define wordMask(val) (val & 0xFFFF)


typedef const char * string;


void outb(uint16_t port,uint8_t value);
uint8_t inb(uint16_t port);
uint16_t inw(uint16_t port);

void *memcpy(void *dest,const void * src,size_t n);

void *memset(void *dest,int32_t value , size_t n);

size_t strlen(string s);

int32_t strcmp(string s1 , string s2);

char *strcpy(char *dest,const char * src);

#endif