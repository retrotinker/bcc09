/* softop.c - software operations for bcc */

/* Copyright (C) 1992 Bruce Evans */

#include "bcc.h"
#include "gencode.h"
#include "reg.h"
#include "scan.h"
#include "sizes.h"
#include "type.h"

/*-----------------------------------------------------------------------------
	softop(operation code, source leaf, target leaf)
	handles binary operations which are not done in hardware
	if the result type is (unsigned) long, float or double, all the work
	is immediately passed on to routines in other files. Otherwise:
	source and target may be either char, int or unsigned int
	they are not cast to ints or unsigneds before they get here
	considerable effort goes into avoiding unnecessary pushes
-----------------------------------------------------------------------------*/

PUBLIC void softop(op, source, target)
op_pt op;
struct symstruct *source;
struct symstruct *target;
{
	store_t regpushed;
	store_t regmark;
	scalar_t resultscalar;
	scalar_t sscalar;
	scalar_t tscalar;
	value_t sourceval;
	bool_t uflag;
	store_t workreg;

	if ((tscalar = target->type->scalar) & DLONG) {
		longop(op, source, target);
		return;
	}
	if (tscalar & RSCALAR) {
		floatop(op, source, target);
		return;
	}
	sscalar = source->type->scalar;
	resultscalar = tscalar;
	uflag = tscalar & UNSIGNED;
	if (op != SLOP && op != SROP) {
		resultscalar |= sscalar;
		uflag |= sscalar & UNSIGNED;
	}
	if ((op_t) op == MULOP && sscalar & CHAR && tscalar & CHAR &&
	    (source->storage != CONSTANT || (uvalue_t) source->offset.offv > 2))
	{
		if (source->storage & WORKDATREGS)
			push(source);
		load(target, DREG);
		outldmulreg();
		outadr(source);
		outmulmulreg();
		target->storage = DREG;
		target->type = iscalartotype(resultscalar);
		return;
	}
	if (source->storage == CONSTANT) {
		extend(target);
		load(target, DREG);
		target->type = iscalartotype(resultscalar);
		sourceval = source->offset.offv;
		switch ((op_t) op) {
		case DIVOP:
			if (diveasy(sourceval, uflag))
				return;
			break;
		case MODOP:
			if (modeasy(sourceval, uflag)) {
				if ((uvalue_t) sourceval <= MAXUCHTO + 1) {
					target->storage = BREG;
					target->type = ctype;
					if (uflag)
						target->type = uctype;
				}
				return;
			}
			break;
		case MULOP:
			if (muleasy((uvalue_t) sourceval, target->storage))
				return;
			load(target, DREG);
			break;
		case SLOP:
			slconst(sourceval, target->storage);
			return;
		case SROP:
			srconst(sourceval, uflag);
			return;
		}
		sscalar = (source->type = iscalartotype(resultscalar))->scalar;
	}

/* to load source first if it is CHAR: */
/* need work register if target is in WORKDATREGS */
/* use OPREG unless it will become overloaded later */

/* to preserve source while target is loaded: */
/* if source is in WORKDATREGS, put it in OPREG, */
/* unless target is OPREG-indirect */
/* otherwise, if source is in WORKDATREGS, put it in work reg not OPREG */
/* also assign a work reg if source is already in OPREG and target needs one */

	regpushed = (regmark = reguse) & OPREG;
	workreg = OPREG;
	if ((sscalar & CHAR && target->storage & WORKDATREGS &&
	     source->storage == OPREG && source->indcount != 0) ||
	    ((sscalar & CHAR || source->storage & WORKDATREGS) &&
	     target->storage == OPREG && target->indcount != 0) ||
	    ((source->storage == OPREG &&
	      target->storage == GLOBAL && target->indcount == 0)
	     && posindependent)
	    ) {
		if ((regmark | OPREG) == allindregs)
			regpushed |= (workreg = OPWORKREG);
		else {
			reguse |= OPREG;
			workreg = getindexreg();
		}
	}
	pushlist(regpushed);	/* no more pushes */
	reguse = allindregs;	/* error if another reg unexpectedly needed */

	if (sscalar & CHAR) {
		if (target->storage & WORKDATREGS) {
			extend(target);
			if (source->storage == workreg)
				exchange(source, target);
			else
				transfer(target, workreg);
		}
		extend(source);
		if (target->storage != OPREG &&
		    (target->storage != GLOBAL || target->indcount != 0
		     || !posindependent))
			workreg = OPREG;
	}
	if (source->storage & WORKDATREGS) {
		if (target->storage == OPREG && target->indcount == 0)
			exchange(source, target);
		else {
			transfer(source, workreg);
			workreg = OPREG;
		}
	}
	if (target->storage == GLOBAL && target->indcount == 0
	    && posindependent)
		load(target, workreg);

/* source and target now in position to be loaded without any more registers */

	extend(target);
	load(target, DREG);
	{
		load(source, OPREG);
		switch ((op_t) op) {
		case DIVOP:
			call("idiv");
			break;
		case MODOP:
			call("imod");
			break;
		case MULOP:
			call("imul");
			break;
		case SLOP:
			call("isl");
			break;
		case SROP:
			call("isr");
			break;
		}
		if (uflag)
			outbyte('u');
		outnl();
	}
	target->type = iscalartotype(resultscalar);
	poplist(regpushed);
	reguse = regmark;
}
