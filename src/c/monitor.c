#include "monitor.h"

#define FRAME_BUFFER_ADDR 0xB8000
#define HEIGHT 25
#define WIDTH 80

#define BACK_SPACE 0x08
#define TAB 0x09


uint16_t *video_memory = (uint16_t *) FRAME_BUFFER_ADDR; 

uint8_t cursorX = 0;
uint8_t cursorY = 0;

const uint8_t blankAttributeByte = (VGA_COLOR_BLACK << 4) | (fourBitMask(VGA_COLOR_WHITE));
const uint16_t BLANK =  ' ' | (lEightShift(blankAttributeByte));

static void move_cursor() {
    uint16_t curserLocation = cursorY * 80 + cursorX;
    outb(0x3d4,14);
    outb(0x3d5,byteMask((rEightShift(curserLocation))));
    outb(0x3d4,15);
    outb(0x3d5,byteMask(curserLocation));
}

static void scroll() {
    if (cursorY >= HEIGHT) {
        int i;
        for (i = 0; i < (HEIGHT - 1) * WIDTH; i++)
            video_memory[i] = video_memory[i + WIDTH]; 
        for (;i < HEIGHT * WIDTH; i++) 
            video_memory[i] = BLANK;
        cursorY = HEIGHT - 1;
    }
}

void monitor_put(char c) {
    uint8_t backgroundColor = VGA_COLOR_BLACK;
    uint8_t foreGroundColor = VGA_COLOR_WHITE;

    uint8_t attributeByte = (backgroundColor << 4) | (fourBitMask(foreGroundColor));

    if (c == BACK_SPACE && cursorX)  
        cursorX--;
    else if(c == TAB)
        cursorX = (cursorX + 8) & ~(8-1);
    
    else if(c == '\r') 
        cursorX = 0;
    
    else if(c == '\n') {
        cursorX = 0;
        cursorY++;
    }
    
    else if(c >= ' ') {
        uint16_t location = cursorY*WIDTH + cursorX;
        video_memory[location] = c | (lEightShift(attributeByte));
        cursorX++;
    }

    if (cursorX >= WIDTH) {
        cursorX = 0;
        cursorY++;
    }

    scroll();

    move_cursor();
}

void monitor_put_color(vga_color color) {
    uint8_t colorBlankAttributeByte = (color << 4) | (fourBitMask(VGA_COLOR_WHITE));   
    uint16_t colorBlank =  ' ' | (lEightShift(colorBlankAttributeByte));
    uint16_t location = cursorY * WIDTH + cursorX;
    video_memory[location] = colorBlank;
    cursorX++;
    if (cursorX >= WIDTH) {
        cursorX = 0;
        cursorY++;
    }
    scroll();
    move_cursor();
}

void monitor_clear() {
    for (int i = 0; i < WIDTH * HEIGHT; i++) 
        video_memory[i] = BLANK;
    cursorY = 0;
    cursorX = 0;
    move_cursor();
}

void monitor_write(string s) {
    int i = 0;
    while (s[i])
        monitor_put(s[i++]);
}

void monitor_write_base(uint32_t n,uint32_t base) {
    uint32_t reversed = 0;
    uint32_t copy = n;
    while (copy) {
        reversed = reversed * base + copy % base;
        copy /= base;
    } 
    do {
        uint32_t reminder = reversed % base;
        if (reminder < 10)         
           monitor_put('0' + reminder);
        else 
            monitor_put('A' + (reminder - 10)); 
        reversed /= base;
    } while(reversed);
}

void monitor_write_dec(uint32_t n) {
    monitor_write_base(n,10);
}

void monitor_write_hex(uint32_t n) {
    monitor_write("0x");
    monitor_write_base(n,16);
}

void monitor_color_test() {
    for (int i = 0; i < HEIGHT; i++) 
        for (int j = 0; j < WIDTH; j++)
            monitor_put_color(i % 15);
}


void updateScreen() {
    for (int i = 0; i < HEIGHT; i++) {
        memset(&video_memory[((i + 1) % HEIGHT) * WIDTH],BLANK,WIDTH);
    }
}

