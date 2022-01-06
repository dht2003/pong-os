#include <arch/i386/stack.h>

bool isFull(stack_t stack) {
    return STACK_SIZE - 1 == stack.top;
}

bool isEmpty(stack_t stack) {
    return stack.top == -1;
}

int32_t pop(stack_t *stack) {
    if (isEmpty(*stack)) {
        return -1;
    }
    return stack->arr[stack->top--];
}

void push(stack_t *stack,int32_t value) {
    if (isFull(*stack)) {
        empty(stack);
    }
    stack->arr[++(stack->top)] = value;
}

void empty(stack_t *stack) {
    stack->top = -1;
}
