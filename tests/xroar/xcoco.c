/* run on Color BASIC and Dragon ROMs in XRoar (see run.sh): built by
   bcc09 -Me, loaded from a cassette and run with EXEC; coco.h's cls(),
   locate() (text printed where it puts the cursor, without a '\r'),
   inkey() (a key XRoar types) and joystk() (each in 0-63); returns 42 */

#include <stdio.h>
#include <coco.h>

int main()
{
	int k, i, ok = 1;

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
	locate(14, 20);
	printf("BYE");
	return 42;
}
