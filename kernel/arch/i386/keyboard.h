#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <arch/i386/isr.h>
#include <kernel/tty.h>
#include <stdbool.h>
#include <arch/i386/stack.h>

void init_keyboard();

typedef struct keyboard_struct
{
    char last_pressed;
    bool caps;
    stack_t buffer;
} keyboard_state_t;

extern keyboard_state_t keyboard_state;

#endif