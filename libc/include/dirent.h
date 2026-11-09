/* dirent.h - for bcc09's libc: reading directories (OS-9's)
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

#ifndef __DIRENT_H
#define __DIRENT_H
#include <features.h>
#include <sys/types.h>

struct dirent
{
   ino_t d_ino;			/* (OS-9: the file descriptor's LSN) */
   char d_name[30];
};

typedef struct
{
   int dd_fd;
   struct dirent dd_ent;	/* what readdir() returns */
} DIR;

extern DIR *opendir __P ((__const char *));
extern struct dirent *readdir __P ((DIR *));
extern int closedir __P ((DIR *));
extern void rewinddir __P ((DIR *));

#endif
