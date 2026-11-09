/* preprocessor: macros, conditionals, includes, # and ## */
#define NESTED 42
#include "defs.h"
#include "defs.h"	/* a second time: the guard skips it */

#define STR(x)		#x
#define XSTR(x)		STR(x)
#define CAT(a, b)	a##b
#define EMPTY
#define LIST(x)		x, x + 1, x + 2

int big = MAX(VERSION, 2);
char *name = STR(hello world);
char *ver = XSTR(VERSION);
int CAT(var, 1) = CAT(0x, ff);
int list[] = { LIST(10) };
int e = 1 EMPTY + 2;

#if VERSION >= 3 && defined(MAX)
int new_features = 1;
#elif VERSION == 2
int old_features = 1;
#else
#error unsupported
#endif

#ifdef UNDEFINED_THING
int never;
#endif

#ifndef CMDLINE
int no_cmdline;
#else
int cmdline = CMDLINE;
#endif

#undef MAX
#ifdef MAX
int still_max;
#endif

#if (1 << 4) == 16 && (0x10 | 3) == 19 && -1 < 0 && !0
int arith_ok;
#endif

/* 32-bit long and unsigned long arithmetic, precedence, and ?: */
#if 2147483647L > 65535 && -2147483647L - 1 < 0 && 4294967295UL > 0
int long_ok;
#endif
#if 1 + 2 * 3 == 7 && 10 - 2 - 3 == 5 && (0 ? 1 : 0 ? 2 : 3) == 3
int precedence_ok;
#endif
#if -1 > 0u && 0xFFFFFFFF >> 28 == 15 && -1 >> 1 == -1 && 0xFFFFFFFF + 1 == 0
int unsigned_ok;
#endif

#if 0
this text is skipped, even if it isn't C
#endif

int line = __LINE__;
char *file = __FILE__;
#line 500 "renamed.c"
int line2 = __LINE__;
