/* declarator.c - prototyped functions with the declarators unproto must
   take apart: returning a pointer to a function (declared, then defined),
   returning a pointer to an array, and both through pointers; and & of
   an array that indexing gave (&tab[i]); it must print the same as with
   the host's compiler */

#include <stdio.h>

int tab[3][4] = { { 1, 2, 3, 4 }, { 5, 6, 7, 8 }, { 9, 10, 11, 12 } };

int twice(int n)
{
	return n * 2;
}

int thrice(int n)
{
	return n * 3;
}

/* returning a pointer to a function, declared first */
int (*pick(int which, int (*other)(int)))(int);

int (*pick(int which, int (*other)(int)))(int)
{
	return which ? other : twice;
}

/* returning a pointer to an array (a row of tab) */
int (*row(int n))[4];

int (*row(int n))[4]
{
	return &tab[n];
}

/* returning a pointer to a function that returns a pointer to a function */
int (*(*picker(int n))(int, int (*)(int)))(int)
{
	return n ? pick : 0;
}

int main()
{
	int (*f)(int);
	int (*(*pp)(int, int (*)(int)))(int);
	int (*r)[4];
	int i;

	f = pick(0, thrice);
	printf("pick %d %d\n", (*f)(10), (*pick(1, thrice))(10));
	for (i = 0; i < 3; i++) {
		r = row(i);
		printf("row %d: %d %d %d\n", i, (*r)[0], (*row(i))[3],
		       (*(&tab[i]))[1]);
	}
	pp = picker(1);
	printf("picker %d %d\n", (*(*pp)(1, twice))(7), picker(0) == 0);
	return 0;
}
