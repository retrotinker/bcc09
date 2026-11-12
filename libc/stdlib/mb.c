/* the multibyte character functions, in the "C" locale, where each
 * character is a byte, a wchar_t, and there's no shift state; each
 * compiled separately (-DL_mblen and so on)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <stdlib.h>

#ifdef L_mblen
int
mblen(s, n)
const char *s;
size_t n;
{
   if (s == 0)
      return 0;		/* (no shift state) */
   if (n == 0)
      return -1;
   return *s != 0;
}
#endif

#ifdef L_mbtowc
int
mbtowc(pwc, s, n)
wchar_t *pwc;
const char *s;
size_t n;
{
   if (s == 0)
      return 0;
   if (n == 0)
      return -1;
   if (pwc)
      *pwc = *s;
   return *s != 0;
}
#endif

#ifdef L_wctomb
int
wctomb(s, wc)
char *s;
wchar_t wc;
{
   if (s == 0)
      return 0;
   *s = wc;
   return 1;
}
#endif

#ifdef L_mbstowcs
size_t
mbstowcs(pwcs, s, n)
wchar_t *pwcs;
const char *s;
size_t n;
{
   size_t i;

   for (i = 0; i < n; i++)
      if ((pwcs[i] = s[i]) == 0)
	 break;
   return i;
}
#endif

#ifdef L_wcstombs
size_t
wcstombs(s, pwcs, n)
char *s;
const wchar_t *pwcs;
size_t n;
{
   size_t i;

   for (i = 0; i < n; i++)
      if ((s[i] = pwcs[i]) == 0)
	 break;
   return i;
}
#endif
