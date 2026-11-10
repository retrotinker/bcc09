/* cocotest.c - coco.h's functions (bcc09 -Me), run with cbrom.s for the
   ROM (see run.sh): cls() fills the screen with its character and puts
   the cursor (CURPOS, $0088) at the top left, after writing out what
   stdio has buffered; locate() sets CURPOS; joystk() reads JOYIN's
   values; inkey() gives a key (cbrom.s's POLCAT gives none every other
   time); peek() and poke() */

#include <stdio.h>
#include <unistd.h>
#include <coco.h>

#define CURPOS	(*(unsigned *)0x88)

int filled(c)
int c;
{
	int i;

	for (i = 0; i < 512; ++i)
		if (peek(0x400 + i) != c)
			return 0;
	return CURPOS == 0x400;
}

int main()
{
	int k;

	printf("BUFFERED,");		/* cls() writes it out first */
	cls(3);
	write(1, " THEN WRITE\r", 12);
	printf("CLS 3: %d\r", filled(0xAF));
	cls(0);
	printf("CLS 0: %d\r", filled(0x80));
	cls(8);
	printf("CLS 8: %d\r", filled(0xFF));
	cls(-1);
	printf("CLS: %d\r", filled(0x60));
	cls(9);
	printf("CLS 9: %d\r", filled(0x60));
	locate(5, 10);
	printf("LOCATE 5, 10: %04X\r", CURPOS);
	locate(15, 31);
	printf("LOCATE 15, 31: %04X\r", CURPOS);
	printf("JOYSTK %d %d %d %d\r", joystk(0), joystk(1), joystk(2),
	       joystk(3));
	while ((k = inkey()) == 0)
		;
	printf("INKEY %c", k);
	k = inkey();			/* (none, this time) */
	printf(" THEN %d\r", k);
	poke(0x0E00, 0x5A);
	printf("PEEK %02X\r", peek(0x0E00));
	return 0;
}
