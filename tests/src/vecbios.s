; stands in for the Vectrex's BIOS on sim6809, for testing bcc09 -Mv's
; libvec.a: at $F000, each routine libvec.a calls is at its
; address, and prints its name, the registers it takes (A, B, U...) and
; DP through the simulator's I/O block; Read_Btns gives $5A and Random
; $33, for the program to pass on
;
; (After an ORG, as09's labels are absolute, though the bytes are placed
; from the segment's start: so it is linked at 0, and run.sh keeps only
; its S-records from $F000 up, past the zeros before the first ORG.)

IO_OUT	equ	$FF00
MISCCNT	equ	$C823		; Vec_Misc_Count

	.text
	entry	bios		; (ld09 needs one; it isn't run)
bios:
	org	$F192
	jmp	s_wait		; $F192 Wait_Recal
	org	$F1BA
	jmp	s_btns		; $F1BA Read_Btns
	org	$F1F8
	jmp	s_joy		; $F1F8 Joy_Digital
	org	$F289
	jmp	s_sound		; $F289 Do_Sound
	org	$F2AB
	jmp	s_inten		; $F2AB Intensity_a
	org	$F2C3
	jmp	s_dot		; $F2C3 Dot_d
	org	$F312
	jmp	s_move		; $F312 Moveto_d
	org	$F354
	jmp	s_reset		; $F354 Reset0Ref
	org	$F37A
	jmp	s_print		; $F37A Print_Str_d
	org	$F3CE
	jmp	s_vlc		; $F3CE Draw_VLc
	org	$F3DF
	jmp	s_line		; $F3DF Draw_Line_d
	org	$F517
	jmp	s_rand		; $F517 Random
	org	$F687
	jmp	s_music		; $F687 Init_Music_chk

	org	$F700
s_wait:	ldx	#m_wait
	bra	noargs
s_reset: ldx	#m_reset
	bra	noargs
s_joy:	ldx	#m_joy
	bra	noargs
s_sound: ldx	#m_sound
noargs:	jsr	pname
	jmp	pdpnl
s_btns:	ldx	#m_btns
	jsr	pname
	jsr	pdpnl
	lda	#$5A
	rts
s_rand:	ldx	#m_rand
	jsr	pname
	jsr	pdpnl
	lda	#$33
	rts
s_inten: ldx	#m_inten
	jsr	pname
	jsr	phexa
	jmp	pdpnl
s_move:	ldx	#m_move
	bra	yx
s_dot:	ldx	#m_dot
yx:	jsr	pname
	jsr	phexa
	tfr	b,a
	jsr	phexa
	jmp	pdpnl
s_line:	ldx	#m_line
	jsr	pname
	jsr	phexa
	tfr	b,a
	jsr	phexa
	lda	MISCCNT		; (must be 0 for one line)
	jsr	phexa
	jmp	pdpnl
s_print: ldx	#m_print
	jsr	pname
	jsr	phexa
	tfr	b,a
	jsr	phexa
	lda	#$20
	sta	IO_OUT
pstr:	lda	,u+		; the string, to its $80
	cmpa	#$80
	beq	pstr2
	sta	IO_OUT
	bra	pstr
pstr2:	jmp	pdpnl
s_vlc:	pshs	x
	ldx	#m_vlc
	jsr	pname
	puls	x
	lda	,x		; the count, and the first line
	jsr	phexa
	lda	1,x
	jsr	phexa
	lda	2,x
	jsr	phexa
	jmp	pdpnl
s_music: ldx	#m_music
	jsr	pname
	tfr	u,d
	jsr	phexa
	tfr	b,a
	jsr	phexa2
	jmp	pdpnl

; pname: the name at X, to its 0 (keeping A)
pname:	pshs	a
pn1:	lda	,x+
	beq	pn2
	sta	IO_OUT
	bra	pn1
pn2:	puls	a,pc
; phexa: a space and A in hex; phexa2: A in hex
phexa:	pshs	a
	lda	#$20
	sta	IO_OUT
	puls	a
phexa2:	pshs	a
	lsra
	lsra
	lsra
	lsra
	bsr	digit
	puls	a
	anda	#$0F
digit:	adda	#$30
	cmpa	#$39
	bls	dig2
	adda	#7
dig2:	sta	IO_OUT
	rts
; pdpnl: " dp", DP and a newline
pdpnl:	ldx	#m_dp
	bsr	pname
	tfr	dp,a
	bsr	phexa2
	lda	#$0A
	sta	IO_OUT
	rts

m_wait:	fcc	"Wait_Recal"
	fcb	0
m_reset: fcc	"Reset0Ref"
	fcb	0
m_joy:	fcc	"Joy_Digital"
	fcb	0
m_sound: fcc	"Do_Sound"
	fcb	0
m_btns:	fcc	"Read_Btns"
	fcb	0
m_rand:	fcc	"Random"
	fcb	0
m_inten: fcc	"Intensity_a"
	fcb	0
m_move:	fcc	"Moveto_d"
	fcb	0
m_dot:	fcc	"Dot_d"
	fcb	0
m_line:	fcc	"Draw_Line_d"
	fcb	0
m_print: fcc	"Print_Str_d"
	fcb	0
m_vlc:	fcc	"Draw_VLc"
	fcb	0
m_music: fcc	"Init_Music_chk"
	fcb	0
m_dp:	fcc	" dp "
	fcb	0
