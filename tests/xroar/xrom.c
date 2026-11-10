/* run as a Color BASIC ROM cartridge on CoCo and Dragon ROMs in XRoar
   (see run.sh): built by bcc09 -Mr, whose start-up code copies the
   initialized data from the ROM to RAM at $0600 and clears the BSS;
   prints the data, whether the BSS is clear, a floating point product
   (whose formatting an init function installs), reads a line typed on
   the keyboard, and stops with status 42 */

#include <stdio.h>
#include <string.h>

char marker[] = "XROM DATA AT 0600";	/* first: run.sh finds RAM by it */
int count = 3;
char word[] = "INITIALIZED";
char bss[64];
double half = 0.5;

int main()
{
	char *line = 0;
	size_t size = 0;
	int i, clear = 1;

	for (i = 0; i < sizeof bss; ++i)
		if (bss[i])
			clear = 0;
	printf("CARTRIDGE: %s %d\r", word, count);
	printf("BSS %s, %g\r", clear ? "CLEAR" : "NOT CLEAR", half * count);
	printf("WORD? ");
	fflush(stdout);
	if (getdelim(&line, &size, '\r', stdin) <= 0)
		return 1;
	line[strlen(line) - 1] = 0;
	printf("[%s]\r", line);
	return 42;
}
