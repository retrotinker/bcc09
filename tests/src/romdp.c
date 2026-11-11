/* romdp.c - __direct variables in a ROM cartridge (-Mr, rom.ld): DP is
   their page (in RAM from $0600), initialized ones copied from the ROM
   and the rest cleared, and printf() calls the ROM (cbrom.s) with DP 0;
   it prints their values, and a map line shows where they are */

#include <stdio.h>

__direct int init = 1234;
__direct int bss;
__direct char word[] = "DIRECT";

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
	int page = (unsigned)&init >> 8;

	printf("%s %d %d, DP %s, bss %s\r", word, init, bss,
	       getdp() == page ? "right" : "wrong",
	       (unsigned)&bss >> 8 == page ? "in its page" : "elsewhere");
	return 0;
}
