/* romtest.c - a Color BASIC ROM cartridge (bcc09 -Mr), linked with
   rom.ld (with S-record output) and run on sim6809 with cbrom.s for the
   ROM's POLCAT and CHROUT (see run.sh): crtrom.o must have copied the
   initialized data from the ROM to RAM and cleared the BSS (sim6809
   fills memory with $A5), and called the init functions (printf's
   floating point formats are installed by one); reads lines until
   BREAK, uses the heap, and runs its atexit() function before _exit()
   stops in its loop */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int count = 3;
char word[] = "INITIALIZED";
char bss[64];
double half = 0.5;

void bye()
{
	printf("ATEXIT\r");
}

int main()
{
	char *line = 0, *copy;
	size_t size = 0;
	int i, clear = 1;

	atexit(bye);
	for (i = 0; i < sizeof bss; ++i)
		if (bss[i])
			clear = 0;
	printf("CARTRIDGE: %s %d\r", word, count);
	printf("BSS %s, %g\r", clear ? "CLEAR" : "NOT CLEAR", half * count);
	word[0] = 'i';		/* the data is in RAM */
	printf("%s\r", word);
	while (getdelim(&line, &size, '\r', stdin) > 0) {
		line[strlen(line) - 1] = 0;
		if ((copy = malloc(strlen(line) + 1)) == 0)
			return 1;
		strcpy(copy, line);
		printf("[%s] AT %s\r", copy,
		       copy >= (char *)0x0600 && copy < (char *)0x8000 ?
		       "RAM" : "?");
	}
	return 42;
}
