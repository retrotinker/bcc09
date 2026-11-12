/* timetest.c - time.h's functions: gmtime(), localtime() and asctime()
   over time_t's range (before 1970 too, leap days, the ends), mktime()
   with fields out of range (which it normalizes) and past time_t's
   range, strftime()'s conversions, difftime(); it must print the same
   as with the host's compiler and C library, with TZ=UTC (time() and
   clock(), which differ, are under __BCC__) */

#include <stdio.h>
#include <string.h>
#include <time.h>

void show(t)
time_t t;
{
	struct tm *tm = gmtime(&t);

	printf("%11ld %d-%d-%d %d:%d:%d wday %d yday %d | %s", (long) t,
	       tm->tm_year, tm->tm_mon, tm->tm_mday, tm->tm_hour, tm->tm_min,
	       tm->tm_sec, tm->tm_wday, tm->tm_yday, asctime(tm));
}

void norm(y, mo, d, h, mi, s)
int y, mo, d, h, mi, s;
{
	struct tm tm;
	time_t t;

	memset(&tm, 0, sizeof tm);
	tm.tm_year = y;
	tm.tm_mon = mo;
	tm.tm_mday = d;
	tm.tm_hour = h;
	tm.tm_min = mi;
	tm.tm_sec = s;
	t = mktime(&tm);
	printf("mktime(%d %d %d %d:%d:%d) = %ld", y, mo, d, h, mi, s, (long) t);
	if (t != (time_t) -1)
		printf(" -> %d-%d-%d %d:%d:%d wday %d yday %d", tm.tm_year,
		       tm.tm_mon, tm.tm_mday, tm.tm_hour, tm.tm_min, tm.tm_sec,
		       tm.tm_wday, tm.tm_yday);
	printf("\n");
}

int main()
{
	static long times[] = { 0L, 1L, -1L, 86399L, 86400L, -86400L,
				-86401L, 68169600L, 951782400L, 951868799L,
				978307199L, 1000000000L, 1234567890L,
				1700000000L, 2147483647L, -2147483647L - 1,
				-1000000000L, -631152000L, 1584000000L };
	static char *fmts[] = { "%a %A %b %B %h", "%d %e %H %I %j %m %M %p %S",
				"%U %w %W %u", "%y %Y %C", "[%c]", "[%x] [%X]",
				"%D %F %R %T", "%% %n%t.", "plain" };
	static long ftimes[] = { 0L, 951868799L, 1700000000L, -631152000L,
				 1072915200L, 1104451200L, 1230681600L };
	char buf[80];
	struct tm *tm;
	time_t t;
	int i, j;

	for (i = 0; i < sizeof times / sizeof times[0]; i++)
		show((time_t) times[i]);
	t = 1234567890L;
	tm = localtime(&t);
	printf("localtime %d:%d isdst %d, ctime %s", tm->tm_hour, tm->tm_min,
	       tm->tm_isdst, ctime(&t));

	norm(70, 0, 1, 0, 0, 0);
	norm(100, 1, 29, 12, 0, 0);
	norm(100, 12, 1, 0, 0, 0);		/* month 12: next January */
	norm(100, -1, 1, 0, 0, 0);		/* month -1: last December */
	norm(124, 0, 0, 0, 0, 0);		/* day 0: the last of before */
	norm(124, 1, 30, 0, 0, 0);		/* Feb 30, 2024: March 1 */
	norm(99, 11, 31, 23, 59, 60);		/* a second past the year */
	norm(110, 5, 15, -1, -1, -1);
	norm(110, 5, 15, 48, 120, 7200);
	norm(1, 11, 13, 20, 45, 52);		/* the first time_t */
	norm(138, 0, 19, 3, 14, 7);		/* the last */

	for (i = 0; i < sizeof ftimes / sizeof ftimes[0]; i++) {
		t = ftimes[i];
		tm = gmtime(&t);
		for (j = 0; j < sizeof fmts / sizeof fmts[0]; j++) {
			strftime(buf, sizeof buf, fmts[j], tm);
			printf("%s|", buf);
		}
		printf("\n");
	}
	t = 0;
	printf("strftime fits %d, too small %d\n",
	       (int) strftime(buf, 9, "%H:%M:%S", gmtime(&t)),
	       (int) strftime(buf, 8, "%H:%M:%S", gmtime(&t)));

	printf("difftime %g %g\n", difftime((time_t) 100, (time_t) 40),
	       difftime((time_t) -2147483647L - 1, (time_t) 2147483647L));
#ifdef __BCC__
	/* differ on a host with a 64-bit time_t: past ours, mktime() fails */
	{
		struct tm a, b, c;

		memset(&a, 0, sizeof a);
		a.tm_year = 138, a.tm_mday = 19, a.tm_hour = 3, a.tm_min = 14;
		a.tm_sec = 8;			/* past 2038-01-19 03:14:07 */
		b = a;
		b.tm_year = 1, b.tm_mon = 11, b.tm_mday = 13, b.tm_hour = 20;
		b.tm_min = 45, b.tm_sec = 51;	/* before 1901-12-13 20:45:52 */
		c = a;
		c.tm_year = 300;
		printf("checks mktime past the range %ld %ld %ld\n",
		       (long) mktime(&a), (long) mktime(&b), (long) mktime(&c));
	}
	printf("checks time %ld clock %ld\n", (long) time(NULL), (long) clock());
#endif
	return 0;
}
