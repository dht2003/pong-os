#ifndef KERNEL_TTY_H
#define KERNEL_TTY_H

#include <stdint.h>

void monitor_put(char c);

void monitor_put_color(uint8_t color);

void monitor_clear();

void monitor_write(const char * s);

void monitor_write_base(uint32_t n,uint32_t base);

void monitor_write_hex(uint32_t n);

void monitor_write_dec(uint32_t n);

void monitor_color_test();


#endif
