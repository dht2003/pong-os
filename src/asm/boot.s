; boot.s -- Kernel start location 

MBOOT_PAGE_ALIGN equ 1<<0
MBOOT_MEM_INFO equ 1<<1

MBOOT_HEADER_MAGIC equ 0x1BADB002

MBOOT_HEADER_FLAGS equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS) 

KERNEL_STACK_SIZE equ 4096

[BITS 32]


[GLOBAL mboot]
[EXTERN code]
[EXTERN bss]
[EXTERN end]

mboot:
    dd MBOOT_HEADER_MAGIC
    dd MBOOT_HEADER_FLAGS
    dd MBOOT_CHECKSUM

    dd mboot
    dd code
    dd bss
    dd end 
    dd start 
    

[section .text]
[GLOBAL start]
[EXTERN main]
[EXTERN enable_A20]
 

start:
    mov esp , stack_top
    push ebx 
    cli 
    call enable_A20
    call main
    jmp $


[section .bss]
    stack_bottom:
        resb KERNEL_STACK_SIZE
    stack_top:
