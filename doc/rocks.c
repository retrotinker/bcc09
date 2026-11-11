/* rocks.c - a small game for the Vectrex, written in C for bcc09:
 *
 *	bcc09 -Mv -O -o rocks.bin rocks.c
 *	mame vectrex -cart rocks.bin
 *
 * Rocks drift across the screen; the ship turns (joystick left and
 * right), thrusts (up) and fires (any button).  A big rock shot breaks
 * in two, a small one goes; a rock that hits the ship takes one of its
 * three lives.  Game 2 (chosen on the BIOS's screen before it starts)
 * has faster rocks.
 *
 * Positions and speeds are fixed point, 8.8: the high byte of a
 * position is the screen's coordinate, -128 to 127, so a rock leaving
 * one side comes back on the other by itself.
 */

#include <vectrex.h>

/* the cartridge's header: the title and the music the BIOS plays before
   the game (Music1, its own) */
asm("loc 12", "export __vec_header", "__vec_header:",
    "fcc \"g GCE 2026\"", "fcb $80",
    "fdb $FD0D",
    "fcb $F8,$50,$20,$E0",
    "fcc \"ROCKS\"", "fcb $80,0");

#define NROCKS	10
#define NSHOTS	4
#define BIG	2
#define SMALL	1
#define MOVE	0x7F		/* the scale of moves to a position */

/* the shapes, y, x pairs relative to the last: first a move from the
   centre, then the lines (Mov_Draw_VL_a()) */
signed char ship[] = { 10, 0, -16, -7, 4, 7, -4, 7, 16, -7 };
signed char rock[] = { 16, 0, -6, 12, -10, 4, -12, -6, -4, -10,
		       6, -12, 10, -2, 12, 4, 4, 10 };
signed char turned[sizeof ship];	/* the ship, turned to its heading */

char pop[] = { 0x19, 0x3F, 0x00, 0x02 };	/* explosions' sounds */
char crash[] = { 0x3F, 0x3F, 0x00, 0x01 };

struct thing {
	char size;		/* rocks: BIG, SMALL or 0; shots: frames */
	int y, x;		/* position (8.8) */
	int vy, vx;		/* speed (8.8, a frame) */
} rocks[NROCKS], shots[NSHOTS], me;

char angle;			/* the ship's heading: 64 to a turn */
char lives;
char safe;			/* frames before the ship can be hit */
char speed;			/* 1 or 2, the game chosen */
char wave;			/* rocks at the start of a wave, less 2 */
char score[7], high[7];
unsigned frame;			/* (frames played, for the tests) */

/* a random speed for a rock */
int drift()
{
	return (Random() - 128) * speed;
}

/* a rock of size at y, x; FALSE if there's no room for it */
int newrock(size, y, x)
int size, y, x;
{
	struct thing *r;

	for (r = rocks; r < rocks + NROCKS; ++r)
		if (!r->size) {
			r->size = size;
			r->y = y;
			r->x = x;
			r->vy = drift();
			r->vx = drift();
			return 1;
		}
	return 0;
}

/* a new wave of big rocks, from the left edge */
void newwave()
{
	int i;

	if (wave < 4)
		++wave;
	for (i = 0; i < wave + 2; ++i)
		newrock(BIG, Random() << 8, 0x8000);
}

/* move a thing by its speed */
void move(t)
struct thing *t;
{
	t->y += t->vy;
	t->x += t->vx;
}

/* are a and b within d of each other?  (a square, not a circle) */
int near(a, b, d)
struct thing *a, *b;
int d;
{
	int dy = (a->y - b->y) >> 8, dx = (a->x - b->x) >> 8;

	return dy < d && dy > -d && dx < d && dx > -d;
}

/* put the beam at a thing's position, at scale */
void at(t, scale)
struct thing *t;
int scale;
{
	Reset0Ref();
	VIA_t1_cnt_lo = MOVE;
	Moveto_d(t->y >> 8, t->x >> 8);
	VIA_t1_cnt_lo = scale;
}

/* an explosion's sound */
void boom(sound)
char *sound;
{
	Vec_Expl_Flag = 0x80;
	Explosion_Snd(sound);
}

/* the start of every frame: the score and what else there is to draw;
   sounds go on */
