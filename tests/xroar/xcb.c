/* run on Color BASIC and Dragon ROMs in XRoar (see run.sh): built by
   bcc09 -Me, loaded from a cassette made by objcopy09 with CLOADM and
   run with EXEC; prints, reads two lines typed on the keyboard (the
   first with a rub-out), uses the heap, and returns 42 to BASIC; a line
   ends with a CR ('\r'), on the screen and from the keyboard, so it is
   read with getdelim() (fgets() would go on to a '\n') */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	char *line = 0;
	size_t size = 0;
	char *p;
	int n;

	printf("HELLO FROM BCC09\r");
	printf("lower case is inverse\r");
	printf("WORD? ");
	fflush(stdout);
	if (getdelim(&line, &size, '\r', stdin) <= 0)
		return 1;
	line[strlen(line) - 1] = 0;
	printf("[%s] HAS %d LETTERS\r", line, (int) strlen(line));
	printf("NUMBER? ");
	fflush(stdout);
	if (getdelim(&line, &size, '\r', stdin) <= 0)
		return 2;
	n = atoi(line);
	printf("%d * 1000 = %ld\r", n, n * 1000L);
	p = malloc(5000);
	printf("MALLOC %s\r", p ? "OK" : "FAILED");
	return 42;
}
