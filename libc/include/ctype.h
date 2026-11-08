/* ctype.h - character classification and conversion, for bcc09's libc
 *
 * From the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License.  Changes for
 * bcc09: isprint and isgraph test for the printable classes, so that they
 * are false for EOF and for characters over 0x7F, as in the C locale;
 * and toupper and tolower are functions, since the macros evaluated their
 * argument twice.
 */

#ifndef __CTYPE_H
#define __CTYPE_H

#include <features.h>

extern	unsigned char	__ctype[];

#define	__CT_d	0x01		/* numeric digit */
#define	__CT_u	0x02		/* upper case */
#define	__CT_l	0x04		/* lower case */
#define	__CT_c	0x08		/* control character */
#define	__CT_s	0x10		/* whitespace */
#define	__CT_p	0x20		/* punctuation */
#define	__CT_x	0x40		/* hexadecimal */
#define	__CT_b	0x80		/* the space character (printable) */

extern int toupper __P ((int));
extern int tolower __P ((int));

/* These need a letter of the other case */
#define	_toupper(c)	((c)^0x20)
#define	_tolower(c)	((c)^0x20)
#define	toascii(c)	((c)&0x7F)

#define __CT(c) (__ctype[1+(unsigned char)c])

/* Note the '!!' is a cast to 'bool' and even BCC deletes it in an if()  */
#define	isalnum(c)	(!!(__CT(c)&(__CT_u|__CT_l|__CT_d)))
#define	isalpha(c)	(!!(__CT(c)&(__CT_u|__CT_l)))
#define	isascii(c)	(!((c)&~0x7F))
#define	iscntrl(c)	(!!(__CT(c)&__CT_c))
#define	isdigit(c)	(!!(__CT(c)&__CT_d))
#define	isgraph(c)	(!!(__CT(c)&(__CT_u|__CT_l|__CT_d|__CT_p)))
#define	islower(c)	(!!(__CT(c)&__CT_l))
#define	isprint(c)	(!!(__CT(c)&(__CT_u|__CT_l|__CT_d|__CT_p|__CT_b)))
#define	ispunct(c)	(!!(__CT(c)&__CT_p))
#define	isspace(c)	(!!(__CT(c)&__CT_s))
#define	isupper(c)	(!!(__CT(c)&__CT_u))
#define	isxdigit(c)	(!!(__CT(c)&__CT_x))

#endif /* __CTYPE_H */
