/* worm.c - a small game for the Color Computer and the Dragon, written
 * in C for bcc09 (a Color BASIC program):
 *
 *	bcc09 -Me -O -o worm -X-T0x3000 worm.c
 *	objcopy09 -O cas -n WORM worm worm.cas
 *	xroar -load-tape worm.cas		(then CLOADM:EXEC)
 *
 * The worm crawls across the screen; the arrow keys turn it.  Each
 * piece of food it eats makes it longer and faster; it mustn't touch
 * the wall or itself.  BREAK ends a game, and then the program.
 *
 * The screen is the board, as in a BASIC game: the worm, the wall and
 * the food are blocks of colour POKEd into the text screen's memory,
 * and the worm finds out what is ahead of it with PEEK.  The score is
 * printed, with PRINT@'s locate().
 *
 * Copyright (c) 2026 John W. Linville
 *
 * Permission to use, copy, modify, and/or distribute this software for
 * any purpose with or without fee is hereby granted, provided that the
 * above copyright notice and this permission notice appear in all
 * copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
 * WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
 * AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
 * DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
 * PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
 * TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <coco.h>

#define SCREEN	0x400		/* the text screen: 16 rows of 32 */
#define WIDTH	32

/* blocks of colour, as CHR$(128 + 16 * colour + 15) */
#define BLOCK(c)	(0x8F + 16 * (c))
#define EMPTY	0x80		/* black */
#define WALL	BLOCK(2)	/* blue */
#define BODY	BLOCK(1)	/* yellow */
#define HEAD	BLOCK(7)	/* orange */
#define FOOD	BLOCK(3)	/* red */

/* the keys */
#define UP	94
#define DOWN	10
#define LEFT	8
#define RIGHT	9
#define ENTER	13
#define BREAK	3

/* the worm: the screen positions of its pieces, from the tail to the
   head, in a ring (an unsigned char counts 0 to 255, then 0 again) */
unsigned worm[256];
unsigned char head, tail;
int step;			/* added to the head's position each move */
int grow;			/* pieces still to add */
int score, best;
int delay;			/* the pause between moves: loops */

/* the screen at position p (row * 32 + column) */
#define AT(p)	peek(SCREEN + (p))
#define PUT(p, c)	poke(SCREEN + (p), (c))

/* the score, on the top line */
void showscore()
{
	locate(0, 0);
	printf("SCORE %-5d BEST %d", score, best);
	fflush(stdout);
}

/* food, somewhere empty */
void food()
{
	unsigned p;

	do
		p = WIDTH + rand() % (15 * WIDTH);
	while (AT(p) != EMPTY);
	PUT(p, FOOD);
}

/* the board: a wall around rows 1 to 15, the worm in the middle */
void board()
{
	int i;

	cls(0);
	for (i = 0; i < WIDTH; ++i) {
		PUT(WIDTH + i, WALL);
		PUT(15 * WIDTH + i, WALL);
	}
	for (i = 2; i < 15; ++i) {
		PUT(i * WIDTH, WALL);
		PUT(i * WIDTH + WIDTH - 1, WALL);
	}
	tail = 0;
	head = 2;
	for (i = 0; i < 3; ++i) {
		worm[i] = 8 * WIDTH + 14 + i;
		PUT(worm[i], BODY);
	}
	PUT(worm[head], HEAD);
	step = 1;
	grow = 0;
	score = 0;
	delay = 3500;		/* about 8 moves a second (32 cycles each) */
	showscore();
	food();
}

/* a game, until the worm hits something or BREAK is pressed */
void play()
{
	int i, key;
	unsigned p;

	board();
	for (;;) {
		for (i = 0; i < delay; ++i)
			;
		key = inkey();		/* one key a move, as INKEY$ */
		if (key == BREAK)
			return;
		if (key == UP && step != WIDTH)
			step = -WIDTH;
		else if (key == DOWN && step != -WIDTH)
			step = WIDTH;
		else if (key == LEFT && step != 1)
			step = -1;
		else if (key == RIGHT && step != -1)
			step = 1;
		p = worm[head] + step;
		if (AT(p) == FOOD) {
			score += 10;
			grow += 3;
			if (delay > 1100)
				delay -= 150;
			sound(200, 1);
			food();
			showscore();
		} else if (AT(p) != EMPTY) {
			sound(20, 6);	/* the wall, or itself */
			return;
		}
		PUT(worm[head], BODY);
		worm[++head] = p;
		PUT(p, HEAD);
		if (grow)
			--grow;
		else
			PUT(worm[tail++], EMPTY);
	}
}

int main()
{
	unsigned wait = 0;
	int key;

	cls(-1);
	locate(4, 14);
	printf("WORM");
	locate(7, 4);
	printf("ARROW KEYS TO TURN, BREAK");
	locate(8, 4);
	printf("TO STOP.  PRESS A KEY.");
	while (inkey() == 0)
		++wait;
	srand(wait);		/* each game different */
	for (;;) {
		play();
		if (score > best)
			best = score;
		showscore();
		locate(7, 7);
		printf(" GAME OVER: ENTER ");
		locate(8, 7);
		printf(" TO PLAY, BREAK TO ");
		locate(9, 7);
		printf(" STOP              ");
		fflush(stdout);
		while ((key = inkey()) != ENTER && key != BREAK)
			;
		if (key == BREAK)
			break;
	}
	cls(-1);
	printf("BEST SCORE %d\r", best);
	return 0;
}
