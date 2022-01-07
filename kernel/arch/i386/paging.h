#ifndef PAGING_H
#define PAGEING_H

#include <stdint.h>
#include <stdbool.h>
#include <arch/i386/isr.h>

#define TABLE_SIZE 1024
#define DIRECTORY_SIZE 1024
#define PAGE_SIZE 4096



typedef struct Page_entry_struct {
    uint32_t present : 1;
    uint32_t rw : 1;
    uint32_t us : 1;
    uint32_t reserved : 1;
    uint32_t accessed : 1;
    uint32_t dirty : 1;
    uint32_t avail : 1;
    uint32_t address : 20; 
} page_entry_t;

typedef struct Page_table_struct {
    page_entry_t table[TABLE_SIZE];
} page_table_t;

typedef struct Page_directory_struct {
    page_table_t *tables[DIRECTORY_SIZE];
    uint32_t tablesPhysical[1024];
    uint32_t physicalAddr;
} page_directory_t;

void init_paging();

void switch_page_directory(page_directory_t *dir);

page_entry_t *get_page(uint32_t addr,bool make,page_directory_t *dir);

void page_fault(registers_t regs);


#endif