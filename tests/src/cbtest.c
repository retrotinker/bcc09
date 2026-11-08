/* built by bcc09 -Me (Color BASIC) alone, and run on sim6809 with
   cbrom.s standing in for the ROM and loader.s for EXEC: prints, reads
   lines from the "keyboard" (cbtest.in, with a rub-out in it) until
   BREAK, uses the heap, and returns the number of lines to BASIC */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	char buf[40], *p;
	int lines = 0;

	printf("hello from Color BASIC\n");
	while (fgets(buf, sizeof(buf), stdin) != 0) {
		lines++;
		printf("got %d: [%.*s]\n", (int) strlen(buf), (int) strlen(buf) - 1,
		       buf);
	}
	p = malloc(1000);
	printf("malloc %s\n", p ? "ok" : "failed");
	printf("%d lines\n", lines);
	return lines;
}
