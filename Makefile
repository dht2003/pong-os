PREFIX ?= usr
SYSROOT = $(shell pwd)/sysroot
INCLUDEDIR = $(SYSROOT)/$(PREFIX)/include
ARCH_INCLUDE_DIR = $(INCLUDEDIR)/arch/i386
BOOTDIR = $(SYSROOT)/$(PREFIX)/boot
LIBDIR = $(SYSROOT)/$(PREFIX)/lib

COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_END=\033[0m

AS=nasm
CC=gcc 
LD=ld  
QEMU=qemu-system-i386
QEMU_FLAGS= -cdrom $(ISO_TARGET)

LDFLAGS= -m elf_i386

BUILD_DIR = build
OBJS_DIR = $(BUILD_DIR)/objs
UTIL_DIR = util


KERNELDIR = kernel

KERNEL_TARGET_NAME = pong.kernel
KERNEL_TARGET = $(BUILD_DIR)/$(KERNEL_TARGET_NAME)

KERNEL_INCLUDE_DIR = $(KERNELDIR)/include
KERNEL_ARCH_DIR = $(KERNELDIR)/arch/i386
KERNEl_KERNEL_DIR = $(KERNELDIR)/kernel

KERNEL_KERNEL_SRCS := $(wildcard $(KERNEl_KERNEL_DIR)/*.c)
KERNEL_KERNEL_OBJS := $(KERNEL_KERNEL_SRCS:$(KERNEl_KERNEL_DIR)/%.c=$(OBJS_DIR)/%.o)
KERNEL_KERNEL_DEPS := $(KERNEL_KERNEL_OBJS:.o=.d)

KERNEL_C_SRCS := $(shell find $(KERNEL_ARCH_DIR) -name *.c)
KERNEL_C_OBJS := $(KERNEL_C_SRCS:$(KERNEL_ARCH_DIR)/%.c=$(OBJS_DIR)/%.o)
KERNEL_DEPENDENCIES := $(KERNEL_C_OBJS:.o=.d) 

KERNEL_ASM_SRCS := $(wildcard $(KERNEL_ARCH_DIR)/*.s)
KERNEL_ASM_OBJS := $(KERNEL_ASM_SRCS:$(KERNEL_ARCH_DIR)/%.s=$(OBJS_DIR)/%.o)


LINK_SCRIPT = $(UTIL_DIR)/link.ld
VERIFY_MBOOT_SCRIPT = $(UTIL_DIR)/verify_mboot
GRUB_CONFIG = $(UTIL_DIR)/grub.cfg

ISO_TARGET_NAME = kernel.iso
ISO_TARGET = $(BUILD_DIR)/$(ISO_TARGET_NAME)

LIBCDIR = libc
LIBC_INCLUDE_DIR = $(LIBCDIR)/include
LIBC_ARCH_DIR = $(LIBCDIR)/arch/i386
LIBC_STDIO_DIR = $(LIBCDIR)/stdio
LIBC_STDLIB_DIR = $(LIBCDIR)/stdlib
LIBC_STRING_DIR = $(LIBCDIR)/string

LIBC_ARCH_SRCS = $(shell find $(LIBC_ARCH_DIR) -name *.c)
LIBC_ARCH_OBJS = $(LIBC_ARCH_SRCS:$(LIBC_ARCH_DIR)/%.c=$(OBJS_DIR)/%.o)
LIBC_ARCH_DEPS  = $(LIBC_ARCH_OBJS:.o=.d)

LIBC_STDIO_SRCS = $(shell find $(LIBC_STDIO_DIR) -name *.c)
LIBC_STDIO_OBJS = $(LIBC_STDIO_SRCS:$(LIBC_STDIO_DIR)/%.c=$(OBJS_DIR)/%.o)
LIBC_STDIO_DEPS  = $(LIBC_STDIO_OBJS:.o=.d)

LIBC_STDLIB_SRCS = $(shell find $(LIBC_STDLIB_DIR) -name *.c)
LIBC_STDLIB_OBJS = $(LIBC_STDLIB_SRCS:$(LIBC_STDLIB_DIR)/%.c=$(OBJS_DIR)/%.o)
LIBC_STDLIB_DEPS  = $(LIBC_STDLIB_OBJS:.o=.d)

LIBC_STRING_SRCS = $(shell find $(LIBC_STRING_DIR) -name *.c)
LIBC_STRING_OBJS = $(LIBC_STRING_SRCS:$(LIBC_STRING_DIR)/%.c=$(OBJS_DIR)/%.o)
LIBC_STRING_DEPS  = $(LIBC_STRING_OBJS:.o=.d)

ISODIR = isodir
ISODIR_BOOT = $(ISODIR)/boot
ISODIR_GRUB = $(ISODIR_BOOT)/grub


CFLAGS = -O2 -ffreestanding -Wall -Wextra -m32 -g  -I $(INCLUDEDIR)
COMPILE_CFLAGS = $(CFLAGS) -c -MMD -std=gnu99
NASM_FLAGS = -f elf -F dwarf -g
LDFLAGS = -T $(LINK_SCRIPT)  -m elf_i386

.PHONY: kernel 

kernel: $(KERNEL_TARGET)

$(OBJS_DIR)/%.o  : $(KERNEL_ARCH_DIR)/%.s 
	@echo -e "$(COLOUR_GREEN)Compiling kernel asm file $< -> $@$(COLOUR_END)"
	$(AS) $(NASM_FLAGS) $< -o $@

$(OBJS_DIR)/%.o : $(KERNEL_ARCH_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)Compiling kernel c file $< -> $@$(COLOUR_END)"
	$(CC) $(COMPILE_CFLAGS) $< -c -o $@

$(OBJS_DIR)/%.o : $(KERNEl_KERNEL_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)Compiling kernel's kernel c file $< -> $@$(COLOUR_END)"
	$(CC) $(COMPILE_CFLAGS) $< -c -o $@

$(OBJS_DIR)/%.o : $(LIBC_ARCH_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)Compiling libc arch file $< -> $@$(COLOUR_END)"
	$(CC) $(COMPILE_CFLAGS) $< -o $@

$(OBJS_DIR)/%.o : $(LIBC_STDIO_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)Compiling libc stdio file $< -> $@$(COLOUR_END)"
	$(CC) $(COMPILE_CFLAGS) $< -o $@

$(OBJS_DIR)/%.o : $(LIBC_STDLIB_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)Compiling libc stdlib file $< -> $@$(COLOUR_END)"
	$(CC) $(COMPILE_CFLAGS) $< -o $@

$(OBJS_DIR)/%.o : $(LIBC_STRING_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)Compiling libc string file $< -> $@$(COLOUR_END)"
	$(CC) $(COMPILE_CFLAGS) $< -o $@

$(KERNEL_TARGET) : $(KERNEL_ASM_OBJS) $(KERNEL_C_OBJS) $(LIBC_ARCH_OBJS) $(LIBC_STDIO_OBJS) $(LIBC_STDLIB_OBJS) $(LIBC_STRING_OBJS) $(KERNEL_KERNEL_OBJS)
	@echo -e "$(COLOUR_GREEN)linking all files$(COLOUR_END)"
	$(LD) $(LDFLAGS) $(KERNEL_ASM_OBJS) $(KERNEL_C_OBJS) $(LIBC_ARCH_OBJS) $(LIBC_STDIO_OBJS) $(LIBC_STDLIB_OBJS) $(LIBC_STRING_OBJS) $(KERNEL_KERNEL_OBJS)  -o $(KERNEL_TARGET)
	@$(VERIFY_MBOOT_SCRIPT) $(KERNEL_TARGET)



.PHONY clean-kernel:

clean-kernel:
	@echo -e "$(COLOUR_RED)deleting kernel file$(COLOUR_END)"
	rm -f $(KERNEL_TARGET)
	@echo -e "$(COLOUR_RED)deleting c kernel object files$(COLOUR_END)"
	rm -f $(KERNEL_C_OBJS)
	@echo -e "$(COLOUR_RED)deleting c kernel's kernel object files$(COLOUR_END)"
	rm -f $(KERNEL_KERNEL_OBJS)
	@echo -e "$(COLOUR_RED)deleting asm kernel object files$(COLOUR_END)"
	rm -f $(KERNEL_ASM_OBJS)
	@echo -e "$(COLOUR_RED)deleting kernel dependecies files$(COLOUR_END)"
	rm -f $(KERNEL_DEPENDENCIES)
	@echo -e "$(COLOUR_RED)deleting kernel kernel dependecies files$(COLOUR_END)"
	rm -f $(KERNEL_KERNEL_DEPS)



.PHONY clean-binaries:

clean-binaries:
	@echo -e "$(COLOUR_RED)deleting libc arch dependecies$(COLOUR_END)"
	rm -f $(LIBC_ARCH_DEPS)
	@echo -e "$(COLOUR_RED)deleting libc stdlib objects$(COLOUR_END)"
	rm -f $(LIBC_STDLIB_OBJS)
	@echo -e "$(COLOUR_RED)deleting libc stdlib dependecies$(COLOUR_END)"
	rm -f $(LIBC_STDLIB_DEPS)
	@echo -e "$(COLOUR_RED)deleting libc stdio objects$(COLOUR_END)"
	rm -f $(LIBC_STDIO_OBJS)
	@echo -e "$(COLOUR_RED)deleting libc stdio dependecies$(COLOUR_END)"
	rm -f $(LIBC_STDIO_DEPS)
	@echo -e "$(COLOUR_RED)deleting libc string objects$(COLOUR_END)"
	rm -f $(LIBC_STRING_OBJS)
	@echo -e "$(COLOUR_RED)deleting libc string dependecies$(COLOUR_END)"
	rm -f $(LIBC_STRING_DEPS)

.PHONY: clean
clean : clean-binaries clean-kernel

.PHONY: install-kernel-headers

install-kernel-headers:
	mkdir -p $(SYSROOT)
	mkdir -p $(INCLUDEDIR)
	mkdir -p $(ARCH_INCLUDE_DIR)
	cp -R --preserve=timestamps $(KERNEL_ARCH_DIR)/*.h $(INCLUDEDIR)/arch/i386
	cp -R --preserve=timestamps $(KERNEL_INCLUDE_DIR)/. $(INCLUDEDIR)/.


.PHONY: install-libc-headers
install-libc-headers:
	mkdir -p $(SYSROOT)
	mkdir -p $(SYSROOT)/$(PREFIX)
	mkdir -p $(INCLUDEDIR)
	cp -R --preserve=timestamps $(LIBC_INCLUDE_DIR)/. $(INCLUDEDIR)/.

.PHONY: install-kernel

install-kernel:
	mkdir -p $(SYSROOT)
	mkdir -p $(SYSROOT)/$(PREFIX)
	mkdir -p $(BOOTDIR)	
	cp 	$(KERNEL_TARGET) $(BOOTDIR)


.PHONY: install-libs

install-libs:
	mkdir -p $(SYSROOT)
	mkdir -p $(SYSROOT)/$(PREFIX)
	mkdir -p $(LIBDIR)

.PHONY: install
install : install-kernel-headers install-libc-headers

.PHONY: all
all : install kernel

.PHONY: create-iso
create-iso:
	mkdir -p $(ISODIR_GRUB)
	cp $(KERNEL_TARGET) $(ISODIR_BOOT)
	cp $(GRUB_CONFIG) $(ISODIR_GRUB)
	grub-mkrescue -o $(ISO_TARGET) $(ISODIR)

.PHONY: iso
iso: all create-iso

.PHONY: run_qemu
run_qemu:
	@echo -e "$(COLOUR_GREEN)[X] starting qemu$(COLOUR_END)"	
	$(QEMU) $(QEMU_FLAGS) 

.PHONY: qemu
qemu: all create-iso run_qemu


-include $(KERNEL_DEPENDENCIES)
-include $(LIBC_ARCH_DEPS)
-include $(LIBC_STDIO_DEPS)
-include $(LIBC_STDLIB_DEPS)
-include $(LIBC_STRING_DEPS)
-include $(KERNEL_KERNEL_DEPS)
