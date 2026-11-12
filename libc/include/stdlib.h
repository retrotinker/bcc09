/* stdlib.h - for bcc09's libc
 *
 * After the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License.
 */

#ifndef __STDLIB_H
#define __STDLIB_H
#include <features.h>
#include <sys/types.h>
#include <stddef.h>

#define EXIT_SUCCESS	0
#define EXIT_FAILURE	1
#define RAND_MAX	32767
#define MB_CUR_MAX	1		/* (only the "C" locale's characters) */

typedef struct { int quot, rem; } div_t;
typedef struct { long quot, rem; } ldiv_t;

extern int atoi __P ((__const char *));
extern long atol __P ((__const char *));
extern long strtol __P ((__const char *, char **, int));
extern unsigned long strtoul __P ((__const char *, char **, int));
extern double strtod __P ((__const char *, char **));
extern double atof __P ((__const char *));

extern int abs __P ((int));
extern long labs __P ((long));

extern int rand __P ((void));
extern void srand __P ((unsigned int));

extern void qsort __P ((void *, size_t, size_t, int (*)()));
extern void * bsearch __P ((__const void *, __const void *, size_t, size_t,
			    int (*)()));

extern void * malloc __P ((size_t));
extern void * calloc __P ((size_t, size_t));
extern void * realloc __P ((void *, size_t));
extern void free __P ((void *));

extern int atexit __P ((void (*)()));
extern void exit __P ((int));
extern void _exit __P ((int));
extern void abort __P ((void));		/* raise(SIGABRT), then _exit(134) */

extern div_t div __P ((int, int));
extern ldiv_t ldiv __P ((long, long));

/* no environment and no command processor on bcc09's systems: getenv()
   gives NULL, and system(NULL) 0 (system(command) -1) */
extern char * getenv __P ((__const char *));
extern int system __P ((__const char *));

/* multibyte characters: a char each, in the "C" locale */
extern int mblen __P ((__const char *, size_t));
extern int mbtowc __P ((wchar_t *, __const char *, size_t));
extern int wctomb __P ((char *, wchar_t));
extern size_t mbstowcs __P ((wchar_t *, __const char *, size_t));
extern size_t wcstombs __P ((char *, __const wchar_t *, size_t));

/* Not in the C standard, but in dev86's library */
extern char * itoa __P ((int));
extern char * ltoa __P ((long));
extern char * ultoa __P ((unsigned long));
extern char * ltostr __P ((long, int));
extern char * ultostr __P ((unsigned long, int));

#endif
