; run on sim6809: each run-time helper in libc must leave alone the
; registers the compiler keeps values in across the call: Y and U for
; the 16-bit helpers, U for the 32-bit ones, and all but CC for linc_b
; and ldec_b; exits with the number of helpers that changed one of them

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
	import	ladd_b
	import	laddu_b
	import	lsub_b
	import	lsubu_b
	import	land_b
	import	landu_b
	import	lor_b
	import	loru_b
	import	leor_b
	import	leoru_b
	import	lmul_b
	import	lmulu_b
	import	ldiv_b
	import	ldivu_b
	import	lmod_b
	import	lmodu_b
	import	lcmp_b
	import	lcmpu_b
	import	ltst_b
	import	lneg_b
	import	lcom_b
	import	lsl_b
	import	lslu_b
	import	lsr_b
	import	lsru_b
	import	linc_b
	import	ldec_b

start:	lds	#$7f00
	clr	fails

; 16-bit helpers: D and X are the operands; keep Y and U
	ldy	#itable
inext:	ldx	,y++		; the next helper, or 0 at the end
	beq	idone
	pshs	y
	stx	helper
	ldy	#$a55a		; values to look for afterwards
	ldu	#$5aa5
	ldd	#-1000		; operands that make each helper loop
	ldx	#7
	jsr	[helper]
	cmpy	#$a55a
	bne	ibad
	cmpu	#$5aa5
	beq	igood
ibad:	inc	fails
igood:	puls	y
	bra	inext

; 32-bit helpers: D:X and the long at Y are the operands (Y is the
; count for shifts); keep U
idone:	ldy	#ltable
lnext:	ldx	,y++
	beq	ldone
	pshs	y
	stx	helper
	ldy	,y		; the long, or the count
	ldu	#$5aa5
	ldd	#$fffe		; -100000
	ldx	#$7960
	jsr	[helper]
	cmpu	#$5aa5
	beq	lgood
	inc	fails
lgood:	puls	y
	leay	2,y
	bra	lnext

; linc_b and ldec_b: X points at the long; keep D, X, Y and U
ldone:	ldy	#ctable
cnext:	ldx	,y++
	beq	done
	pshs	y
	stx	helper
	ldd	#$1234
	ldx	#along
	ldy	#$a55a
	ldu	#$5aa5
	jsr	[helper]
	cmpd	#$1234
	bne	cbad
	cmpx	#along
	bne	cbad
	cmpy	#$a55a
	bne	cbad
	cmpu	#$5aa5
	beq	cgood
cbad:	inc	fails
cgood:	puls	y
	bra	cnext

done:	ldb	fails
	stb	$ff02		; exit with that number
stop:	bra	stop

itable:	fdb	imul,imulu,idiv,imod,idivu,imodu,isl,islu,isr,isru,0
; each 32-bit helper, and its Y
ltable:	fdb	ladd_b,along,laddu_b,along,lsub_b,along,lsubu_b,along
	fdb	land_b,along,landu_b,along,lor_b,along,loru_b,along
	fdb	leor_b,along,leoru_b,along,lmul_b,along,lmulu_b,along
	fdb	ldiv_b,along,ldivu_b,along,lmod_b,along,lmodu_b,along
	fdb	lcmp_b,along,lcmpu_b,along,ltst_b,along,lneg_b,along
	fdb	lcom_b,along
	fdb	lsl_b,5,lslu_b,5,lsr_b,5,lsru_b,5
	fdb	0
ctable:	fdb	linc_b,ldec_b,0

	.data
along:	fdb	$0001,$86a0	; 100000

	.bss
helper:	.blkb	2
fails:	.blkb	1
