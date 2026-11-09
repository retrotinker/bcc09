/* type.c - type and storage-class routines for bcc */

/* Copyright (C) 1992 Bruce Evans */

#include "bcc.h"
#include "align.h"
#include "gencode.h"		/* s.b. switches.h */
#include "sc.h"
#include "scan.h"
#include "table.h"

#undef EXTERN
#define EXTERN
#include "type.h"

PUBLIC uoffset_T ctypesize = 1;
PUBLIC uoffset_T dtypesize = 8;
PUBLIC uoffset_T ftypesize = 0;
PUBLIC uoffset_T itypesize = 2;
PUBLIC uoffset_T ptypesize = 2;
PUBLIC uoffset_T stypesize = 2;

PRIVATE char skey0;
PRIVATE char skey1;

PUBLIC struct typestruct *addstruct(structname)
char *structname;
{
	unsigned namelength;
	struct symstruct *symptr;
	struct typestruct *structype;

	(structype = newtype())->constructor = STRUCTU;
	structype->alignmask = ctype->alignmask;
	if (++skey1 == 0) {
		++skey1;	/* must be nonzero or key string would end */
		++skey0;	/* will never reach 'A' to be an identifier */
	}
	structype->structkey[0] = skey0;
	structype->structkey[1] = skey1;
	if (*structname != 0) {
		symptr = addlorg(structname, structype);
		symptr->storage = 0;
		symptr->flags = STRUCTNAME;
		if (charptr + (namelength = strlen(structname)) >= chartop)
			growheap(namelength + 1);
#ifdef TS
		++ts_n_structname;
		ts_s_structname += namelength + 1;
#endif
		structype->tname = strcpy(charptr, structname);
		charptr += namelength + 1;
	}
	return structype;
}

PUBLIC struct typestruct *iscalartotype(scalar)
scalar_pt scalar;
{
	if (scalar & LONG) {
		if (scalar & UNSIGNED)
			return ultype;
		return ltype;
	}
	if (scalar & UNSIGNED)
		return uitype;
	return itype;
}

PUBLIC struct typestruct *newtype()
{
	register struct typestruct *type;

	type = qmalloc(sizeof *type);
#ifdef TS
	++ts_n_type;
	ts_s_type += sizeof *type;
#endif
	type->typesize =	/* (uoffset_T) */
	    type->scalar =	/* (scalar_t) */
	    type->constructor =	/* (constr_t) */
	    type->structkey[0] = 0;
	type->nexttype = type->prevtype = type->sidetype = NULL;
	type->listtype = NULL;
	type->proto = NULL;
	type->tname = "";
	return type;
}

PUBLIC void outntypechar(type)
struct typestruct *type;
{
	outnbyte(*type->tname);
}

PUBLIC struct typestruct *pointype(type)
struct typestruct *type;
{
	return prefix(POINTER, ptypesize, type);
}

PUBLIC struct typestruct *prefix(constructor, size, type)
constr_pt constructor;
uoffset_T size;
struct typestruct *type;
{
	register struct typestruct *searchtype;

	for (searchtype = type->prevtype; searchtype != NULL;
	     searchtype = searchtype->sidetype)
		if (searchtype->constructor == (constr_t) constructor &&
		    searchtype->typesize == size &&
		    searchtype->proto == NULL)	/* (functype() does those) */
			return searchtype;
	switch ((searchtype = newtype())->constructor = constructor) {
	case ARRAY:
		searchtype->alignmask = type->alignmask;
		break;
	case FUNCTION:
		searchtype->alignmask = ~(uoffset_T) 0;
		break;
	case POINTER:
		searchtype->alignmask = ~(ptypesize - 1) | alignmask;
		break;
	case STRUCTU:
		bugerror("prefixing structure/union");
		searchtype->alignmask = alignmask;
		break;
	}
	searchtype->typesize = size;
	searchtype->nexttype = type;
	searchtype->sidetype = type->prevtype;
	return type->prevtype = searchtype;
}

