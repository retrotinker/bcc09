/* built by bcc09 -Mi (for sim6809) alone: reads its input a line at a
   time and writes each line back in upper case; checks read and write
   with bad file descriptors; an atexit() function writes a last line;
   exits with the number of lines read (echo.in has 4) */

#include <ctype.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

void bye()
{
	write(1, "bye\n", 4);
}

void say(s)
char *s;
{
	write(1, s, strlen(s));
}

int main()
{
	char buf[80];
	int n, i, lines;

	atexit(bye);
	errno = 0;
	if (write(3, "x", 1) != -1 || errno != EBADF)
		say("write(3) should fail\n");
	errno = 0;
	if (read(1, buf, 1) != -1 || errno != EBADF)
		say("read(1) should fail\n");
	if (write(2, "to stderr\n", 10) != 10)
		say("write(2) should work\n");
	if (write(1, "", 0) != 0)
		say("write(1, \"\", 0) should give 0\n");

	lines = 0;
	while ((n = read(0, buf, sizeof(buf))) > 0) {
		for (i = 0; i < n; i++)
			buf[i] = toupper(buf[i]);
		write(1, buf, n);
		if (buf[n - 1] == '\n')
			lines++;
	}
	if (read(0, buf, sizeof(buf)) != 0)
		say("read() at the end should give 0\n");
	return lines;
}
