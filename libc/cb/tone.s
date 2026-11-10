; tone: the tone loop of coco.h's sound() (bcc09 -Me, -Mr; see sound.c):
; __cb_tone(tone, periods) plays that many periods of the tone, as Color
; BASIC's SOUND does, instruction for instruction (as in the CoCo's ROM
; at $A964, and the Dragon's at $BAB3), so that its pitches are BASIC's:
; each period writes the DAC four times ($7E, $FE, $7E, $02: a wave
; around the middle), with BASIC's delay after each, an INCA loop from
; the tone up to 0 (256 - tone times; tone 0, 256), and a period takes
; 100 + 20 * (256 - tone) cycles.  The tone is kept where BASIC keeps it
; ($8C, read with DP 0, as BASIC reads it); the period count, in Y, is
; checked in the 8 cycles BASIC takes to check its duration.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

DAC	equ	$FF20		; bits 2-7: the DAC
SNDTON	equ	$008C		; BASIC's SOUND's tone

	.text
	export	___cb_tone

___cb_tone:
	pshs	dp
	ldy	3,s		; periods (after DP and the return address)
	beq	done
	tfr	x,d		; the tone, in B
	clra			; DP 0, for BASIC's direct read of SNDTON
	tfr	a,dp
	stb	>SNDTON
period:	bsr	mid		; $7E
	lda	#$FE
	bsr	seg
	bsr	mid		; $7E
	lda	#$02
	bsr	seg
	leay	-1,y		; (5 cycles, as BASIC's LDX <$8D)
	bne	period		; (3, as its BNE)
done:	puls	dp,pc

mid:	lda	#$7E
seg:	sta	>DAC
	lda	<SNDTON
delay:	inca
	bne	delay
	rts
