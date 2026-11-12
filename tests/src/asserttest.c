/* asserttest.c - assert.h, with and without NDEBUG, and abort(): a
   failed assertion writes "file:line: assertion failed: e" to stderr and
   aborts, which raises SIGABRT, whose handler here returns; abort() then
   ends the program all the same, with status 134 */

#include <stdio.h>
#include <signal.h>
#include <assert.h>

void handler(sig)
int sig;
{
	printf("SIGABRT handler: %d\n", sig);
	fflush(stdout);
}

int main()
{
	int n = 2;

	assert(n == 2);
	printf("passed\n");
#define NDEBUG
#include <assert.h>
	assert(n == 3);			/* (nothing) */
	printf("NDEBUG\n");
#undef NDEBUG
#include <assert.h>
	fflush(stdout);
	signal(SIGABRT, handler);
	assert(n == 3);
	printf("not reached\n");
	return 0;
}
