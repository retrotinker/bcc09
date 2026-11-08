; run on sim6809: each run-time helper in libc must leave Y and U as
; they were (the compiler keeps values in them across the call); exits
; with the number of helpers that changed one of them

	.text
	entry	start
	import	imul
	import	imulu
	import	idiv
	import	imod
	import	idivu
	import	imodu
	import	isl
	import	islu
	import	isr
	import	isru

start:	lds	#$7f00
	clr	fails
	ldy	#table
next:	ldx	,y++		; the next helper, or 0 at the end
	beq	done
	pshs	y
	ldy	#$a55a		; values to look for afterwards
	ldu	#$5aa5
	stx	helper
	ldd	#-1000		; operands that make each helper loop
	ldx	#7
	jsr	[helper]
	cmpy	#$a55a
	bne	bad
	cmpu	#$5aa5
	beq	good
bad:	inc	fails
good:	puls	y
	bra	next
done:	ldb	fails
	stb	$ff02		; exit with that number
stop:	bra	stop

table:	fdb	imul,imulu,idiv,imod,idivu,imodu,isl,islu,isr,isru,0

	.bss
helper:	.blkb	2
fails:	.blkb	1
