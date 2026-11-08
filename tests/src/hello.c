/* built by bcc09 -Mi (for sim6809) alone: prints a line, and returns 3,
   which becomes the simulator's exit status */

#include <unistd.h>

int main()
{
	write(1, "hello, world\n", 13);
	return 3;
}
