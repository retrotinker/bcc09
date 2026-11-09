/* built by bcc09 -Mo and run as an OS-9 module by sim6809 --os9 and on
   NitrOS-9 (tests/nitros9): malloc of more than the data area F$Fork
   gave (sbrk grows it with F$Mem); mkdir, chdir, and opendir, readdir,
   rewinddir and closedir (the names are sorted, since OS-9 lists them in
   the order they were made); prints the results, and exits with the
   number of failed checks */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include <dirent.h>

int checks, failures;

void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		printf("FAIL %d\n", n);
	}
}

#define NBLOCKS	24
#define BLOCK	1000

void memory()
{
	char *p[NBLOCKS], *big;
	int i, j, good = 1;

	for (i = 0; i < NBLOCKS; i++) {
		p[i] = malloc(BLOCK);
		if (p[i] == 0)
			break;
		memset(p[i], i, BLOCK);
	}
	ok(1, i == NBLOCKS);
	for (i = 0; i < NBLOCKS && p[i]; i++)
		for (j = 0; j < BLOCK; j++)
			if (p[i][j] != i)
				good = 0;
	ok(2, good);
	for (i = 0; i < NBLOCKS && p[i]; i++)
		free(p[i]);
	big = malloc(20000);
	ok(3, big != 0);
	if (big) {
		memset(big, 0x5a, 20000);
		ok(4, big[0] == 0x5a && big[19999] == 0x5a);
		free(big);
	}
	errno = 0;
	ok(5, malloc(60000U) == 0 && errno == ENOMEM);
	printf("malloc: %d blocks of %d, and one of 20000\n", NBLOCKS, BLOCK);
}

int bystr(a, b)
char **a, **b;
{
	return strcmp(*a, *b);
}

/* the names in directory name, sorted, on one line; how many */
int list(d)
DIR *d;
{
	char *names[16];
	struct dirent *e;
	int n = 0, i;

	while ((e = readdir(d)) != 0 && n < 16) {
		ok(10, e->d_ino != 0);
		names[n++] = strdup(e->d_name);
	}
	qsort(names, n, sizeof(char *), bystr);
	for (i = 0; i < n; i++) {
		printf("%s%s", i ? " " : "", names[i]);
		free(names[i]);
	}
	printf("\n");
	return n;
}

void dirs()
{
	FILE *fp;
	DIR *d;
	int n;

	ok(11, mkdir("os9dir.tmp", 0755) == 0);
	errno = 0;
	ok(12, mkdir("os9dir.tmp", 0755) == -1 && errno == EEXIST);
	fp = fopen("os9dir.tmp/one", "w");
	ok(13, fp != 0);
	fputs("one\n", fp);
	fclose(fp);
	ok(14, chdir("os9dir.tmp") == 0);
	fp = fopen("two", "w");
	ok(15, fp != 0);
	fclose(fp);
	fp = fopen("one", "r");
	ok(16, fp != 0);
	fclose(fp);

	d = opendir(".");
	ok(17, d != 0);
	n = list(d);
	ok(18, n == 4);
	rewinddir(d);
	ok(19, list(d) == n);
	ok(20, readdir(d) == 0);
	ok(21, closedir(d) == 0);

	ok(22, chdir("..") == 0);
	fp = fopen("os9dir.tmp/two", "r");
	ok(23, fp != 0);
	fclose(fp);		/* (OS-9 won't delete an open file) */
	ok(24, unlink("os9dir.tmp/one") == 0 && unlink("os9dir.tmp/two") == 0);
	d = opendir("os9dir.tmp");
	ok(25, d != 0 && list(d) == 2);
	closedir(d);

	errno = 0;
	ok(26, opendir("nodir") == 0 && errno == ENOENT);
	errno = 0;
	ok(27, chdir("nodir") == -1 && errno == ENOENT);
}

int main()
{
	memory();
	dirs();
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
