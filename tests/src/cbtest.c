/* built by bcc09 -Me (Color BASIC) alone, and run on sim6809 with
   cbrom.s standing in for the ROM and loader.s for EXEC: prints, reads
   lines from the "keyboard" (cbtest.in, with a rub-out in it) until
   BREAK, uses the heap, and returns the number of lines to BASIC; a
   line ends with a CR ('\r'), on the screen and from the keyboard, so
   it is read with getdelim() (fgets() would go on to a '\n') */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	char *line = 0, *p;
	size_t size = 0;
	int n, lines = 0;

	printf("hello from Color BASIC\r");
	while ((n = getdelim(&line, &size, '\r', stdin)) > 0) {
		lines++;
		printf("got %d: [%.*s]\r", n, n - 1, line);
	}
	p = malloc(1000);
	printf("malloc %s\r", p ? "ok" : "failed");
	printf("%d lines\r", lines);
	return lines;
}
