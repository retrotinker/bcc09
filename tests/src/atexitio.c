/* atexitio.c - a function registered with atexit() before stdio is
   first used prints when exit() runs it: exit() must flush the streams
   after it (dev86's libc flushed them first, through a function that
   stdio registered with atexit() when it was first used, and the text,
   with no newline to flush a line-buffered stdout, was lost) */

#include <stdio.h>
#include <stdlib.h>

void bye()
{
	printf("bye, from atexit");
}

int main()
{
	atexit(bye);
	printf("main\n");
	return 0;
}
