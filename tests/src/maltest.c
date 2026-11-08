/* run on sim6809: libc's malloc, calloc, realloc, free and strdup, and
   sbrk and brk; exits with the number of failed checks.  It is plain C,
   so that it also builds on the host with its own C library (with
   tests/host/putnum.c for output), where it must print the same.  The
   checks of sbrk, brk, running out of memory and 16-bit sizes only run on
   sim6809. */

#include <stdlib.h>
#include <string.h>
#include <errno.h>
#ifdef __BCC__
#include <unistd.h>
#endif

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

/* each block is filled with bytes that depend on its slot and size */
#define BYTE(slot, size, i)	((char) ((slot) * 7 + (size) + (i)))

void fill(p, slot, size)
char *p;
int slot, size;
{
	int i;

	for (i = 0; i < size; i++)
		p[i] = BYTE(slot, size, i);
}

/* the first n bytes of a block filled for slot and size */
int intact(p, slot, size, n)
char *p;
int slot, size, n;
{
	int i;

	for (i = 0; i < n; i++)
		if (p[i] != BYTE(slot, size, i))
			return 0;
	return 1;
}

void basics()
{
	char *p, *q;
	int i, zero;

	p = malloc(10);
	ok(1, p != 0);
	fill(p, 1, 10);
	q = malloc(20);
	ok(2, q != 0 && (q >= p + 10 || q + 20 <= p));	/* no overlap */
	fill(q, 2, 20);
	ok(3, intact(p, 1, 10, 10) && intact(q, 2, 20, 20));
	free(p);
	free(q);
	free((char *) 0);			/* does nothing */

	p = calloc(20, 3);
	zero = p != 0;
	for (i = 0; zero && i < 60; i++)
		if (p[i] != 0)
			zero = 0;
	ok(4, zero);
	free(p);

	/* realloc keeps the contents, growing and shrinking */
	p = realloc((char *) 0, 16);		/* like malloc */
	ok(5, p != 0);
	fill(p, 3, 16);
	p = realloc(p, 200);
	ok(6, p != 0 && intact(p, 3, 16, 16));
	q = malloc(5);				/* so p can't just grow */
	p = realloc(p, 1000);
	ok(7, p != 0 && intact(p, 3, 16, 16));
	p = realloc(p, 8);
	ok(8, p != 0 && intact(p, 3, 16, 8));
	free(p);
	free(q);

	p = strdup("hello, world");
	ok(9, p != 0 && strcmp(p, "hello, world") == 0);
	q = strdup("");
	ok(10, q != 0 && q[0] == 0 && q != p);
	free(p);
	free(q);
}

/* random allocations and frees, with sizes from 1 to 300, in 40 slots;
   every block's contents are checked before it goes, and every so often
   all the blocks are checked for overlaps */
#define SLOTS 40

char *slot[SLOTS];
int size[SLOTS];
unsigned long seed = 12345;

int rnd(n)
int n;
{
	seed = seed * 1103515245L + 12345;
	return (int) ((seed >> 16) & 0x7fff) % n;
}

int overlaps()
{
	int i, j;

	for (i = 0; i < SLOTS; i++)
		for (j = i + 1; j < SLOTS; j++)
			if (slot[i] && slot[j]
			    && slot[i] < slot[j] + size[j]
			    && slot[j] < slot[i] + size[i])
				return 1;
	return 0;
}

void stress()
{
	int n, s, good, nomem, sz;
	char *p;

	good = 1;
	nomem = 0;
	for (n = 0; n < 3000; n++) {
		s = rnd(SLOTS);
		if (slot[s]) {
			if (!intact(slot[s], s, size[s], size[s]))
				good = 0;
			if (rnd(4) == 0) {	/* resize it */
				sz = 1 + rnd(300);
				p = realloc(slot[s], sz);
				if (p == 0) {
					nomem++;
					continue;
				}
				if (!intact(p, s, size[s],
					    sz < size[s] ? sz : size[s]))
					good = 0;
				slot[s] = p;
				size[s] = sz;
				fill(p, s, sz);
			} else {
				free(slot[s]);
				slot[s] = 0;
			}
		} else {
			sz = 1 + rnd(300);
			p = malloc(sz);
			if (p == 0) {
				nomem++;
				continue;
			}
			slot[s] = p;
			size[s] = sz;
			fill(p, s, sz);
		}
		if (n % 100 == 0 && overlaps())
			good = 0;
	}
	ok(20, good);
	ok(21, !overlaps());
	ok(22, nomem == 0);
	for (s = 0; s < SLOTS; s++)
		if (slot[s]) {
			if (!intact(slot[s], s, size[s], size[s]))
				good = 0;
			free(slot[s]);
			slot[s] = 0;
		}
	ok(23, good);
}

#ifdef __BCC__
extern char _end[];		/* (the linker's __end) */

/* filling the heap: it stops short of the stack, and all of it can be
   used again after it is freed */
void exhaust()
{
	char *list = 0, *p, *top;
	char here;
	unsigned total = 0, blocks = 0;

	errno = 0;
	while ((p = malloc(100)) != 0) {
		*(char **) p = list;
		list = p;
		total += 100;
		blocks++;
	}
	ok(30, errno == ENOMEM);
	ok(31, total > 10000);		/* most of the memory */
	top = sbrk(0);
	ok(32, top <= &here - __heap_margin && top > _end);
	ok(33, malloc(100) == 0);	/* still full */
	while (list) {
		p = *(char **) list;
		free(list);
		list = p;
	}
	p = malloc(total - 400);	/* in one block, after all that */
	ok(34, p != 0);
	free(p);
	p = malloc(total / 2);
	ok(35, p != 0);
	free(p);
}

void heap()
{
	char *start, *p;
	unsigned margin;

	start = sbrk(0);
	ok(40, start >= _end);
	ok(41, sbrk(10) == start && sbrk(0) == start + 10);
	ok(42, sbrk(-10) == start + 10 && sbrk(0) == start);
	errno = 0;
	ok(43, sbrk(30000) == (char *) -1 && errno == ENOMEM);	/* too far */
	ok(44, sbrk(0) == start);
	errno = 0;
	ok(45, sbrk(-30000) == (char *) -1 && errno == ENOMEM);	/* too low */
	ok(46, brk(_end - 1) == -1 && sbrk(0) == start);
	ok(47, brk(start + 50) == 0 && sbrk(0) == start + 50);
	ok(48, brk(start) == 0);

	/* with a margin bigger than the free space, nothing fits */
	margin = __heap_margin;
	__heap_margin = 0x7000;
	ok(49, malloc(1000) == 0);
	__heap_margin = margin;
	p = malloc(1000);
	ok(50, p != 0);
	free(p);

	/* calloc's size must fit in 16 bits */
	errno = 0;
	ok(51, calloc(300, 300) == 0 && errno == ENOMEM);
}
#endif

int main()
{
	basics();
	stress();
#ifdef __BCC__
	exhaust();
	heap();
#endif
	say("checks ");
	putnum(checks);
	say("failures ");
	putnum(failures);
	return failures;
}
