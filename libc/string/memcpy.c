#include <string.h>

void *memcpy(void * restrict dest,const void * restrict src, size_t n) {
    unsigned char *dp =  (unsigned char *)dest;
    const unsigned char *sp = (const unsigned char *)src;
    while (n--) 
        *dp++ = *sp++;
    return dp;
}
