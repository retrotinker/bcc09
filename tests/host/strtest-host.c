/* output for tests/src/strtest.c built on the host, with the host's C
   library: putnum() as simcrt0.s does it on sim6809 */

#include <stdio.h>

void putnum(n)
int n;
{
	printf("%u\n", n & 0xffff);
}
