/* stddef.h - for bcc09's libc
 *
 * From the dev86 C library (Copyright (C) 1996 Robert de Bath), which is
 * distributed under the GNU Library General Public License.
 */

#ifndef __STDDEF_H
#define __STDDEF_H

#include <sys/types.h>

#ifndef NULL
#define NULL ((void*)0)
#endif

#define offsetof(type, member)	((size_t)&((type *)0)->member)

#endif /* __STDDEF_H */
