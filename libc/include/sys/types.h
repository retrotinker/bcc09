/* sys/types.h - basic types, for bcc09's libc on the 6809
 *
 * After the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License.
 */

#ifndef __SYS_TYPES_H
#define __SYS_TYPES_H

#include <features.h>

#ifndef __SIZE_T
#define __SIZE_T
typedef unsigned int size_t;	/* (dev86 had int, but it's unsigned) */
#endif
typedef int ssize_t;
typedef int ptrdiff_t;

typedef long off_t;
typedef long time_t;

#endif
