/* features.h - compiler features, for bcc09's libc
 *
 * From the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License, cut down for
 * the 6809.
 */

#ifndef __FEATURES_H
#define __FEATURES_H

#ifdef __STDC__

#define __P(x) x
#define __const const

/* bcc09 understands ANSI prototypes (through unproto), but not const or
   volatile */
#ifdef __BCC__
#define const
#define volatile
#endif

#else /* K&R */

#define __P(x) ()
#define __const
#define const
#define volatile

#endif

/* No C++ */
#define __BEGIN_DECLS
#define __END_DECLS

#endif
