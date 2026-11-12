/* built by bcc09 -Me (Color BASIC) and run on sim6809 with cbrom.s and
   cbdisk.s standing in for the ROMs (cbdisk.s's disk has room for 4
   granules) and loader.s for EXEC: Disk BASIC's files (libc/cb/disk.c):
   files of several granules written, appended to, read and sought in;
   stdio; a full disk; deleting; truncating; errors; and the FAT's and
   the directory's bytes as they end up; prints the failed checks, and
   returns their number */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>

extern int __cb_dskcon();	/* (libc/cb/rom.s) */

int checks, failures;

void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\r", n);
	}
}

#define BIG	5000		/* (a granule is 2304 bytes) */
#define PAT(i)	((unsigned char) ((i) * 7 + (i) / 251))

/* the FAT's used granules, and the directory's entries */
void showdisk()
{
	unsigned char sec[256];
	int s, e, g;

	__cb_dskcon(2, 0, 17, 2, sec);
	printf("fat:");
	for (g = 32; g <= 35; g++)
		printf(" %d=%02x", g, sec[g]);
	printf("\r");
	for (s = 3; s <= 11; s++) {
		__cb_dskcon(2, 0, 17, s, sec);
		for (e = 0; e < 8; e++) {
			unsigned char *p = sec + e * 32;
			if (*p == 0xff)
				return;
			printf("dir: [%.8s.%.3s] type %d ascii %02x first %d"
			       " last %d\r", *p ? (char *) p : "(deleted)",
			       *p ? (char *) p + 8 : "", p[11], p[12], p[13],
			       p[14] << 8 | p[15]);
		}
	}
}

