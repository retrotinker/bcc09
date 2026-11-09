
/* stdio.h - for bcc09's libc
 *
 * From the dev86 C library (Copyright (C) Robert de Bath), which is
 * distributed under the GNU Library General Public License.  For bcc09:
 * BUFSIZ is 256; no MSDOS text translation; the printf family is new
 * (dev86's had no license); standard prototypes.
 */

#ifndef __STDIO_H
#define __STDIO_H

#include <features.h>
#include <sys/types.h>

#ifndef SEEK_SET
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif

#define _IOFBF		0x00	/* full buffering */
#define _IOLBF		0x01	/* line buffering */
#define _IONBF		0x02	/* no buffering */
#define __MODE_BUF	0x03	/* Modal buffering dependent on isatty */

#define __MODE_FREEBUF	0x04	/* Buffer allocated with malloc, can free */
#define __MODE_FREEFIL	0x08	/* FILE allocated with malloc, can free */

#define __MODE_READ	0x10	/* Opened in read only */
#define __MODE_WRITE	0x20	/* Opened in write only */
#define __MODE_RDWR	0x30	/* Opened in read/write */

#define __MODE_READING	0x40	/* Buffer has pending read data */
#define __MODE_WRITING	0x80	/* Buffer has pending write data */

#define __MODE_EOF	0x100	/* EOF status */
#define __MODE_ERR	0x200	/* Error status */
#define __MODE_UNGOT	0x400	/* Buffer has been polluted by ungetc */

#define __MODE_IOTRAN	0

/* when you add or change fields here, be sure to change the initialization
 * in stdio_init and fopen */
struct __stdio_file {
  unsigned char *bufpos;   /* the next byte to write to or read from */
  unsigned char *bufread;  /* the end of data returned by last read() */
  unsigned char *bufwrite; /* highest address writable by macro */
  unsigned char *bufstart; /* the start of the buffer */
  unsigned char *bufend;   /* the end of the buffer; ie the byte after the last
                              malloc()ed byte */

  int fd; /* the file descriptor associated with the stream */
  int mode;

  char unbuf[8];	   /* The buffer for 'unbuffered' streams */

  struct __stdio_file * next;
};

#define EOF	(-1)
#ifndef NULL
#define NULL	((void*)0)
#endif

typedef struct __stdio_file FILE;

#define BUFSIZ	(256)

extern FILE stdin[1];
extern FILE stdout[1];
extern FILE stderr[1];

#define putc(c, stream)	\
    (((stream)->bufpos >= (stream)->bufwrite) ? fputc((c), (stream))	\
                          : (unsigned char) (*(stream)->bufpos++ = (c))	)

#define getc(stream)	\
  (((stream)->bufpos >= (stream)->bufread) ? fgetc(stream):		\
    (*(stream)->bufpos++))

#define putchar(c) putc((c), stdout)  
#define getchar() getc(stdin)

#define ferror(fp)	(((fp)->mode&__MODE_ERR) != 0)
#define feof(fp)   	(((fp)->mode&__MODE_EOF) != 0)
#define clearerr(fp)	((fp)->mode &= ~(__MODE_EOF|__MODE_ERR),0)
#define fileno(fp)	((fp)->fd)

/* declare functions; not like it makes much difference without ANSI */
/* RDB: The return values _are_ important, especially if we ever use
        8086 'large' model
 */

/* These two call malloc */
#define setlinebuf(__fp)             setvbuf((__fp), (char*)0, _IOLBF, 0)
extern int setvbuf __P((FILE*, char*, int, size_t));

/* These don't */
#define setbuf(__fp, __buf) setbuffer((__fp), (__buf), BUFSIZ)
extern void setbuffer __P((FILE*, char*, int));

extern int fgetc __P((FILE*));
extern int fputc __P((int, FILE*));
extern int ungetc __P((int, FILE*));

extern int fclose __P((FILE*));
extern int fflush __P((FILE*));
extern char *fgets __P((char*, int, FILE*));
extern char *gets __P((char*));		/* don't use it */
extern size_t fread __P((void*, size_t, size_t, FILE*));
extern size_t fwrite __P((__const void*, size_t, size_t, FILE*));

extern FILE *fopen __P((__const char*, __const char*));
extern int remove __P((__const char*));
extern FILE *fdopen __P((int, __const char*));
extern FILE *freopen  __P((__const char*, __const char*, FILE*));
extern FILE *__fopen __P((__const char*, int, FILE*, __const char*));

extern int fseek __P((FILE*, long, int));
extern long ftell __P((FILE*));
extern void rewind __P((FILE*));

extern int fputs __P((__const char*, FILE*));
extern int puts __P((__const char*));

extern int printf __P ((__const char*, ...));
extern int fprintf __P ((FILE*, __const char*, ...));
extern int sprintf __P ((char*, __const char*, ...));
extern int snprintf __P ((char*, size_t, __const char*, ...));
/* (the va_list in these is a char *, as stdarg.h says) */
extern int vprintf __P ((__const char*, char*));
extern int vfprintf __P ((FILE*, __const char*, char*));
extern int vsprintf __P ((char*, __const char*, char*));
extern int vsnprintf __P ((char*, size_t, __const char*, char*));

extern int scanf __P ((__const char*, ...));
extern int fscanf __P ((FILE*, __const char*, ...));
extern int sscanf __P ((__const char*, __const char*, ...));
extern int vscanf __P ((__const char*, char*));
extern int vfscanf __P ((FILE*, __const char*, char*));
extern int vsscanf __P ((__const char*, __const char*, char*));

#define stdio_pending(fp) ((fp)->bufread>(fp)->bufpos)

#endif /* __STDIO_H */
