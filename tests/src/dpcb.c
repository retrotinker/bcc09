/* dpcb.c - __direct variables in a Color BASIC program (-Me), run with
   cbrom.s and cbdisk.s, whose routines print # if they are called with DP
   other than 0: printf() (CHROUT), reading a line (POLCAT), joystk()
   (JOYIN) and a file (DSKCON), all with DP set to the variables' page in
   between */

#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <coco.h>

__direct int count = 3;
__direct char line[20];
__direct int joy;

int getdp()
{
	asm("tfr dp,a", "tfr a,b", "clra", "tfr d,x");
}

int main()
{
	int fd, n, page = (unsigned)&count >> 8;

	printf("DP %s\r", getdp() == page ? "is the variables' page" : "is wrong");
	printf("A LINE? ");
	fflush(stdout);
	n = read(0, line, sizeof line - 1);
	line[n > 0 ? n : 0] = 0;
	printf("READ %d\r", n);
	joy = joystk(0) + joystk(3);
	printf("JOYSTK %d\r", joy);
	fd = open("DP.DAT", O_WRONLY | O_CREAT | O_TRUNC);
	write(fd, line, strlen(line));
	close(fd);
	fd = open("DP.DAT", O_RDONLY);
	n = read(fd, line, sizeof line - 1);
	close(fd);
	line[n > 0 ? n : 0] = 0;
	printf("FILE %d: %s", n, line);
	printf("DP %s\r", getdp() == page ? "is still the page" : "is wrong");
	return count + (getdp() == page ? 0 : 100);
}
