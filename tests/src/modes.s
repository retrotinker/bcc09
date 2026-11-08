; 6809 instructions in each addressing mode, and assembler pseudo-ops

	.text
	export	modes
	import	faraway
value	equ	$1234
small	equ	5

modes:
; inherent
	nop
	clra
	clrb
	sex
	abx
	mul
	daa
	rts
; immediate
	lda	#$12
	ldb	#small
	ldd	#value
	ldx	#table
	ldy	#-1
	lds	#$7f00
	ldu	#0
	cmpa	#'A
	andcc	#$af
	orcc	#$50
; direct and extended
	lda	<$20
	sta	<$21
	ldd	>$1000
	std	value
	jsr	>faraway
	inc	counter
; indexed
	lda	,x
	lda	5,x
	lda	-5,y
	lda	100,u
	lda	-300,s
	lda	1000,x
	lda	a,x
	lda	b,y
	lda	d,u
	lda	,x+
	lda	,x++
	lda	,-y
	lda	,--y
	lda	[,x]
	lda	[10,y]
	lda	[,u++]
	lda	[value]
	leax	table,pcr
	leay	1,y
	leas	-4,s
	leau	d,x
; relative branches
back:	bra	back
	bne	fwd
	beq	back
	bcc	fwd
	bmi	back
	bsr	sub
	lbra	far
	lbeq	far
	lbsr	sub
fwd:	brn	fwd
; register operations
	tfr	x,y
	tfr	a,dp
	exg	d,u
	pshs	a,b,x,y,u,pc
	puls	cc,dp
	pshu	d,s
	pulu	x
	cmpd	#0
	cmpu	,s
	cmps	value
	swi
	swi2
	swi3
	cwai	#$ef
	sync
sub:	rts
far:	rti

	.data
table:	fcb	1,2,3,$ff
	fdb	value,modes,-1
	fcc	"text"
	.byte	'x,0
	.word	$abcd
	.ascii	"abc"
	.blkb	3
	rmb	2

	.bss
counter: .blkb	2