/* nonzero if the prototypes are the same: types are canonical */
PRIVATE bool_pt protoeq(p1, p2)
struct proto *p1;
struct proto *p2;
{
	int i;

	if (p1 == p2)
		return TRUE;
	if (p1 == NULL || p2 == NULL || p1->nparams != p2->nparams ||
	    p1->varargs != p2->varargs)
		return FALSE;
	for (i = 0; i < p1->nparams; i++)
		if (p1->ptypes[i] != p2->ptypes[i])
			return FALSE;
	return TRUE;
}

/* a function returning type, with the prototype proto (or none): one
   type for each different prototype, so that a call through a pointer
   to it can find its parameters' types */
PUBLIC struct typestruct *functype(type, proto)
struct typestruct *type;
struct proto *proto;
{
	register struct typestruct *searchtype;

	if (proto == NULL)
		return prefix(FUNCTION, ftypesize, type);
	for (searchtype = type->prevtype; searchtype != NULL;
	     searchtype = searchtype->sidetype)
		if (searchtype->constructor == FUNCTION &&
		    protoeq(searchtype->proto, proto))
			return searchtype;
	searchtype = newtype();
	searchtype->constructor = FUNCTION;
	searchtype->alignmask = ~(uoffset_T) 0;
	searchtype->typesize = ftypesize;
	searchtype->proto = proto;
	searchtype->nexttype = type;
	searchtype->sidetype = type->prevtype;
	return type->prevtype = searchtype;
}

/* if t1 and t2 are compatible function types (or pointers to them): the
   same result, and the same prototype or one without (C's rule, but for
   the promotions that a prototype's types must have to match none),
   the one with the prototype; else NULL */
PUBLIC struct typestruct *funcmerge(t1, t2)
struct typestruct *t1;
struct typestruct *t2;
{
	struct typestruct *f1;
	struct typestruct *f2;

	if (t1 == t2)
		return t1;
	f1 = t1;
	f2 = t2;
	if (t1->constructor == POINTER && t2->constructor == POINTER) {
		f1 = t1->nexttype;
		f2 = t2->nexttype;
	}
	if (f1->constructor != FUNCTION || f2->constructor != FUNCTION ||
	    f1->nexttype != f2->nexttype)
		return NULL;
	if (f1->proto == NULL)
		return t2;
	if (f2->proto == NULL || protoeq(f1->proto, f2->proto))
		return t1;
	return NULL;
}

PUBLIC struct typestruct *promote(type)
struct typestruct *type;
{
	scalar_t scalar;

	if ((scalar = type->scalar) & (CHAR | SHORT)) {
		if (scalar & UNSIGNED)
			return uitype;
		return itype;
	}
	if (scalar & FLOAT)
		return dtype;
	if (type->constructor & ARRAY)
		return pointype(type->nexttype);
	if (type->constructor & FUNCTION)
		return pointype(type);
	return type;
}

PUBLIC struct typestruct *tosigned(type)
struct typestruct *type;
{
	switch (type->scalar & ~(UNSIGNED | DLONG)) {
	case CHAR:
		return sctype;
	case SHORT:
		return stype;
	case INT:
		return itype;
	case LONG:
		return ltype;
	default:
		error("signed only applies to integral types");
		return type;
	}
}

PUBLIC struct typestruct *tounsigned(type)
struct typestruct *type;
{
	switch (type->scalar & ~(UNSIGNED | DLONG)) {
	case CHAR:
		return uctype;
	case SHORT:
		return ustype;
	case INT:
		return uitype;
	case LONG:
		return ultype;
	default:
		error("unsigned only applies to integral types");
		return type;
	}
}

PUBLIC void typeinit()
{
	fitype = prefix(FUNCTION, ftypesize, itype);
	pctype = pointype(ctype);
	skey0 = 1;
	vtype->constructor = VOID;
}
