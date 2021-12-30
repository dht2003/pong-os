#include <stdio.h>
#include <kernel/tty.h>

int putchar(int ic) {
	char c = (char) ic;
	monitor_put(c);
	return ic;
}
