#ifndef PAGING_H
#define PAGEING_H

#define TABLE_SIZE 1024
#define DIRECTORY_SIZE 1024

#include <stdint.h>

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
    page_table_t *directory[DIRECTORY_SIZE];
} page_directory_t;


#endif