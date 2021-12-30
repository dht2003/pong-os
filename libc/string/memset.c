#include <string.h>

void *memset(void *dest,int value,size_t n) {
    char *dp = dest;
    while (n--) 
        *dp = value;
    return dp;
}