/* stdarg.h - variable argument lists, for bcc09's libc
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 *
 * bcc09 passes a function's first argument in a register (X, or D:X for a
 * long), which the function keeps below its return address, and the rest
 * on the stack, in order, above the return address.  So the address of
 * the last named parameter doesn't lead to the variable arguments when it
 * is the first parameter.  Instead, unproto puts an int parameter named
 * __va_alist where the "..." was in the definition of such a function
 * (see unproto/Makefile); it is always on the stack, where the first
 * variable argument is, and va_start takes its address.
 *
 * Arguments of types narrower than int arrive as ints, as the C standard
 * says, so va_arg(ap, char) isn't allowed.  Longs are stored high word
 * first, as in memory.
 */

#ifndef __STDARG_H
#define __STDARG_H

typedef char *va_list;

#define va_start(ap, p)		((ap) = (char *) &__va_alist)
#define va_arg(ap, type)	(((type *) ((ap) += sizeof(type)))[-1])
#define va_end(ap)
#define va_copy(dst, src)	((dst) = (src))

#endif
