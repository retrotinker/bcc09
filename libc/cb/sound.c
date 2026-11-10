/* sound.c - coco.h's sound(tone, duration): BASIC's SOUND, for Color
 * BASIC programs (bcc09 -Me) and ROM cartridges (-Mr)
 *
 * The tone is 1 (low) to 255 (high), with BASIC's pitches (89 is middle
 * C): tone.s's loop is BASIC's.  The duration is in fifteenths of a
 * second, as on the CoCo, counted in periods of the tone rather than by
 * BASIC's interrupt (cartridges run with the interrupts off): a period
 * takes 100 + 20 * (256 - tone) cycles, of 59659 in a fifteenth of a
 * second (the 6809 runs at 0.894886 MHz).  The DAC is the sound's
 * source, and the sound is on, while it plays.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <coco.h>

#define PIA0CRA	0xFF01		/* bit 3, and PIA0CRB's: the source */
#define PIA0CRB	0xFF03
#define PIA1CRB	0xFF23		/* bit 3: sound on */

extern void __cb_tone();

void
sound(tone, duration)
int tone;
int duration;
{
	unsigned n = 256 - (tone & 0xFF);	/* the delay's INCAs */
	unsigned periods = 59659U / (100 + 20 * n);

	if (duration <= 0)
		return;
	poke(PIA0CRA, peek(PIA0CRA) & ~8);	/* the DAC as the source */
	poke(PIA0CRB, peek(PIA0CRB) & ~8);
	poke(PIA1CRB, peek(PIA1CRB) | 8);	/* sound on */
	while (duration-- > 0)
		__cb_tone(tone, periods);
	poke(PIA1CRB, peek(PIA1CRB) & ~8);	/* and off */
}
