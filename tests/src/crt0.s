; minimal start-up code: set the stack, clear the BSS, call main, stop

	.data			; the linker defines these in the data segment,
	import	__edata		; so they must be imported there
	import	__end

	.text
	entry	start
	import	_main
start:	lds	#$7f00
	ldx	#__edata
clear:	cmpx	#__end
	bhs	go
	clr	,x+
	bra	clear
go:	jsr	_main
stop:	bra	stop
