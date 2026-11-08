/* run on sim6809: libc's string functions, which bcc09 compiled from
   dev86's C; exits with the number of failed checks.  It is plain C, so
   that it also builds on the host with its own C library (with
   tests/host/strtest-host.c for output), where it must pass too: that
   checks the expected results. */

#include <string.h>

extern int putchar();
extern void putnum();

int checks, failures;

void say(s)
char *s;
{
	while (*s)
		putchar(*s++);
}

/* a failed check prints its number */
void ok(n, cond)
int n, cond;
{
	++checks;
	if (!cond) {
		++failures;
		say("FAIL ");
		putnum(n);
	}
}

int sign(n)
int n;
{
	return n < 0 ? -1 : n > 0;
}

char buf[64], buf2[64];

void lengths()
{
	int i;

	ok(1, strlen("") == 0);
	ok(2, strlen("a") == 1);
	ok(3, strlen("hello, world") == 12);
	for (i = 0; i < 40; i++)
		buf[i] = 'x';
	buf[40] = 0;
	ok(4, strlen(buf) == 40);
}

void copies()
{
	ok(10, strcpy(buf, "abc") == buf);
	ok(11, strcmp(buf, "abc") == 0 && buf[3] == 0);
	ok(12, strcpy(buf, "") == buf && buf[0] == 0);

	strcpy(buf, "ab");
	ok(13, strcat(buf, "cd") == buf);
	ok(14, strcmp(buf, "abcd") == 0);
	strcat(buf, "");
	ok(15, strcmp(buf, "abcd") == 0);

	/* strncpy pads with zeros, and doesn't end a string it cuts */
	memset(buf, 'z', 10);
	ok(16, strncpy(buf, "ab", 5) == buf);
	ok(17, buf[0] == 'a' && buf[1] == 'b' && buf[2] == 0
	   && buf[4] == 0 && buf[5] == 'z');
	memset(buf, 'z', 10);
	strncpy(buf, "abcdef", 3);
	ok(18, buf[2] == 'c' && buf[3] == 'z');

	/* strncat appends at most n characters, and always a 0; nothing
	   past it may change (dev86 copied n bytes whatever the source) */
	memset(buf, 'z', 20);
	strcpy(buf, "ab");
	ok(19, strncat(buf, "cdef", 2) == buf);
	ok(20, strcmp(buf, "abcd") == 0 && buf[5] == 'z');
	memset(buf, 'z', 20);
	strcpy(buf, "ab");
	strncat(buf, "cd", 10);
	ok(21, strcmp(buf, "abcd") == 0 && buf[5] == 'z' && buf[12] == 'z');
}

void compares()
{
	ok(30, strcmp("abc", "abc") == 0);
	ok(31, sign(strcmp("abc", "abd")) == -1);
	ok(32, sign(strcmp("abd", "abc")) == 1);
	ok(33, sign(strcmp("ab", "abc")) == -1);
	ok(34, sign(strcmp("abc", "ab")) == 1);
	ok(35, sign(strcmp("", "a")) == -1);
	ok(36, sign(strcmp("\200", "a")) == 1);	/* as unsigned char */

	ok(37, strncmp("abcd", "abce", 3) == 0);
	ok(38, sign(strncmp("abcd", "abce", 4)) == -1);
	ok(39, strncmp("abc", "xyz", 0) == 0);
	ok(40, strncmp("ab", "ab", 10) == 0);
	ok(41, sign(strncmp("ab", "abc", 10)) == -1);

	ok(42, memcmp("abc", "abc", 3) == 0);
	ok(43, sign(memcmp("abc", "abd", 3)) == -1);	/* dev86 had */
	ok(44, sign(memcmp("abd", "abc", 3)) == 1);	/* these backwards */
	ok(45, memcmp("abc", "xyz", 0) == 0);
	ok(46, sign(memcmp("\200", "a", 1)) == 1);
	ok(47, memcmp("a\0b", "a\0b", 3) == 0);		/* past a 0 */
	ok(48, sign(memcmp("a\0b", "a\0c", 3)) == -1);
}

