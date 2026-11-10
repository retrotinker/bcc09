/* soundtest.c - coco.h's sound() (bcc09 -Me), run with cbrom.s, and
   traced by sim6809 (see run.sh), which counts its writes to the DAC
   ($FF20) and times its periods from the trace's cycle counts:
   sound(200, 2) is 48 periods of 4 writes a fifteenth of a second (a
   period, 100 + 20 * 56 cycles, as BASIC's), so 96 periods, 384 writes,
   $7E, $FE, $7E, $02 in turn; sound(1, 1), 11; and sound(5, 0), none.
   The tone is left in BASIC's SNDTON ($8C), the DAC selected as the
   sound's source (bit 3 of $FF01 and $FF03 clear), and the sound off
   again (bit 3 of $FF23) */

#include <stdio.h>
#include <coco.h>

int main()
{
	poke(0xFF01, 0x3C);		/* (a source other than the DAC) */
	poke(0xFF03, 0x3C);
	poke(0xFF23, 0x34);
	sound(200, 2);
	printf("SNDTON %d, SOURCE %02X %02X, SOUND %02X\r", peek(0x8C),
	       peek(0xFF01) & 8, peek(0xFF03) & 8, peek(0xFF23) & 8);
	sound(1, 1);
	sound(5, 0);
	printf("SNDTON %d\r", peek(0x8C));
	return 0;
}
