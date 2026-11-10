; crtrom: start-up code for Color BASIC ROM cartridges (bcc09 -Mr)
;
; bcc09 links this first (ld09 -Crom), with rom.ld, which puts the code
; and an image of the initialized data in the cartridge's ROM at $C000,
; and the data and BSS in RAM from $0600.  With the cartridge's CART line
; wired to Q, the CoCo and the Dragon start it: BASIC's FIRQ handler
; jumps to $C000, here (the CoCo 3's, before BASIC has set up its
; stack).  start masks the interrupts, turns off the cartridge's FIRQ,
; sets S to __stack_top (rom.ld's, $8000 unless ld09 -A says otherwise),
; copies the initialized data from the ROM to the RAM, clears the BSS,
; calls the init functions (as crt0 does) and main.  When main returns,
; its result goes to exit(), as the C standard says; exit() calls the
; atexit() functions, and then _exit() (librom.a's: a cartridge has
; nothing to return to, so it stops).  librom.a is libcb.a with that
; _exit(): the I/O is through BASIC's ROM.
;
; Written for bcc09.  Like the rest of libc, it is distributed under the
; GNU Library General Public License, version 2 (see COPYING.LIB).

PIA1CRB	equ	$FF23		; bit 0 enables the cartridge's FIRQ

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end
	import	__data_start	; (rom.ld's .data section)
	import	__data_end
	loc	5		; (and these in segment 5)
	import	__seg5DL
	import	__seg5DH

	.text
	entry	start
	import	__data_load
	import	__stack_top
	import	_main
	import	_exit

start:	orcc	#$50		; no interrupts
	lds	#__stack_top
	lda	PIA1CRB		; and no more FIRQs from the cartridge
	anda	#$FE
	sta	PIA1CRB
	ldx	#__data_load	; the initialized data, to the RAM
	ldu	#__data_start
copy:	cmpu	#__data_end
	bhs	clear1
	lda	,x+
	sta	,u+
	bra	copy
clear1:	ldx	#__edata	; clear the BSS
clear:	cmpx	#__end
	bhs	clear2
	clr	,x+
	bra	clear
clear2:
	ldx	#__seg5DL	; the init functions
init:	cmpx	#__seg5DH
	bhs	go
	ldd	,x++		; (0: the linker's padding)
	beq	init
	pshs	x
	jsr	[-2,x]
	puls	x
	bra	init
go:	jsr	_main
	jmp	_exit		; main's result is in X, exit()'s argument
