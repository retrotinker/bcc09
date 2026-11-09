/* built by bcc09 -Mf (FLEX) and run by sim6809 --flex: FLEX's files
   (libc/flex/file.c, on FLEX's File Management System): text files, whose
   runs of spaces FLEX stores compressed, read as text and as binary;
   binary files (fopen's "b"), whose last sector is padded with zeros;
   lseek() on a file open for reading; replacing a file (O_TRUNC); errors;
   names (made upper case, with a drive before or after); rename() and
   unlink().  It leaves TEXT.TXT, BIN.DAT, DRV.TXT and LOWER.TXT, whose
   bytes (the sectors' data) the tests keep, and compare with the same
   program's on real FLEX; prints what each step gives, and returns the
   number of failed checks */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

int checks, failures;

void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\r\n", n);
	}
}

/* byte i of BIN.DAT: zeros and $09s among the rest */
#define PAT(i)	((unsigned char) ((i) % 50 == 0 ? 0 : (i) % 50 == 1 ? 9 : (i) * 7))

char *lines[] = {
	"A    B\r",
	"no spaces\r",
	"  two at the start, and one at the end \r",
	0,			/* (a run of 130: filled in) */
};

/* the whole file name, read in mode; its length */
int slurp(name, mode, buf, size)
char *name, *mode, *buf;
int size;
{
	FILE *fp = fopen(name, mode);
	int n;

	if (fp == 0)
		return -1;
	n = fread(buf, 1, size, fp);
	fclose(fp);
	return n;
}

int main()
{
	static char buf[700], run[140];
	FILE *fp;
	char *line = 0;
	size_t size = 0;
	int i, n, fd, good;

	/* a text file, and its lines read back */
	run[0] = 'x';
	memset(run + 1, ' ', 130);
	strcpy(run + 131, "y\r");
	lines[3] = run;
	fp = fopen("TEXT.TXT", "w");
	ok(1, fp != 0);
	for (i = 0; i < 4; i++)
		fputs(lines[i], fp);
	ok(2, fclose(fp) == 0);
	fp = fopen("TEXT.TXT", "r");
	good = 1;
	for (i = 0; (n = getdelim(&line, &size, '\r', fp)) > 0; i++)
		if (i >= 4 || strcmp(line, lines[i]) != 0)
			good = 0;
	ok(3, good && i == 4);
	fclose(fp);
	printf("text: %d lines\r\n", i);

	/* the same, as stored: compressed, and padded to a sector */
	n = slurp("TEXT.TXT", "rb", buf, sizeof(buf));
	printf("stored: %d bytes:", n);
	for (i = 0; i < 6; i++)
		printf(" %02x", (unsigned char) buf[i]);
	printf("\r\n");
	ok(4, n == 252 && buf[n - 1] == 0);

	/* a binary file: zeros and $09s as they are, padded with zeros */
	fp = fopen("BIN.DAT", "wb");
	for (i = 0; i < 300; i++)
		putc(PAT(i), fp);
	fclose(fp);
	n = slurp("BIN.DAT", "rb", buf, sizeof(buf));
	good = 1;
	for (i = 0; i < 300; i++)
		if ((unsigned char) buf[i] != PAT(i))
			good = 0;
	for (; i < n; i++)
		if (buf[i] != 0)
			good = 0;
	ok(5, good && n == 504);
	printf("binary: %d bytes\r\n", n);

	/* lseek(), reading */
	fd = open("BIN.DAT", O_RDONLY | O_BINARY);
	ok(6, lseek(fd, 100L, SEEK_SET) == 100L && read(fd, buf, 1) == 1 &&
	   (unsigned char) buf[0] == PAT(100));
	ok(7, lseek(fd, 10L, SEEK_SET) == 10L && read(fd, buf, 2) == 2 &&
	   (unsigned char) buf[1] == PAT(11));
	ok(8, lseek(fd, 0L, SEEK_END) == 504L);
	errno = 0;
	ok(9, lseek(fd, 505L, SEEK_SET) == -1L && errno == EINVAL);
	close(fd);

	/* replacing a file */
	fp = fopen("OLD.TXT", "w");
	fputs("old\r", fp);
	fclose(fp);
	fp = fopen("OLD.TXT", "w");
	fputs("new\r", fp);
	fclose(fp);
	ok(10, slurp("OLD.TXT", "r", buf, sizeof(buf)) == 4 &&
	   memcmp(buf, "new\r", 4) == 0);

	/* errors */
	errno = 0;
	ok(11, open("NOFILE.TXT", O_RDONLY) == -1 && errno == ENOENT);
	errno = 0;
	ok(12, open("OLD.TXT", O_WRONLY | O_CREAT | O_EXCL) == -1 &&
	   errno == EEXIST);
	errno = 0;
	ok(13, open("OLD.TXT", O_WRONLY) == -1 && errno == EINVAL);
	errno = 0;
	ok(14, open("OLD.TXT", O_RDWR) == -1 && errno == EINVAL);
	errno = 0;
	ok(15, open("OLD.TXT", O_WRONLY | O_APPEND) == -1 && errno == EINVAL);
	errno = 0;
	ok(16, open("NEW.TXT", O_WRONLY) == -1 && errno == ENOENT &&
	   open("NEW.TXT", O_RDONLY) == -1);
	errno = 0;
	ok(17, open("1BAD.TXT", O_RDONLY) == -1 && errno == ENOENT);
	errno = 0;
	ok(18, open("TOOLONGNAME.TXT", O_RDONLY) == -1 && errno == ENOENT);
	errno = 0;
	ok(19, open("A.B.C.D", O_RDONLY) == -1 && errno == ENOENT);
	errno = 0;
	fd = open("OLD.TXT", O_RDONLY);
	ok(20, write(fd, "x", 1) == -1 && errno == EBADF);
	close(fd);

	/* names: upper case, a drive before or after */
	fp = fopen("lower.txt", "w");
	fputs("lower\r", fp);
	fclose(fp);
	ok(21, slurp("LOWER.TXT", "r", buf, sizeof(buf)) == 6);
	fp = fopen("0.DRV.TXT", "w");
	fputs("drive\r", fp);
	fclose(fp);
	ok(22, slurp("DRV.TXT.0", "r", buf, sizeof(buf)) == 6);

	/* rename(), unlink() */
	ok(23, rename("OLD.TXT", "RENAMED.TXT") == 0);
	errno = 0;
	ok(24, open("OLD.TXT", O_RDONLY) == -1 && errno == ENOENT);
	errno = 0;
	ok(25, rename("RENAMED.TXT", "TEXT.TXT") == -1 && errno == EEXIST);
	ok(26, unlink("RENAMED.TXT") == 0);
	errno = 0;
	ok(27, unlink("RENAMED.TXT") == -1 && errno == ENOENT);

	printf("checks %d failures %d\r\n", checks, failures);
	return failures;
}
