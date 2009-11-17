/* const.h - constants for bcc */

/* Copyright (C) 1992 Bruce Evans */

#ifdef __STDC__
#include <stdlib.h>
#else
#include <malloc.h>
#endif

#include "debug.h"

/* switches for code generation */



#ifndef VERY_SMALL_MEMORY
#define SELFTYPECHECK		/* check calculated type = runtime type */
#define DBNODE			/* generate compiler node debugging code */
#define OPTIMISE		/* include optimisation code */
#endif

#ifndef __BCC__
#define BUILTIN_CPP		/* Remove the built in C preprocessor */
#endif


# define DYNAMIC_LONG_ORDER 0	/* have to define it so it works in #if's */
# define OP1			/* logical operators only use 1 byte */
# define POSINDEPENDENT		/* position indep code can (also) be gen */

/* switches for source and target operating system dependencies */

/*#define SOS_EDOS*/		/* source O/S is EDOS */
/*#define SOS_MSDOS*/		/* source O/S is MSDOS */
/*#define TOS_EDOS*/		/* target O/S is EDOS */


/* switches for source machine dependencies */

/* Unportable alignment needed for specific compilers */
#ifndef VERY_SMALL_MEMORY
# define S_ALIGNMENT (sizeof(long)) /* A little safer */
#endif

/* local style */

#ifndef NULL
#define NULL 0
#endif
#define FALSE 0
#define TRUE 1

#define EXTERN extern
#define FORWARD static
#define PRIVATE static
#define PUBLIC

/* #define C_CODE	* Don't use assembler outstr() function. */

