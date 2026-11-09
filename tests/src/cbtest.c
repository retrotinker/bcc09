/* built by bcc09 -Me (Color BASIC) alone, and run on sim6809 with
   cbrom.s standing in for the ROM and loader.s for EXEC: prints, reads
   lines from the "keyboard" (cbtest.in, with a rub-out in it) until
   BREAK, uses the heap, and returns the number of lines to BASIC; a
   line ends with a CR ('\r'), on the screen and from the keyboard */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* a line from stdin, up to its CR (fgets() would go on to '\n') */
char *getline(buf, n)
char *buf;
int n;
{
	int c, i = 0;

	while (i < n - 1 && (c = getchar()) != EOF) {
		buf[i++] = c;
		if (c == '\r')
			break;
	}
	buf[i] = 0;
	return i ? buf : 0;
}

int main()
{
	char buf[40], *p;
	int lines = 0;

	printf("hello from Color BASIC\r");
	while (getline(buf, sizeof(buf)) != 0) {
		lines++;
		printf("got %d: [%.*s]\r", (int) strlen(buf), (int) strlen(buf) - 1,
		       buf);
	}
	p = malloc(1000);
	printf("malloc %s\r", p ? "ok" : "failed");
	printf("%d lines\r", lines);
	return lines;
}
