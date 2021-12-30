#ifndef TIMER_H
#define TIMER_H

#include <arch/i386/ports.h>
#include <arch/i386/isr.h>
#include <kernel/tty.h>
#include <stdint.h>

void init_timer(uint32_t frequency);


#endif