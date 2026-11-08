/* malloc.h - for bcc09's libc
 *
 * From the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License.  For bcc09:
 * no alloca.
 */

#ifndef __MALLOC_H
#define __MALLOC_H
#include <features.h>
#include <sys/types.h>

/*
 * Mini malloc allows you to use a less efficient but smaller malloc the
 * cost is about 100 bytes of code in free but malloc (700bytes) doesn't
 * have to be linked. Unfortunatly memory can only be reused if everything
 * above it has been freed
 * 
 */

extern void free __P((void *));
extern void *malloc __P((size_t));
extern void *realloc __P((void *, size_t));
extern void *calloc __P((size_t, size_t));

extern void *(*__alloca_alloc) __P((size_t));

#ifdef __LIBC__
#define __MINI_MALLOC__
#endif

#ifdef __MINI_MALLOC__
#define malloc(x) ((*__alloca_alloc)(x))
#endif

#endif
