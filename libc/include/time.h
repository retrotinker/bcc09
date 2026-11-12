/* time.h - for bcc09's libc.  time_t counts seconds from 1970-01-01
 * 00:00:00 (as POSIX's does) in a long, so it ends in 2038.  bcc09's
 * systems keep local time with no time zone, which is taken as UTC:
 * localtime() is gmtime(), and tm_isdst is 0.  time() reads OS-9's clock
 * (F$Time) and FLEX's date (at midnight); elsewhere there is no clock,
 * and it gives -1.  clock() gives -1 everywhere.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __TIME_H
#define __TIME_H
#include <features.h>
#include <sys/types.h>

#ifndef NULL
#define NULL ((void*)0)
#endif

typedef long clock_t;
#define CLOCKS_PER_SEC	60

struct tm
{
   int tm_sec;		/* 0 to 60 */
   int tm_min;		/* 0 to 59 */
   int tm_hour;		/* 0 to 23 */
   int tm_mday;		/* 1 to 31 */
   int tm_mon;		/* 0 to 11 */
   int tm_year;		/* since 1900 */
   int tm_wday;		/* 0 (Sunday) to 6 */
   int tm_yday;		/* 0 to 365 */
   int tm_isdst;
};

extern clock_t clock __P ((void));
extern time_t time __P ((time_t *));
extern double difftime __P ((time_t, time_t));
extern time_t mktime __P ((struct tm *));
extern struct tm *gmtime __P ((__const time_t *));
extern struct tm *localtime __P ((__const time_t *));
extern char *asctime __P ((__const struct tm *));
extern char *ctime __P ((__const time_t *));
extern size_t strftime __P ((char *, size_t, __const char *,
			     __const struct tm *));

/* bcc09's: days from 1970-01-01 to y-m-d (m 1 to 12), and back */
extern long __days __P ((long, int, int));
extern void __civil __P ((long, struct tm *));

#endif
