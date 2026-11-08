; run on sim6809: each run-time helper in libc must leave alone the
; registers the compiler keeps values in across the call: Y and U for
; the 16-bit helpers, U for the 32-bit ones, all but CC for linc_b
; and ldec_b, and Y and U for the floating point ones, which must also
; pop and push what the compiler expects; exits with the number of
; helpers that didn't

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
	import	Fadd
	import	Fsub
	import	Fmul
	import	Fdiv
	import	Faddd
	import	Fsubd
	import	Fmuld
	import	Fdivd
	import	Faddf
	import	Fsubf
	import	Fmulf
	import	Fdivf
	import	Fcomp
	import	Fcompd
	import	Fcompf
	import	Ftstd
	import	Ftstf
	import	Fpushd
	import	Fnegd
	import	Fneg
	import	Fpulld
	import	Fpushf
	import	Fnegf
	import	Fpullf
	import	dtof
	import	Fpushc
	import	Fpushuc
	import	Fpushs
	import	Fpushus
	import	Fpushi
	import	Fpushui
	import	Fpushl
	import	Fpushul
	import	dtoc
	import	dtouc
	import	dtos
	import	dtous
	import	dtoi
	import	dtoui
	import	dtol
	import	dtoul
	import	ftoc
	import	ftouc
	import	ftos
	import	ftous
	import	ftoi
	import	ftoui
	import	ftol
	import	ftoul
	import	Fpreincd
	import	Fpredecd
	import	Fpostincd
	import	Fpostdecd
	import	Fpreincf
	import	Fpredecf
	import	Fpostincf
	import	Fpostdecf

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

; floating point helpers: X points at an operand, and on the stack are
; doubles (1.5); keep Y and U, and leave the stack with the number of
; bytes the table says
done:	ldy	#ftable
fnext:	ldx	,y
	beq	fdone
	stx	helper
	sty	fptr
	sts	fsave
	ldb	4,y		; push the doubles
fpush:	tstb
	beq	fcall
	ldx	#0
	pshs	x
	pshs	x
	pshs	x
	ldx	#$3ff8
	pshs	x
	subb	#8
	bra	fpush
fcall:	ldx	2,y
	ldy	#$a55a
	ldu	#$5aa5
	ldd	#3		; (the integer for Fpushi ...)
	jsr	[helper]
	cmpy	#$a55a
	bne	fbad
	cmpu	#$5aa5
	bne	fbad
	ldy	fptr		; S must be what it was, less what was left
	ldb	5,y
	clra
	pshs	d		; (2 more)
	tfr	s,d
	addd	,s++
	addd	#2
	cmpd	fsave
	beq	fgood
fbad:	inc	fails
fgood:	lds	fsave
	ldy	fptr
	leay	6,y
	bra	fnext

fdone:	ldb	fails
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
; each floating point helper, X, the bytes on the stack before the
; call, and after it
ftable:
	fdb	Fadd,0
	fcb	16,8
	fdb	Fsub,0
	fcb	16,8
	fdb	Fmul,0
	fcb	16,8
	fdb	Fdiv,0
	fcb	16,8
	fdb	Faddd,dbl
	fcb	8,8
	fdb	Fsubd,dbl
	fcb	8,8
	fdb	Fmuld,dbl
	fcb	8,8
	fdb	Fdivd,dbl
	fcb	8,8
	fdb	Faddf,flt
	fcb	8,8
	fdb	Fsubf,flt
	fcb	8,8
	fdb	Fmulf,flt
	fcb	8,8
	fdb	Fdivf,flt
	fcb	8,8
	fdb	Fcomp,0
	fcb	16,0
	fdb	Fcompd,dbl
	fcb	8,0
	fdb	Fcompf,flt
	fcb	8,0
	fdb	Ftstd,dbl
	fcb	0,0
	fdb	Ftstf,flt
	fcb	0,0
	fdb	Fpushd,dbl
	fcb	0,8
	fdb	Fnegd,dbl
	fcb	0,8
	fdb	Fneg,0
	fcb	8,8
	fdb	Fpulld,dvar
	fcb	8,0
	fdb	Fpushf,flt
	fcb	0,8
	fdb	Fnegf,flt
	fcb	0,8
	fdb	Fpullf,fvar
	fcb	8,0
	fdb	dtof,dbl
	fcb	0,8
	fdb	Fpushc,0
	fcb	0,8
	fdb	Fpushuc,0
	fcb	0,8
	fdb	Fpushs,0
	fcb	0,8
	fdb	Fpushus,0
	fcb	0,8
	fdb	Fpushi,0
	fcb	0,8
	fdb	Fpushui,0
	fcb	0,8
	fdb	Fpushl,0
	fcb	0,8
	fdb	Fpushul,0
	fcb	0,8
	fdb	dtoc,dbl
	fcb	0,0
	fdb	dtouc,dbl
	fcb	0,0
	fdb	dtos,dbl
	fcb	0,0
	fdb	dtous,dbl
	fcb	0,0
	fdb	dtoi,dbl
	fcb	0,0
	fdb	dtoui,dbl
	fcb	0,0
	fdb	dtol,dbl
	fcb	0,0
	fdb	dtoul,dbl
	fcb	0,0
	fdb	ftoc,flt
	fcb	0,0
	fdb	ftouc,flt
	fcb	0,0
	fdb	ftos,flt
	fcb	0,0
	fdb	ftous,flt
	fcb	0,0
	fdb	ftoi,flt
	fcb	0,0
	fdb	ftoui,flt
	fcb	0,0
	fdb	ftol,flt
	fcb	0,0
	fdb	ftoul,flt
	fcb	0,0
	fdb	Fpreincd,dvar
	fcb	0,0
	fdb	Fpredecd,dvar
	fcb	0,0
	fdb	Fpostincd,dvar
	fcb	0,8
	fdb	Fpostdecd,dvar
	fcb	0,8
	fdb	Fpreincf,fvar
	fcb	0,0
	fdb	Fpredecf,fvar
	fcb	0,0
	fdb	Fpostincf,fvar
	fcb	0,8
	fdb	Fpostdecf,fvar
	fcb	0,8
	fdb	0

	.data
along:	fdb	$0001,$86a0	; 100000
dbl:	fdb	$3ff8,0,0,0	; 1.5
flt:	fdb	$3fc0,0
dvar:	fdb	$3ff8,0,0,0
fvar:	fdb	$3fc0,0

	.bss
helper:	.blkb	2
fails:	.blkb	1
fptr:	.blkb	2
fsave:	.blkb	2
