/* c89file.c - fgetpos() and fsetpos() on a file (an OS-9 module, under
   sim6809 --os9, which keeps it as a host file), perror() for a file
   that isn't there, with OS-9's end of line, tmpnam(), and tmpfile():
   its file is removed when it is closed, and at exit (run.sh checks that
   no TMPnnnnn file is left) */

#include <stdio.h>

int main()
{
	FILE *fp;
	fpos_t pos;
	char line[40];

	if ((fp = fopen("c89file.tmp", "w")) == NULL)
		return 1;
	fputs("first\rsecond\rthird\r", fp);
	fclose(fp);
	if ((fp = fopen("c89file.tmp", "r")) == NULL)
		return 2;
	fgets(line, sizeof line, fp);		/* (all of it: no '\n') */
	rewind(fp);
	getc(fp);
	getc(fp);
	if (fgetpos(fp, &pos) != 0)
		return 3;
	printf("fgetpos %ld\r", (long) pos);
	while (getc(fp) != '\r')
		;
	printf("then %c\r", getc(fp));
	if (fsetpos(fp, &pos) != 0)
		return 4;
	printf("fsetpos back: %c%c\r", getc(fp), getc(fp));
	fclose(fp);
	remove("c89file.tmp");
	if (fopen("c89file.tmp", "r") == NULL)
		perror("c89file.tmp");

	printf("tmpnam %s ", tmpnam(NULL));
	printf("%s\r", tmpnam(line));
	if ((fp = tmpfile()) == NULL)
		return 5;
	fputs("scratch\r", fp);
	rewind(fp);
	fgets(line, sizeof line, fp);
	printf("tmpfile read %s\n", line);	/* (line ends with '\r') */
	fclose(fp);
	printf("closed: TMP00002 there %d\r", fopen("TMP00002", "r") != NULL);
	if (tmpfile() == NULL)		/* (left open: exit removes it) */
		return 6;
	return 0;
}
