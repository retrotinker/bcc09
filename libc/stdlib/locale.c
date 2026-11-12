/* setlocale(category, locale), localeconv(): only the "C" locale; each
 * compiled separately (-DL_setlocale, -DL_localeconv)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#include <locale.h>
#include <limits.h>
#include <string.h>

#ifdef L_setlocale
char *
setlocale(category, locale)
int category;
const char *locale;
{
   if (category < LC_ALL || category > LC_TIME)
      return 0;
   if (locale == 0 || *locale == 0 || strcmp(locale, "C") == 0 ||
       strcmp(locale, "POSIX") == 0)
      return "C";
   return 0;
}
#endif

#ifdef L_localeconv
static struct lconv c =
{
   ".", "", "", "", "", "", "", "", "", "",
   CHAR_MAX, CHAR_MAX, CHAR_MAX, CHAR_MAX, CHAR_MAX, CHAR_MAX, CHAR_MAX,
   CHAR_MAX
};

struct lconv *
localeconv()
{
   return &c;
}
#endif
