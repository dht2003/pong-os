SRC_DIR = ./src
HEADERS_DIR = $(SRC_DIR)/headers
TARGET_NAME = "kernel"
ASM_SRC_DIR = $(SRC_DIR)/asm
C_SRC_DIR = $(SRC_DIR)/c
BUILD_DIR = ./build
TARGET = $(BUILD_DIR)/$(TARGET_NAME)
OBJS_DIR = $(BUILD_DIR)/objs
LDFLAGS= -T link.ld -m elf_i386
ASM = nasm
ASMFLAGS = -f elf -F dwarf -g
CC = gcc
C_INCLUDE_FLAG = -I$(HEADERS_DIR)
CFLAGS = $(C_INCLUDE_FLAG) -m32 -ffreestanding -std=gnu99 -O2 -Wall -Wextra -c 

ASM_SRCS := $(shell find $(ASM_SRC_DIR) -name *.s)
ASM_OBJS := $(ASM_SRCS:$(ASM_SRC_DIR)/%.s=$(OBJS_DIR)/%.o)

C_SRCS := $(shell find $(C_SRC_DIR) -name *.c)
C_OBJS := $(C_SRCS:$(C_SRC_DIR)/%.c=$(OBJS_DIR)/%.o)

COLOUR_GREEN=\033[0;32m
COLOUR_RED=\033[0;31m
COLOUR_END=\033[0m


.PHONY: all
all: $(TARGET)
$(OBJS_DIR)/%.o : $(ASM_SRC_DIR)/%.s
	@echo -e "$(COLOUR_GREEN)[X] Compiling asm file: $< -> $@$(COLOUR_END)" 
	$(ASM) $(ASMFLAGS) $< -o $@

$(OBJS_DIR)/%.o : $(C_SRC_DIR)/%.c
	@echo -e "$(COLOUR_GREEN)[X] Compiling c files : $< -> $@$(COLOUR_END)"
	$(CC) $(CFLAGS) $< -o $@

$(TARGET) : $(C_OBJS) $(ASM_OBJS)
	@echo -e "$(COLOUR_GREEN)[X] linking files$(COLOUR_END)"
	ld $(LDFLAGS)  $(ASM_OBJS) $(C_OBJS) -o $(TARGET)


.PHONY: clean
clean:
	@echo -e "$(COLOUR_RED)[X] Deleting executable $(TARGET)$(COLOUR_END)"
	@$(RM) $(TARGET)
	@echo -e "$(COLOUR_RED)[X] Deleting asm object files$(COLOUR_END)"
	@$(RM) $(ASM_OBJS)
	@echo -e "$(COLOUR_RED)[X] Deleting c object files$(COLOUR_END)"
	@$(RM) $(C_OBJS)

.PHONY: dirs
dirs:
	@echo "$(COLOUR_GREEN)[X] Creating directories$(COLOUR_END)"
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(ASM_SRC_DIR)
	@mkidr -p $(C_SRC_DIR)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OBJS_DIR)

QEMU = qemu-system-i386 
QEMU_FLAGS = -kernel $(TARGET) 
QEMU_MONITOR_FLAG = -monitor stdio

	
.PHONY: qemu
qemu:
	$(MAKE) all --no-print-directory
	@echo -e "$(COLOUR_GREEN)[X] starting qemu$(COLOUR_END)"
	$(QEMU) $(QEMU_FLAGS)

.PHONY: qemu-monitor
qemu-monitor:
	$(MAKE) all --no-print-directory 
	@echo -e "$(COLOUR_GREEN)[X] starting qemu$(COLOUR_END)"
	$(QEMU) $(QEMU_FLAGS) $(QEMU_MONITOR_FLAG) 
