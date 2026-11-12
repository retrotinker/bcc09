/* ttime: time() on NitrOS-9 (F$Time), which sim6809 doesn't emulate:
   whatever the date, time() isn't -1, and localtime() and mktime() take
   it back to itself; prints "time ok" (see run.sh: expected-time) */

#include <stdio.h>
#include <time.h>

int main()
{
	time_t t = time(NULL);
	struct tm *tm;

	if (t == (time_t) -1) {
		printf("time failed\r");
		return 1;
	}
	tm = localtime(&t);
	if (mktime(tm) != t || tm->tm_mon < 0 || tm->tm_mon > 11 ||
	    tm->tm_mday < 1 || tm->tm_mday > 31) {
		printf("time %ld doesn't come back\r", (long) t);
		return 2;
	}
	printf("time ok\r");
	return 0;
}
