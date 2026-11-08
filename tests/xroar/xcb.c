/* run on Color BASIC and Dragon ROMs in XRoar (see run.sh): built by
   bcc09 -Me, loaded from a cassette made by objcopy09 with CLOADM and
   run with EXEC; prints, reads two lines typed on the keyboard (the
   first with a rub-out), uses the heap, and returns 42 to BASIC */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main()
{
	char line[32];
	char *p;
	int n;

	printf("HELLO FROM BCC09\n");
	printf("lower case is inverse\n");
	printf("WORD? ");
	fflush(stdout);
	if (fgets(line, sizeof(line), stdin) == 0)
		return 1;
	line[strlen(line) - 1] = 0;
	printf("[%s] HAS %d LETTERS\n", line, (int) strlen(line));
	printf("NUMBER? ");
	fflush(stdout);
	if (fgets(line, sizeof(line), stdin) == 0)
		return 2;
	n = atoi(line);
	printf("%d * 1000 = %ld\n", n, n * 1000L);
	p = malloc(5000);
	printf("MALLOC %s\n", p ? "OK" : "FAILED");
	return 42;
}
