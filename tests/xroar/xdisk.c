/* run on the CoCo's Disk BASIC ROMs in XRoar (see run.sh): built by
   bcc09 -Me, loaded from a cassette and run with EXEC, with a disk in
   drive 0 that has IN.DAT on it (made by toolshed's decb): reads IN.DAT,
   writes BIG.DAT (more than two granules, then appended to) and checks
   it, writes OUT.TXT (lines ending with CR, for run.sh to compare), makes
   and deletes DEL.TXT, and checks the errors; prints the failed checks
   and returns their number to BASIC.  failures is __direct, so DP is its
   page but in the calls into the ROM (DSKCON, CHROUT), which want 0 */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

__direct int failures;

void ok(n, cond)
int n, cond;
{
	if (!cond) {
		failures++;
		printf("FAIL %d\r", n);
	}
}

#define BIG	5000		/* (a granule is 2304 bytes) */

/* byte i of BIG.DAT */
#define PAT(i)	((unsigned char) ((i) * 7 + (i) / 251))

int main()
{
	char buf[300];
	int fd, i, n, good;
	long pos;
	FILE *fp;

	printf("DISK TEST\r");

	/* a file decb put there */
	fd = open("IN.DAT", O_RDONLY);
	ok(1, fd >= 3);
	n = read(fd, buf, sizeof(buf));
	ok(2, n == 12 && memcmp(buf, "HELLO, DISK\r", 12) == 0);
	ok(3, read(fd, buf, sizeof(buf)) == 0);
	ok(4, close(fd) == 0);

	/* more than two granules, written in pieces, then appended to */
	fd = open("BIG.DAT", O_WRONLY | O_CREAT | O_TRUNC, 0666);
	ok(5, fd >= 3);
	for (i = 0; i < BIG; i += n) {
		n = BIG - i < 300 ? BIG - i : 300;
		for (pos = 0; pos < n; pos++)
			buf[(int) pos] = PAT(i + (int) pos);
		if (write(fd, buf, n) != n)
			break;
	}
	ok(6, i == BIG);
	ok(7, close(fd) == 0);
	fd = open("BIG.DAT", O_WRONLY | O_APPEND);
	for (i = 0; i < 100; i++)
		buf[i] = PAT(BIG + i);
	ok(8, write(fd, buf, 100) == 100);
	ok(9, close(fd) == 0);

	/* read back, and seek */
	fd = open("BIG.DAT", O_RDONLY);
	ok(10, lseek(fd, 0L, SEEK_END) == BIG + 100L);
	ok(11, lseek(fd, 0L, SEEK_SET) == 0L);
	good = 1;
	for (i = 0; (n = read(fd, buf, 256)) > 0; i += n)
		for (pos = 0; pos < n; pos++)
			if ((unsigned char) buf[(int) pos] != PAT(i + (int) pos))
				good = 0;
	ok(12, good && i == BIG + 100);
	ok(13, lseek(fd, 2304L, SEEK_SET) == 2304L &&
	   read(fd, buf, 1) == 1 && (unsigned char) buf[0] == PAT(2304));
	ok(14, lseek(fd, 1L, SEEK_END) == -1L && errno == EINVAL);
	close(fd);

	/* stdio, lines ending with CR */
	fp = fopen("OUT.TXT", "w");
	ok(15, fp != 0);
	for (i = 1; i <= 3; i++)
		fprintf(fp, "LINE %d\r", i);
	ok(16, fclose(fp) == 0);

	/* made and deleted; errors */
	fd = open("DEL.TXT", O_WRONLY | O_CREAT | O_EXCL, 0666);
	ok(17, fd >= 3 && write(fd, "X", 1) == 1);
	ok(18, unlink("DEL.TXT") == -1 && errno == EBUSY);
	close(fd);
	ok(19, open("DEL.TXT", O_WRONLY | O_CREAT | O_EXCL, 0666) == -1 &&
	   errno == EEXIST);
	ok(20, unlink("DEL.TXT") == 0);
	ok(21, open("DEL.TXT", O_RDONLY) == -1 && errno == ENOENT);
	ok(22, open("NONAME.TOOLONG", O_RDONLY) == -1 && errno == ENOENT);
	ok(23, open("IN.DAT:1", O_RDONLY) == -1 && errno == EIO);

	printf("%d FAILED\r", failures);
	return failures;
}