void startframe()
{
	Wait_Recal();
	Explosion_Snd(pop);
	Do_Sound();
	Intensity_a(0x5F);
	Print_Str_d(120, 20, score);
	if (lives)
		Print_Ships(0x68, lives, 120, -110);
	Intensity_a(0x7F);
}

/* the ship: turn, thrust, fire, move, draw */
void fly()
{
	int i;
	struct thing *s;

	if (Vec_Joy_1_X < 0)
		angle = (angle + 1) & 63;
	else if (Vec_Joy_1_X > 0)
		angle = (angle - 1) & 63;
	Rot_VL_ab(angle, 4, ship, turned);	/* turned[0], [1]: nose */
	if (Vec_Joy_1_Y > 0) {
		me.vy += turned[0] * 3;
		me.vx += turned[1] * 3;
	}
	me.vy -= me.vy >> 5;		/* (a little friction) */
	me.vx -= me.vx >> 5;
	move(&me);
	if (Read_Btns() & 0x0F)
		for (s = shots; s < shots + NSHOTS; ++s)
			if (!s->size) {
				s->size = 40;
				s->y = me.y;
				s->x = me.x;
				s->vy = me.vy + turned[0] * 64;
				s->vx = me.vx + turned[1] * 64;
				break;
			}
	if (!(safe & 4)) {	/* (blinking while it's safe) */
		at(&me, 0x20);
		Mov_Draw_VL_a(4, turned);
	}
	if (safe)
		--safe;
}

/* the shots: move, hit, draw */
void shoot()
{
	struct thing *s, *r;

	for (s = shots; s < shots + NSHOTS; ++s) {
		if (!s->size)
			continue;
		--s->size;
		move(s);
		for (r = rocks; r < rocks + NROCKS; ++r)
			if (r->size && near(s, r, r->size == BIG ? 12 : 7)) {
				s->size = 0;
				if (r->size == BIG) {
					Add_Score_a(20, score);
					r->size = SMALL;
					r->vy = drift();
					r->vx = drift();
					newrock(SMALL, r->y, r->x);
				} else {
					Add_Score_a(50, score);
					r->size = 0;
				}
				boom(pop);
				break;
			}
		if (s->size) {
			Reset0Ref();
			VIA_t1_cnt_lo = MOVE;
			Dot_d(s->y >> 8, s->x >> 8);
		}
	}
}

/* the rocks: move, hit the ship, draw; FALSE when there are none */
int tumble()
{
	struct thing *r;
	int left = 0;

	for (r = rocks; r < rocks + NROCKS; ++r) {
		if (!r->size)
			continue;
		++left;
		move(r);
		if (!safe && lives && near(&me, r, r->size == BIG ? 14 : 9)) {
			--lives;
			safe = 100;
			me.y = me.x = me.vy = me.vx = 0;
			boom(crash);
		}
		at(r, r->size == BIG ? 0x30 : 0x18);
		Mov_Draw_VL_a(8, rock);
	}
	return left;
}

/* a game, until the last life is lost */
void play()
{
	struct thing *r;

	for (r = rocks; r < rocks + NROCKS; ++r)
		r->size = 0;
	me.y = me.x = me.vy = me.vx = 0;
	angle = 0;
	lives = 3;
	safe = 100;
	wave = 0;
	Clear_Score(score);
	while (lives) {
		startframe();
		Joy_Digital();
		fly();
		shoot();
		if (!tumble())
			newwave();
		++frame;
	}
}

/* the end of a game, until a button is pressed (after a second) */
void gameover()
{
	int wait = 50;

	New_High_Score(score, high);
	for (;;) {
		startframe();
		Print_Str_d(20, -70, "GAME OVER\200");
		Print_Str_d(-20, -70, "HIGH\200");
		Print_Str_d(-20, 0, high);
		if ((Read_Btns() & 0x0F) && !wait)
			break;
		if (wait)
			--wait;
	}
}

int main()
{
	Vec_Joy_Mux_1_X = 1;	/* read joystick 1 */
	Vec_Joy_Mux_1_Y = 3;
	Vec_Joy_Mux_2_X = 0;
	Vec_Joy_Mux_2_Y = 0;
	Select_Game(1, 2);	/* 1 player; game 1 or 2 */
	speed = Vec_Num_Game;
	Clear_Score(high);
	for (;;) {
		play();
		gameover();
	}
}
