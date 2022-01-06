#ifndef STACK_H
#define STACK_H

#define STACK_SIZE 4096

#include <stdint.h>
#include <stdbool.h>

typedef struct Stack {
    int32_t arr[STACK_SIZE];
    int top;
} stack_t;

void push(stack_t *stack,int32_t value);

int32_t pop(stack_t *stack);


bool isEmpty(stack_t stack);

bool isFull(stack_t stack);

void empty(stack_t *stack);

#endif