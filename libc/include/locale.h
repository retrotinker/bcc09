/* locale.h - for bcc09's libc: only C's "C" locale, which setlocale()
 * accepts (as "C", or "", the native one, which is the same), and
 * localeconv() describes.
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __LOCALE_H
#define __LOCALE_H
#include <features.h>

#ifndef NULL
#define NULL ((void*)0)
#endif

#define LC_ALL		0
#define LC_COLLATE	1
#define LC_CTYPE	2
#define LC_MONETARY	3
#define LC_NUMERIC	4
#define LC_TIME		5

struct lconv
{
   char *decimal_point;
   char *thousands_sep;
   char *grouping;
   char *int_curr_symbol;
   char *currency_symbol;
   char *mon_decimal_point;
   char *mon_thousands_sep;
   char *mon_grouping;
   char *positive_sign;
   char *negative_sign;
   char int_frac_digits;
   char frac_digits;
   char p_cs_precedes;
   char p_sep_by_space;
   char n_cs_precedes;
   char n_sep_by_space;
   char p_sign_posn;
   char n_sign_posn;
};

extern char *setlocale __P ((int, __const char *));
extern struct lconv *localeconv __P ((void));

#endif
