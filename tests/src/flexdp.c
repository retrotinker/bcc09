/* flexdp.c - __direct variables in a FLEX command (-Mf): DP is their
   page, and FLEX's calls (PUTCHR for printf, INCH for a line, FMS for a
   file) give it back; the variables keep their values through them */

#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>

__direct int count = 7;
__direct char line[16];

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
	int fd, n, page = (unsigned)&count >> 8, bad = 0;

	bad += getdp() != page;
	printf("COUNT %d\r\n", count);
	bad += getdp() != page;
	n = read(0, line, sizeof line - 1);
	line[n > 0 ? n : 0] = 0;
	bad += getdp() != page;
	fd = open("DP.TXT", O_WRONLY | O_CREAT | O_TRUNC);
	write(fd, line, n);
	close(fd);
	bad += getdp() != page;
	count += n;
	printf("READ %d, COUNT %d, DP %s\r\n", n, count, bad ? "WRONG" : "RIGHT");
	unlink("DP.TXT");
	return bad;
}
