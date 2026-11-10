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
void Reset0Ref();		/* the beam to the centre */
void Moveto_d(int y, int x);	/* move the beam, relative */
void Draw_Line_d(int y, int x);	/* draw a line from the beam, relative */
void Dot_d(int y, int x);	/* a dot, relative to the beam */
void Print_Str_d(int y, int x, char *s);  /* print s at y, x */
void Draw_VLc(signed char *list);  /* count - 1, then y, x for each line */

/* the controllers */
unsigned Read_Btns();		/* buttons pressed since the last call */
void Joy_Digital();		/* the joysticks, into Vec_Joy_1_X... */

/* sound: set Vec_Music_Flag to 1, then in each frame call
   Init_Music_chk(tune) before Wait_Recal() and Do_Sound() after it */
void Init_Music_chk(void *tune);
void Do_Sound();

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
#define Vec_Text_HW	(*(unsigned *)0xC82A)  /* text height and width */
#define Vec_Music_Flag	__VEC_U8(0xC856)  /* 1: start; $80: playing; 0 */
#define VIA_t1_cnt_lo	__VEC_U8(0xD004)  /* the scale of moves and lines */

/* the BIOS's tune */
#define Music1		((void *)0xFD0D)

#endif
