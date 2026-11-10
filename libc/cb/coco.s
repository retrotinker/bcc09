; coco: coco.h's functions for Color BASIC programs (bcc09 -Me, libcb.a;
; and ROM cartridges, -Mr, librom.a): the CoCo's and the Dragon's
; keyboard, text screen and joysticks, as BASIC's INKEY$, CLS, PRINT@
; and JOYSTK have them
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

JOYIN	equ	$A00A		; the ROM's vector: read the joysticks
CURPOS	equ	$0088		; the cursor's address on the screen
POTVAL	equ	$015A		; the joysticks' values (JOYIN puts them)
SCREEN	equ	$0400		; the text screen, 32 by 16

	.data			; (stdio sets it, in the data segment)
	import	___stdio_flushout

	.text
	import	___cb_polcat
	export	_inkey
	export	_cls
	export	_locate
	export	_joystk

; inkey(): the key being pressed, or 0 if none (BASIC's INKEY$)
_inkey:	jmp	___cb_polcat

; flush: what printf() and the rest have buffered for stdout, before the
; cursor moves (if the program uses stdio, which sets the hook)
flush:	ldx	___stdio_flushout
	beq	fl2
	jsr	,x
fl2:	rts

; locate(row, col): put the cursor at row 0-15, column 0-31 (BASIC's
; PRINT@ row * 32 + col)
_locate:
	pshs	x
	bsr	flush
	puls	d		; row
	lslb			; * 32
	rola
	lslb
	rola
	lslb
	rola
	lslb
	rola
	lslb
	rola
	addd	2,s		; + col
	addd	#SCREEN
	std	>CURPOS
	rts

; cls(c): clear the screen, as BASIC's CLS c: 0 black, 1-8 a colour
; (green, yellow, blue, red, buff, cyan, magenta, orange), or -1 (any
; other) as plain CLS, the green text background; the cursor goes to
; the top left
_cls:	pshs	x
	bsr	flush
	puls	d
	cmpd	#8		; (unsigned: -1 is large)
	bhi	plain
	tstb
	beq	black
	decb			; colour c: $8F + (c - 1) * 16
	lslb
	lslb
	lslb
	lslb
	orb	#$8F
	tfr	b,a
	bra	fill
black:	lda	#$80
	bra	fill
plain:	lda	#$60
fill:	ldx	#SCREEN
fill1:	sta	,x+
	cmpx	#SCREEN+512
	blo	fill1
	ldx	#SCREEN
	stx	>CURPOS
	rts

; joystk(n): joystick value n, 0 to 63 (BASIC's JOYSTK: 0 and 1 the
; right joystick's x and y, 2 and 3 the left one's), read now
_joystk:
	pshs	x
	jsr	[JOYIN]
	puls	x
	ldb	POTVAL,x
	clra
	tfr	d,x
	rts
