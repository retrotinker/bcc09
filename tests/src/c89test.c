/* c89test.c - the C89 library functions bcc09's libc added last: div,
   ldiv, strerror, perror, strcoll, strxfrm, setjmp and longjmp,
   float.h's limits, signal and raise, setlocale and localeconv, the
   multibyte functions, getenv; it must print the same as with the
   host's compiler and C library (what differs by design, such as
   system(), is under __BCC__) */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <setjmp.h>
#include <signal.h>
#include <locale.h>
#include <float.h>
#include <limits.h>

jmp_buf env;
int depth;

void dive(n)
int n;
{
	char pad[20];			/* (a frame that longjmp leaves) */

	pad[0] = n;
	depth = n;
	if (n == 5)
		longjmp(env, n * 10);
	dive(n + 1);
	printf("not reached %d\n", pad[0]);
}

int caught;

void handler(sig)
int sig;
{
	caught += sig;
	signal(sig, handler);		/* (C may reset it to SIG_DFL) */
}

int main()
{
	static int divs[][2] = { { 7, 2 }, { -7, 2 }, { 7, -2 }, { -7, -2 },
				 { 0, 5 }, { 32767, 3 }, { -32767, 10 } };
	static long ldivs[][2] = { { 1000000L, 7 }, { -1000000L, 7 },
				   { 123456789L, -1000 },
				   { -2147483647L, 65536L } };
	static int errs[] = { 0, ENOENT, EINTR, EIO, EBADF, ENOMEM, EACCES,
			      EBUSY, EEXIST, ENODEV, EINVAL, EMFILE, ENOTTY,
			      ENOSPC, ESPIPE, EDOM, ERANGE, ENOTEMPTY, 200,
			      -1 };
	char buf[20], c;
	wchar_t wc, ws[8];
	struct lconv *lc;
	volatile int v;
	int i, r;
	div_t d;
	ldiv_t ld;

	for (i = 0; i < sizeof divs / sizeof divs[0]; i++) {
		d = div(divs[i][0], divs[i][1]);
		printf("div(%d, %d) = %d %d\n", divs[i][0], divs[i][1], d.quot,
		       d.rem);
	}
	for (i = 0; i < sizeof ldivs / sizeof ldivs[0]; i++) {
		ld = ldiv(ldivs[i][0], ldivs[i][1]);
		printf("ldiv(%ld, %ld) = %ld %ld\n", ldivs[i][0], ldivs[i][1],
		       ld.quot, ld.rem);
	}

	for (i = 0; i < sizeof errs / sizeof errs[0]; i++)
		printf("strerror(%d) = %s\n", errs[i], strerror(errs[i]));
	fflush(stdout);
	errno = ENOENT;
	perror("perror");
	errno = EDOM;
	perror("");
	errno = 0;
	perror(NULL);

	printf("strcoll %d %d %d\n", strcoll("abc", "abd") < 0,
	       strcoll("b", "a") > 0, strcoll("same", "same"));
	r = strxfrm(buf, "transform", sizeof buf);
	printf("strxfrm %d %s", r, buf);
	r = strxfrm(buf, "toolongtoolongtoolong", 4);	/* (buf undefined) */
	printf(" %d\n", r);

	v = 0;
	r = setjmp(env);
	printf("setjmp %d v %d\n", r, v);
	if (r == 0) {
		v = 1;
		longjmp(env, 0);	/* (0: setjmp gives 1) */
	}
	if (r == 1) {
		r = setjmp(env);
		if (r == 0)
			dive(1);
		printf("from depth %d: %d\n", depth, r);
	}

	printf("FLT_RADIX %d FLT_ROUNDS %d\n", FLT_RADIX, FLT_ROUNDS);
	printf("FLT %d %d %d %d %d %d\n", FLT_MANT_DIG, FLT_DIG, FLT_MIN_EXP,
	       FLT_MIN_10_EXP, FLT_MAX_EXP, FLT_MAX_10_EXP);
	printf("FLT %a %a %a\n", (double) FLT_MAX, (double) FLT_EPSILON,
	       (double) FLT_MIN);
	printf("DBL %d %d %d %d %d %d\n", DBL_MANT_DIG, DBL_DIG, DBL_MIN_EXP,
	       DBL_MIN_10_EXP, DBL_MAX_EXP, DBL_MAX_10_EXP);
	printf("DBL %a %a %a\n", DBL_MAX, DBL_EPSILON, DBL_MIN);
	printf("DBL_EPSILON %d\n", 1.0 + DBL_EPSILON > 1.0 &&
	       1.0 + DBL_EPSILON / 2 == 1.0);

	printf("signal %d\n", signal(SIGINT, handler) == SIG_DFL);
	r = raise(SIGINT);
	printf("raise %d caught %d\n", r, caught);
	raise(SIGINT);
	printf("again caught %d\n", caught);
	printf("ignore %d\n", signal(SIGTERM, SIG_IGN) == SIG_DFL);
	printf("raise %d caught %d\n", raise(SIGTERM), caught);
	printf("signal(0) %d\n", signal(0, handler) == SIG_ERR);

	printf("setlocale %s %s %d\n", setlocale(LC_ALL, "C"),
	       setlocale(LC_NUMERIC, NULL), setlocale(LC_ALL, "xx_YY") == NULL);
	lc = localeconv();
	printf("localeconv [%s] [%s] [%s] %d %d\n", lc->decimal_point,
	       lc->thousands_sep, lc->currency_symbol,
	       lc->frac_digits == CHAR_MAX, lc->n_sign_posn == CHAR_MAX);

	printf("MB_CUR_MAX %d\n", (int) MB_CUR_MAX);
	printf("mblen %d %d %d %d\n", mblen("a", 1), mblen("", 1),
	       mblen("a", 0), mblen(NULL, 0));
	r = mbtowc(&wc, "Q", 1);
	printf("mbtowc %d %c %d\n", r, (char) wc, mbtowc(NULL, NULL, 0));
	r = wctomb(&c, 'Z');
	printf("wctomb %d %c %d\n", r, c, wctomb(NULL, 0));
	r = mbstowcs(ws, "wide", 8);
	r += wcstombs(buf, ws, sizeof buf);
	printf("mbstowcs, wcstombs %d %s\n", r, buf);

	printf("getenv %d\n", getenv("BCC09_NOT_SET") == NULL);
#ifdef __BCC__
	/* differ on a host: a shell to call; wchar_t's size; MB_LEN_MAX */
	printf("checks system %d %d sizeof(wchar_t) %d MB_LEN_MAX %d\n",
	       system(NULL), system("dir"), (int) sizeof(wchar_t), MB_LEN_MAX);
#endif
	return 0;
}
