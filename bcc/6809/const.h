/* const.h - constants for bcc */

/* Copyright (C) 1992 Bruce Evans */

/* switches for code generation */

#define DEBUG			/* generate compiler-debugging code */
/*#define I8088*/		/* target processor is Intel 8088 thru 80386 */
#define MC6809			/* target processor is Motorola 6809 */
#define SELFTYPECHECK		/* check calculated type = runtime type */


# define DYNAMIC_LONG_ORDER 0	/* have to define it so it works in #if's */
# define OP1			/* logical operators only use 1 byte */
# define POSINDEPENDENT		/* position indep code can (also) be gen */

/* switches for source and target operating system dependencies */

/*#define SOS_EDOS*/		/* source O/S is EDOS */
/*#define SOS_MSDOS*/		/* source O/S is MSDOS */
#define TOS_EDOS		/* target O/S is EDOS */

/* switches for source machine dependencies */

# define S_ALIGNMENT (sizeof(int))  /* source memory alignment, power of 2 */

# define UNPORTABLE_ALIGNMENT

/* local style */

#define FALSE 0
#ifndef NULL
#define NULL 0
#endif
#define TRUE 1

#define EXTERN extern
#define FORWARD static
#define PRIVATE static
#define PUBLIC
