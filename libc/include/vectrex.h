/* vectrex.h - the Vectrex's BIOS routines and variables, for programs
 * built with bcc09 -Mv (a Vectrex cartridge; see bcc09(1))
 *
 * The functions are libvec.a's, which call the BIOS routines of the
 * same names.  Coordinates are -128 to 127, y before x, as the BIOS has
 * them; strings for the BIOS are in capitals and end with $80 ("\200"),
 * not 0.  A frame is drawn by calling Wait_Recal() and then drawing,
 * with the beam's position relative to the centre after Reset0Ref():
 *
 *	for (;;) {
 *		Wait_Recal();
 *		Intensity_a(0x7F);
 *		Print_Str_d(0, -40, "HELLO\200");
 *	}
 *
 * The cartridge's header, with the title the BIOS shows before it runs
 * the program, is libvec.a's ("BCC09") unless the program has one of its
 * own: an assembly file, linked with the program (bcc09 -Mv game.c
 * title.s), such as
 *
 *	loc	12
 *	export	__vec_header
 * __vec_header:
 *	fcc	"g GCE 2026"	; "g GCE", then the year shown
 *	fcb	$80
 *	fdb	$FD0D		; the music: Music1, the BIOS's
 *	fcb	$F8,$50,$20,$D0	; height, width, Y, X of the title
 *	fcc	"MY GAME"	; in capitals
 *	fcb	$80
 *	fcb	0		; (the end of the header)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __VECTREX_H
#define __VECTREX_H

/* drawing */
void Wait_Recal();		/* wait for the next frame; recalibrate */
void Intensity_a(int i);	/* the beam's brightness, 0 to $7F */
void Intensity_1F();		/* the brightness $1F (and $3F, $5F, $7F) */
void Intensity_3F();
void Intensity_5F();
void Intensity_7F();
void Reset0Ref();		/* the beam to the centre */
void Moveto_d(int y, int x);	/* move the beam, relative */
void Moveto_d_7F(int y, int x);	/* the same, at scale $7F */
void Draw_Line_d(int y, int x);	/* draw a line from the beam, relative */
void Dot_d(int y, int x);	/* a dot, relative to the beam */

/* lists: drawing a whole shape in one call is much faster than a call
   for each line.  A list's lines are y, x pairs (signed chars), each
   relative to the end of the last, at the scale in VIA_t1_cnt_lo; a
   count n given as "n + 1 lines" is the BIOS's, one less than the
   lines. */
void Draw_VLc(signed char *list);  /* n, then n + 1 lines */
void Draw_VL_a(int n, signed char *list);  /* n + 1 lines */
void Draw_VLcs(signed char *list); /* n, the scale, then n + 1 lines */
void Draw_VLp(signed char *list);  /* pattern, y, x for each line ($FF:
				      drawn, 0: moved, another negative
				      one: dashed); a pattern of 1 ends it */
void Mov_Draw_VL_a(int n, signed char *list);  /* move by the first y,
				      x, then draw n lines (n, not n + 1) */
void Draw_Pat_VL_a(int n, int pattern, signed char *list);  /* n + 1
				      lines, dashed by pattern's bits */
void Dot_List(int n, signed char *list);  /* n + 1 dots, each from the
				      last (for Vec_Dot_Dwell); then
				      the beam goes to the centre */
void Rot_VL_ab(int angle, int n, signed char *from, signed char *to);
				   /* the n + 1 points at from, rotated by
				      angle (64 a whole turn, anticlockwise),
				      to to (which may be from) */

/* text: strings for the BIOS are in capitals, ended by $80 */
void Print_Str_d(int y, int x, char *s);  /* print s at y, x */
void Print_Str_yx(char *p);	/* p is y, x, then the string */
void Print_List(char *list);	/* y, x and string after y, x and string,
				   until a y of 0 */
void Print_Ships(int ship, int n, int y, int x);  /* the n ships left (up
				   to 9), as the character ship, at y, x */

/* scores: 6 characters (the number, blanks before it) and $80, so
   Print_Str_d() prints one: char score[7] */
void Clear_Score(char *score);	/* "     0" */
void Add_Score_a(int n, char *score);	   /* add n, 0 to 99 */
void Add_Score_d(unsigned bcd, char *score);  /* add bcd: $1234 is 1234 */
void New_High_Score(char *score, char *high);  /* high = score, if higher */