int main()
{
	char buf[300];
	int fd, i, k, n, good;
	FILE *fp;

	errno = 0;
	ok(1, open("IN.DAT", O_RDONLY) == -1 && errno == ENOENT);

	/* 3 granules: written in pieces, appended to, read, sought in */
	fd = open("BIG.DAT", O_WRONLY | O_CREAT | O_TRUNC, 0666);
	ok(2, fd == 3);
	for (i = 0; i < BIG; i += n) {
		n = BIG - i < 300 ? BIG - i : 300;
		for (good = 0; good < n; good++)
			buf[good] = PAT(i + good);
		if (write(fd, buf, n) != n)
			break;
	}
	ok(3, i == BIG && close(fd) == 0);
	fd = open("BIG.DAT", O_WRONLY | O_APPEND);
	for (i = 0; i < 100; i++)
		buf[i] = PAT(BIG + i);
	ok(4, write(fd, buf, 100) == 100 && close(fd) == 0);
	fd = open("BIG.DAT", O_RDONLY);
	ok(5, lseek(fd, 0L, SEEK_END) == BIG + 100L &&
	   lseek(fd, 0L, SEEK_SET) == 0L);
	good = 1;
	for (i = 0; (n = read(fd, buf, 256)) > 0; i += n)
		for (k = 0; k < n; k++)
			if ((unsigned char) buf[k] != PAT(i + k))
				good = 0;
	ok(6, good && i == BIG + 100);
	ok(7, lseek(fd, 4608L, SEEK_SET) == 4608L && read(fd, buf, 2) == 2 &&
	   (unsigned char) buf[1] == PAT(4609));
	errno = 0;
	ok(8, lseek(fd, 1L, SEEK_END) == -1L && errno == EINVAL);
	errno = 0;
	ok(9, write(fd, "x", 1) == -1 && errno == EBADF);
	close(fd);

	/* the fourth granule, through stdio */
	fp = fopen("OUT.TXT", "w");
	ok(10, fp != 0);
	for (i = 1; i <= 3; i++)
		fprintf(fp, "LINE %d\r", i);
	ok(11, fclose(fp) == 0);
	fp = fopen("OUT.TXT", "r");
	ok(12, fp != 0 && fread(buf, 1, sizeof(buf), fp) == 21 &&
	   memcmp(buf, "LINE 1\rLINE 2\rLINE 3\r", 21) == 0);
	fclose(fp);
	showdisk();

	/* the disk is full */
	errno = 0;
	ok(13, open("FULL.DAT", O_WRONLY | O_CREAT, 0666) == -1 &&
	   errno == ENOSPC);
	fd = open("OUT.TXT", O_WRONLY | O_APPEND);
	for (i = 0; i < 300; i++)
		buf[i] = 'y';
	for (i = 0; i < 10; i++)	/* (the 8th fills its granule) */
		if ((n = write(fd, buf, 300)) != 300)
			break;
	ok(14, i == 7 && n == 2304 - 21 - 7 * 300);
	errno = 0;
	ok(15, write(fd, buf, 1) == -1 && errno == ENOSPC &&
	   lseek(fd, 0L, SEEK_END) == 2304L && close(fd) == 0);

	/* deleting, and EEXIST, EBUSY */
	ok(16, unlink("OUT.TXT") == 0);
	errno = 0;
	ok(17, unlink("OUT.TXT") == -1 && errno == ENOENT);
	fd = open("DEL.TXT", O_WRONLY | O_CREAT | O_EXCL, 0666);
	ok(18, fd >= 3 && write(fd, "X", 1) == 1);
	errno = 0;
	ok(19, unlink("DEL.TXT") == -1 && errno == EBUSY);
	close(fd);
	errno = 0;
	ok(20, open("DEL.TXT", O_WRONLY | O_CREAT | O_EXCL, 0666) == -1 &&
	   errno == EEXIST);
	ok(21, unlink("DEL.TXT") == 0);

	/* truncating frees the granules after the first */
	fd = open("BIG.DAT", O_RDWR | O_TRUNC);
	ok(22, fd >= 3 && write(fd, "0123456789", 10) == 10);
	ok(23, lseek(fd, 2L, SEEK_SET) == 2L && read(fd, buf, 20) == 8 &&
	   memcmp(buf, "23456789", 8) == 0);
	ok(24, close(fd) == 0);
	showdisk();

	/* names and drives */
	errno = 0;
	ok(25, open("TOOLONGNAME", O_RDONLY) == -1 && errno == ENOENT);
	errno = 0;
	ok(26, open("BIG.DAT:1", O_RDONLY) == -1 && errno == EIO);
	ok(27, open("BIG/DAT:0", O_RDONLY) >= 3);
	errno = 0;
	ok(28, read(9, buf, 1) == -1 && errno == EBADF);

	/* tmpfile(): a file for update, removed when it is closed */
	{
		FILE *t = tmpfile();

		ok(29, t != NULL && fputs("tmp", t) >= 0 &&
		   fseek(t, 0L, SEEK_SET) == 0 && fgetc(t) == 't');
		if (t)
			fclose(t);
		ok(30, open("TMP00000", O_RDONLY) == -1);
	}

	/* rename(): the entry's name; not onto a file that's there, nor to
	   another drive; an open file goes on */
	ok(31, rename("BIG.DAT", "HUGE.BIN") == 0 &&
	   open("BIG.DAT", O_RDONLY) == -1 &&
	   (fd = open("HUGE.BIN", O_RDONLY)) >= 3 && read(fd, buf, 4) == 4 &&
	   memcmp(buf, "0123", 4) == 0);
	ok(32, rename("HUGE.BIN", "BIG.DAT") == 0 && read(fd, buf, 2) == 2 &&
	   memcmp(buf, "45", 2) == 0 && close(fd) == 0);
	errno = 0;
	ok(33, rename("BIG.DAT", "BIG.DAT") == 0);
	fd = open("OTHER.TXT", O_WRONLY | O_CREAT, 0666);
	close(fd);
	errno = 0;
	ok(34, rename("BIG.DAT", "OTHER.TXT") == -1 && errno == EEXIST);
	errno = 0;
	ok(35, rename("NONE.TXT", "NEW.TXT") == -1 && errno == ENOENT);
	errno = 0;
	ok(36, rename("BIG.DAT", "BIG.DAT:1") == -1 && errno == EINVAL);
	unlink("OTHER.TXT");

	printf("checks %d failures %d\r", checks, failures);
	return failures;
}