void searches()
{
	char *s = "hello, world";

	ok(50, strchr(s, 'o') == s + 4);
	ok(51, strchr(s, 'z') == 0);
	ok(52, strchr(s, 0) == s + 12);
	ok(53, strchr(s, 'h' + 256) == s);	/* c converts to a char */
	ok(54, strrchr(s, 'o') == s + 8);
	ok(55, strrchr(s, 'z') == 0);
	ok(56, strrchr(s, 0) == s + 12);
	ok(57, strrchr(s, 'l') == s + 10);

	ok(58, memchr(s, 'w', 12) == s + 7);
	ok(59, memchr(s, 'w', 7) == 0);
	ok(60, memchr(s, 0, 13) == s + 12);
	ok(61, memchr(s, 'h' + 256, 1) == s);
	ok(62, memchr(s, 'h', 0) == 0);

	ok(63, strstr(s, "world") == s + 7);
	ok(64, strstr(s, "") == s);
	ok(65, strstr(s, "worlds") == 0);
	ok(66, strstr(s, "lo, w") == s + 3);
	strcpy(buf, "aaab");			/* a false start */
	ok(67, strstr(buf, "aab") == buf + 1);
	ok(68, strstr(buf, "aaaa") == 0);

	ok(69, strspn("abcde", "abc") == 3);
	ok(70, strspn("abcde", "xyz") == 0);
	ok(71, strspn("", "abc") == 0);
	ok(72, strcspn("abcde", "dx") == 3);
	ok(73, strcspn("abcde", "xyz") == 5);
	ok(74, strcspn("abcde", "") == 5);
	ok(75, strpbrk(s, "w,") == s + 5);
	ok(76, strpbrk(s, "xyz") == 0);
}

void tokens()
{
	char *p, *q;

	strcpy(buf, "-abc=-def");
	p = strtok(buf, "-");
	ok(80, p == buf + 1 && strcmp(p, "abc=") == 0);
	p = strtok((char *) 0, "=-");
	ok(81, p == buf + 6 && strcmp(p, "def") == 0);
	ok(82, strtok((char *) 0, "=") == 0);
	strcpy(buf, "---");
	ok(83, strtok(buf, "-") == 0);

	strcpy(buf, "a,b,,c");
	q = buf;
	p = strsep(&q, ",");
	ok(84, p == buf && strcmp(p, "a") == 0);
	p = strsep(&q, ",");
	ok(85, strcmp(p, "b") == 0);
	p = strsep(&q, ",");
	ok(86, strcmp(p, "") == 0);
	p = strsep(&q, ",");
	ok(87, strcmp(p, "c") == 0 && q == 0);
	ok(88, strsep(&q, ",") == 0);
}

void memories()
{
	int i, good;

	ok(90, memset(buf, 'q', 10) == buf);
	good = 1;
	for (i = 0; i < 10; i++)
		if (buf[i] != 'q')
			good = 0;
	ok(91, good);
	memset(buf, 0x1ff, 3);			/* c converts to a char */
	ok(92, (buf[0] & 0xff) == 0xff && (buf[2] & 0xff) == 0xff
	   && buf[3] == 'q');
	memset(buf, 'r', 0);
	ok(93, (buf[0] & 0xff) == 0xff);

	strcpy(buf, "abcdef");
	ok(94, memcpy(buf2, buf, 7) == buf2 && strcmp(buf2, "abcdef") == 0);

	/* memmove: overlapping both ways, and not at all */
	strcpy(buf, "abcdefgh");
	ok(95, memmove(buf + 2, buf, 4) == buf + 2);
	ok(96, strcmp(buf, "ababcdgh") == 0);
	strcpy(buf, "abcdefgh");
	memmove(buf, buf + 2, 4);
	ok(97, strcmp(buf, "cdefefgh") == 0);
	strcpy(buf, "abcdefgh");
	memmove(buf2, buf, 9);
	ok(98, strcmp(buf2, "abcdefgh") == 0);
	memmove(buf, buf, 9);
	ok(99, strcmp(buf, "abcdefgh") == 0);

	/* memccpy: copies up to and including c */
	memset(buf2, 'z', 10);
	ok(100, memccpy(buf2, "abcdef", 'c', 6) == buf2 + 3);
	ok(101, buf2[2] == 'c' && buf2[3] == 'z');
	ok(102, memccpy(buf2, "abcdef", 'x', 6) == 0 && buf2[5] == 'f');
	ok(103, memccpy(buf2, "abc", 'a' + 256, 3) == buf2 + 1);
}

int main()
{
	lengths();
	copies();
	compares();
	searches();
	tokens();
	memories();
	say("checks ");
	putnum(checks);
	say("failures ");
	putnum(failures);
	return failures;
}
