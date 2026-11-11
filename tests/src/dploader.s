; stands in for a loader, as loader.s does, but with DP $5A: the program
; (with __direct variables, so that its start-up code sets DP to their
; page) must give it back; exit 98 if it doesn't, 99 if S is wrong, else
; with the low byte of the program's status

	.text
	entry	loader		; (so that ld09 loads this module)
	import	start

loader:	lds	#$7f00
	lda	#$5A
	tfr	a,dp
	jsr	start
	tfr	dp,a
	cmpa	#$5A
	beq	dpok
	ldb	#98
	bra	done
dpok:	cmps	#$7f00
	beq	done
	ldb	#99
done:	stb	$ff02
stop:	bra	stop
