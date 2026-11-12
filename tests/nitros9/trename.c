/* trename: rename() on NitrOS-9 (and under sim6809 1.3.0 or later, which
   renames as RBF does: tests/run.sh): a file renamed, the old name gone and the new
   one reading what it held; a name found without regard to case; a file
   in a directory renamed by its path, and by its new name alone; and the
   errors: the new name there (EEXIST), the old one not (ENOENT), another
   directory or a bad name (EINVAL); prints a line for each, which must
   be expected-rename (see run.sh) */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <sys/stat.h>

void make(name, text)
char *name, *text;
{
	FILE *fp = fopen(name, "w");

	if (fp) {
		fputs(text, fp);
		fclose(fp);
	}
}

/* the file's first line, or "(none)" */
char *first(name)
char *name;
{
	static char line[40];
	FILE *fp = fopen(name, "r");

	strcpy(line, "(none)");
	if (fp) {
		if (fgets(line, sizeof line, fp) == NULL)
			strcpy(line, "(empty)");
		fclose(fp);
		line[strcspn(line, "\r")] = 0;
	}
	return line;
}

void result(what, r)
char *what;
int r;
{
	printf("%s: %d errno %d\r", what, r, r ? errno : 0);
	errno = 0;
}

int main()
{
	make("ren1.txt", "one\r");
	result("rename ren1 ren2", rename("ren1.txt", "ren2.txt"));
	printf("ren1 %s, ", first("ren1.txt"));	/* (one buffer) */
	printf("ren2 %s\r", first("ren2.txt"));
	result("case", rename("REN2.TXT", "Ren4.txt"));
	printf("Ren4 %s\r", first("Ren4.txt"));
	make("ren3.txt", "three\r");
	result("onto ren3 (EEXIST 17)", rename("Ren4.txt", "ren3.txt"));
	result("none (ENOENT 2)", rename("none.txt", "x.txt"));
	result("bad name (EINVAL 22)", rename("Ren4.txt", "a b"));
	mkdir("rdir", 0755);
	make("rdir/a.txt", "in rdir\r");
	result("another directory (EINVAL 22)", rename("Ren4.txt", "rdir/b.txt"));
	result("rdir/a rdir/b", rename("rdir/a.txt", "rdir/b.txt"));
	result("rdir/b c", rename("rdir/b.txt", "c.txt"));
	printf("rdir/c %s, ", first("rdir/c.txt"));
	printf("rdir/a %s\r", first("rdir/a.txt"));
	remove("Ren4.txt");
	remove("ren3.txt");
	remove("rdir/c.txt");
	rmdir("rdir");
	printf("done\r");
	return 0;
}
