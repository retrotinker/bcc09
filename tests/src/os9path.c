/* os9path.c - rmdir() and getcwd() for OS-9 (bcc09 -Mo), which has no
   calls for them (see libc/os9/sys.c), run as a module under sim6809
   --os9 (whose directory it starts in is its device's root, H0) and on
   NitrOS-9 (where it starts in /d1, the root of D1): getcwd() at the
   root, two directories down and back, with too small a buffer, and
   with one from malloc; rmdir() of directories that aren't empty, of a
   file, of empty ones, and of one that's gone.  The paths are printed
   without the device's name, which is all that differs.  (Its lines end
   with '\n', as os9dir.c's do: sim6809's terminal writes a CR as one,
   and NitrOS-9 keeps what's written to a file.) */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>

char buf[128];

/* getcwd()'s path, without "/" and the device's name first */
void cwd(what)
char *what;
{
	char *p;

	if (getcwd(buf, sizeof buf) == 0) {
		printf("%s: getcwd failed, errno %d\n", what, errno);
		return;
	}
	p = strchr(buf + 1, '/');
	printf("%s: [%s]%s\n", what, p ? p : "",
	       buf[0] == '/' ? "" : " (no / first)");
}

void rmd(name)
char *name;
{
	errno = 0;
	if (rmdir(name) == 0)
		printf("rmdir %s: ok\n", name);
	else
		printf("rmdir %s: -1, errno %d\n", name, errno);
}

int main()
{
	char *m;
	int fd;

	cwd("at the start");
	mkdir("QA", 0777);
	mkdir("QA/QB", 0777);
	chdir("QA/QB");
	cwd("in QA/QB");
	errno = 0;
	m = getcwd(buf, 4);		/* (before printf reads errno) */
	printf("getcwd(buf, 4): %s, errno %d (ERANGE %d)\n",
	       m ? "a path" : "0", errno, ERANGE);
	if ((m = getcwd((char *)0, 0)) != 0) {
		printf("getcwd(0, 0): %s\n", strchr(m + 1, '/'));
		free(m);
	}
	chdir("../..");
	cwd("back up");

	rmd("QA");			/* QB is in it */
	fd = open("QA/QB/QF", O_WRONLY | O_CREAT | O_TRUNC, 0666);
	write(fd, "x", 1);
	close(fd);
	rmd("QA/QB");			/* QF is in it */
	unlink("QA/QB/QF");
	rmd("QA/QB");
	rmd("QA");
	rmd("QA");			/* gone */
	fd = open("QF", O_WRONLY | O_CREAT | O_TRUNC, 0666);
	close(fd);
	rmd("QF");			/* a file */
	unlink("QF");
	printf("ENOTEMPTY %d, ENOENT %d\n", ENOTEMPTY, ENOENT);
	return 0;
}
