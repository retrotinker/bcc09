/* linked by bcc09 with the default crt0: returning from main calls
   exit(), which calls the atexit() functions, last registered first;
   the first registered, run last, exits with a record of the order
   (21 if right), in place of main's 5 */

#include <stdlib.h>

int order;

void first()
{
	_exit(order);
}

void second()
{
	order = order * 10 + 1;
}

void third()
{
	order = order * 10 + 2;
}

int main()
{
	atexit(first);
	atexit(second);
	atexit(third);
	return 5;
}
