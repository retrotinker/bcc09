/* string.h - string and memory functions, for bcc09's libc
 *
 * From the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License.
 */

#ifndef __STRING_H
#define __STRING_H
#include <features.h>
#include <sys/types.h>
#include <stddef.h>

/* Basic string functions */
extern size_t strlen __P ((__const char* __str));

extern char * strcat __P ((char*, __const char*));
extern char * strcpy __P ((char*, __const char*));
extern int strcmp __P ((__const char*, __const char*));

extern char * strncat __P ((char*, __const char*, size_t));
extern char * strncpy __P ((char*, __const char*, size_t));
extern int strncmp __P ((__const char*, __const char*, size_t));

extern char * strchr __P ((__const char*, int));
extern char * strrchr __P ((__const char*, int));
extern char * strdup __P ((__const char*));

/* Basic mem functions */
extern void * memcpy __P ((void*, __const void*, size_t));
extern void * memccpy __P ((void*, __const void*, int, size_t));
extern void * memchr __P ((__const void*, int, size_t));
extern void * memset __P ((void*, int, size_t));
extern int memcmp __P ((__const void*, __const void*, size_t));

extern void * memmove __P ((void*, __const void*, size_t));

/* Minimal (very!) locale support */
#define strcoll strcmp

/* BSDisms */
#define index strchr
#define rindex strrchr

/* Other common functions */
extern char * strpbrk __P ((__const char *, __const char *));
extern char * strsep __P ((char **, __const char *));
extern char * strstr __P ((__const char *, __const char *));
extern char * strtok __P ((char *, __const char *));
extern size_t strcspn __P ((__const char *, __const char *));
extern size_t strspn __P ((__const char *, __const char *));

#endif
