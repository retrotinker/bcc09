/* run on Color BASIC and Dragon ROMs in XRoar (see run.sh): built by
   bcc09 -Me, loaded from a cassette and run with EXEC; coco.h's cls(),
   locate() (text printed where it puts the cursor, without a '\r'),
   inkey() (a key XRoar types), joystk() (each in 0-63) and sound()
   (middle C, for 2/15 seconds: it must come back, with the sound off);
   returns 42.  Its variables are __direct, so DP is their page but in
   the calls into the ROM, which want 0 */

#include <stdio.h>
#include <coco.h>

__direct int k, i, ok;

int main()
{
	ok = 1;
	cls(-1);
	locate(0, 0);
	printf("COCO.H");
	locate(2, 10);
	printf("ROW 2 COL 10");
	locate(5, 0);
	printf("PRESS A KEY");
	while ((k = inkey()) == 0)
		;
	locate(6, 4);
	printf("KEY %c", k);
	for (i = 0; i < 4; ++i)
		if (joystk(i) > 63)
			ok = 0;
	locate(8, 0);
	printf("JOYSTK %s", ok ? "OK" : "WRONG");
	sound(89, 2);
	locate(10, 0);
	printf("SOUND %s", (peek(0xFF23) & 8) ? "STILL ON" : "PLAYED");
	locate(14, 20);
	printf("BYE");
	return 42;
}
