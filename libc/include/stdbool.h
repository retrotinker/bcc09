/* stdbool.h - for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * bcc09 has C99's _Bool: an unsigned char that a conversion makes 0 or 1.
 */

#ifndef __STDBOOL_H
#define __STDBOOL_H

#define bool	_Bool
#define true	1
#define false	0
#define __bool_true_false_are_defined	1

#endif
