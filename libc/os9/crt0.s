; crt0 for OS-9 (bcc09 -Mo; installed as crtos9.o): start-up code for an
; OS-9 program module
;
; F$Fork starts the module with U pointing at its data area, Y at the
; top of it, the parameters (ending with a CR) at the top, and X and S
; pointing at them, D their length.  The code reaches its data through U
; (the linker put the data at 0); the module (objcopy09 -O os9) has the
; data the program starts with after the code, just before the module's
; name.  start copies that to the data area, clears the BSS, calls the
; init functions (whose addresses in segment 5, which the linker puts in
; the data, are offsets in the code:
; see libc/sa/crt0.s; cc1 -Mo makes one for each module whose data
; starts with addresses, which the data can't hold), then main(argc,
; argv) by way of __os9start (os9/start.c), and exit() with its result.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end
	loc	5		; (and these in segment 5)
	import	__seg5DL
	import	__seg5DH

	.text
	entry	start
	import	__btext
	import	___os9start
	import	_exit

start:	pshs	d,x		; 0,S: the parameters' length  2,S: them
	leay	__btext,pcr	; the module's header is just before the
	leay	-13,y		; code; at 4 in it, where its name is
	ldd	4,y
	leay	d,y
	pshs	y		; 0,S: the module's name
	ldd	#__edata	; the data's size (it is at 0); its image is
	pshs	d		; just before the name
	tfr	y,d
	subd	,s
	tfr	d,x		; X: the image
	tfr	u,d
	addd	,s		; 0,S: where the copy ends
	std	,s
	leay	,u
copy:	cmpy	,s
	bhs	clear0
	lda	,x+
	sta	,y+
	bra	copy
clear0:	tfr	u,d		; the BSS, to U + __end
	addd	#__end
	std	,s
clear:	cmpy	,s
	bhs	init0
	clr	,y+
	bra	clear
init0:	leas	2,s		; 0,S: the name  2,S: length  4,S: parameters
	leax	__seg5DL,u	; the init functions (their table is in
init:	leay	__seg5DH,u	; the data, copied by now)
	pshs	y
	cmpx	,s++
	bhs	main
	ldd	,x++		; (0: the linker's padding)
	beq	init
	pshs	x
	leax	__btext,pcr	; (an offset in the code)
	jsr	d,x
	puls	x
	bra	init
main:	ldx	4,s		; __os9start(parameters, name, length)
	lbsr	___os9start
	lbsr	_exit		; exit(main's result)
