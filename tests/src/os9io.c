/* built by bcc09 -Mo and run as an OS-9 module by sim6809 --os9 (with
   the parameters "one two"): the arguments; files through open, read,
   write, lseek, close and unlink (O_CREAT, O_EXCL, O_TRUNC, O_APPEND) and
   through stdio (fopen, fprintf, fgets, fseek, ftell, remove), which
   pass every byte as it is; isatty; prints the results, and exits with
   the number of failed checks */

#include <stdio.h>
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
		printf("FAIL %d\n", n);
	}
}

#define NAME	"os9io.tmp"

void unixio()
{
	char buf[32];
	int fd, n;

	unlink(NAME);
	errno = 0;
	ok(1, open(NAME, O_RDONLY) == -1 && errno == ENOENT);
	fd = open(NAME, O_WRONLY | O_CREAT | O_EXCL, 0644);
	ok(2, fd > 2);
	ok(3, write(fd, "abc\rdef\n", 8) == 8);
	ok(4, isatty(fd) == 0);
	ok(5, close(fd) == 0);
	errno = 0;
	ok(6, close(fd) == -1 && errno == EBADF);
	errno = 0;
	ok(7, open(NAME, O_WRONLY | O_CREAT | O_EXCL, 0644) == -1 &&
	   errno == EEXIST);

	/* a CR (OS-9's end of line) ends what read() gives */
	fd = open(NAME, O_RDONLY);
	ok(8, fd > 2);
	n = read(fd, buf, sizeof(buf));
	ok(9, n == 4 && memcmp(buf, "abc\r", 4) == 0);
	ok(10, lseek(fd, 0L, SEEK_CUR) == 4L);
	ok(11, lseek(fd, 0L, SEEK_END) == 8L);
	ok(12, lseek(fd, -3L, SEEK_CUR) == 5L);
	n = read(fd, buf, sizeof(buf));
	ok(13, n == 3 && memcmp(buf, "ef\n", 3) == 0);
	ok(14, read(fd, buf, sizeof(buf)) == 0);
	close(fd);

	/* O_APPEND, then O_TRUNC */
	fd = open(NAME, O_WRONLY | O_APPEND);
	ok(15, write(fd, "gh", 2) == 2);
	close(fd);
	fd = open(NAME, O_RDONLY);
	ok(16, lseek(fd, 0L, SEEK_END) == 10L);
	close(fd);
	fd = open(NAME, O_RDWR | O_TRUNC);
	ok(17, lseek(fd, 0L, SEEK_END) == 0L);
	close(fd);
	ok(18, unlink(NAME) == 0);
	errno = 0;
	ok(19, unlink(NAME) == -1 && errno == ENOENT);
}

void stdio()
{
	char line[40];
	FILE *fp;
	int i;

	fp = fopen(NAME, "w");
	ok(20, fp != 0);
	for (i = 1; i <= 3; i++)
		fprintf(fp, "line %d of %d\n", i, 3);
	ok(21, ftell(fp) == 36L);
	ok(22, fclose(fp) == 0);

	fp = fopen(NAME, "r");
	ok(23, fp != 0);
	while (fgets(line, sizeof(line), fp))
		printf("read: %s", line);
	ok(24, feof(fp));
	ok(25, fseek(fp, 12L, SEEK_SET) == 0);
	ok(26, fgets(line, sizeof(line), fp) != 0 &&
	   strcmp(line, "line 2 of 3\n") == 0);
	ok(27, ftell(fp) == 24L);
	fclose(fp);

	fp = fopen(NAME, "a");
	fputs("appended\n", fp);
	fclose(fp);
	fp = fopen(NAME, "r");
	fseek(fp, -9L, SEEK_END);
	ok(28, fgets(line, sizeof(line), fp) != 0 &&
	   strcmp(line, "appended\n") == 0);
	fclose(fp);
	ok(29, remove(NAME) == 0);
	ok(30, fopen(NAME, "r") == 0);
}

int main(argc, argv)
int argc;
char **argv;
{
	int i;

	for (i = 0; i < argc; i++)
		printf("argv[%d] %s\n", i, argv[i]);
	ok(31, argc == 3 && argv[3] == 0);
	ok(32, isatty(0) && isatty(1) && isatty(2));
	unixio();
	stdio();
	printf("checks %d failures %d\n", checks, failures);
	return failures;
}
