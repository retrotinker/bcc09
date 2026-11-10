/* coco.h - the CoCo's and the Dragon's keyboard, text screen and
 * joysticks, for Color BASIC programs (bcc09 -Me) and ROM cartridges
 * (-Mr), as BASIC has them:
 *
 *	BASIC			C
 *	K$ = INKEY$		k = inkey();	(0 if no key)
 *	CLS, CLS c		cls(-1); cls(c);
 *	PRINT@ n, ...		locate(n / 32, n % 32); printf(...);
 *	JOYSTK(n)		joystk(n)
 *	SOUND t, d		sound(t, d);
 *	PEEK(a), POKE a, v	peek(a), poke(a, v)
 *
 * cls() and locate() write out what stdio has buffered first, so that
 * it goes where the cursor was.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __COCO_H
#define __COCO_H

int inkey();			/* the key pressed, or 0 */
void cls(int c);		/* 0-8: CLS c; -1: plain CLS */
void locate(int row, int col);	/* the cursor: row 0-15, column 0-31 */
int joystk(int n);		/* 0-63; n 0-1 right x, y, 2-3 left */
void sound(int tone, int duration);  /* tone 1-255, in 1/15 seconds */

#define peek(a)		(*(unsigned char *)(a))
#define poke(a, v)	(*(unsigned char *)(a) = (v))

#endif