/* the controllers */
unsigned Read_Btns();		/* buttons pressed since the last call */
unsigned Read_Btns_Mask(int mask);  /* the same, but a button whose bit is
				   clear in mask counts again while held */
void Joy_Digital();		/* the joysticks, into Vec_Joy_1_X...: <0,
				   0 or >0 */
void Joy_Analog();		/* the same, how far: -128 to 127 (needs
				   Vec_Misc_Count 0 before) */
void Select_Game(int players, int games);  /* the BIOS's screen for
				   choosing them: Vec_Num_Players,
				   Vec_Num_Game (from 1) */

/* sound: set Vec_Music_Flag to 1, then in each frame call
   Init_Music_chk(tune) before Wait_Recal() and Do_Sound() after it */
void Init_Music_chk(void *tune);
void Do_Sound();
void Sound_Byte(int reg, int value);	/* a register of the sound chip */
void Sound_Bytes(char *list);	/* reg, value pairs, until a reg of $FF */
void Clear_Sound();		/* quiet; silence after Do_Sound() */
void Explosion_Snd(char *parms); /* each frame, after Vec_Expl_Flag = $80
				   starts one; then Do_Sound() */

int Random();			/* 0 to 255 */

/* the BIOS's variables */
#define __VEC_U8(a)	(*(unsigned char *)(a))
#define __VEC_S8(a)	(*(signed char *)(a))
#define Vec_Btn_State	__VEC_U8(0xC80F)  /* buttons held down */
#define Vec_Buttons	__VEC_U8(0xC811)  /* pressed (as Read_Btns() gives) */
#define Vec_Joy_Resltn	__VEC_U8(0xC81A)  /* joystick resolution */
#define Vec_Joy_1_X	__VEC_S8(0xC81B)  /* joystick 1: <0, 0, >0 */
#define Vec_Joy_1_Y	__VEC_S8(0xC81C)
#define Vec_Joy_2_X	__VEC_S8(0xC81D)
#define Vec_Joy_2_Y	__VEC_S8(0xC81E)
#define Vec_Joy_Mux_1_X	__VEC_U8(0xC81F)  /* 1 to read joystick 1's X */
#define Vec_Joy_Mux_1_Y	__VEC_U8(0xC820)  /* 3 to read its Y */
#define Vec_Joy_Mux_2_X	__VEC_U8(0xC821)  /* 5 for joystick 2's X */
#define Vec_Joy_Mux_2_Y	__VEC_U8(0xC822)  /* 7 for its Y */
#define Vec_Misc_Count	__VEC_U8(0xC823)
#define Vec_Loop_Count	(*(unsigned *)0xC825)  /* frames, from Wait_Recal() */
#define Vec_Dot_Dwell	__VEC_U8(0xC828)  /* how long a dot is shown */
#define Vec_Pattern	__VEC_U8(0xC829)  /* the dashes of Draw_Pat_VL_a */
#define Vec_Text_HW	(*(unsigned *)0xC82A)  /* text height and width */
#define Vec_Music_Flag	__VEC_U8(0xC856)  /* 1: start; $80: playing; 0 */
#define Vec_Expl_Flag	__VEC_U8(0xC867)  /* $80: start an explosion */
#define Vec_Num_Players	__VEC_U8(0xC879)  /* Select_Game()'s choices */
#define Vec_Num_Game	__VEC_U8(0xC87A)
#define VIA_t1_cnt_lo	__VEC_U8(0xD004)  /* the scale of moves and lines */

/* the BIOS's tunes */
#define Music1		((void *)0xFD0D)
#define Music2		((void *)0xFD1D)
#define Music3		((void *)0xFD81)
#define Music4		((void *)0xFDD3)
#define Music5		((void *)0xFE38)
#define Music6		((void *)0xFE76)
#define Music7		((void *)0xFEC6)
#define Music8		((void *)0xFEF8)
#define Music9		((void *)0xFF26)
#define MusicA		((void *)0xFF44)
#define MusicB		((void *)0xFF62)
#define MusicC		((void *)0xFF7A)
#define MusicD		((void *)0xFF8F)

#endif
