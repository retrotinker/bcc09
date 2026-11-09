/* os9.h - OS-9's system calls, for libc on OS-9 (bcc09 -Mo): libc's own,
 * not installed
 *
 * Written for bcc09.  Like the rest of libc, it is distributed under the
 * GNU Library General Public License, version 2 (see COPYING.LIB).
 */

/* the registers of a system call (call.s) */
struct os9regs
{
   unsigned char cc, a, b, dp;
   unsigned x, y, u;
};

extern int __os9call();		/* (r, call): C set in r->cc for an error (call.s) */
extern int __os9errno();	/* (b): errno for OS-9's error code b */

/* the calls, as call.s's stubs have them */
#define OS9_EXIT	0
#define OS9_OPEN	1
#define OS9_CREATE	2
#define OS9_CLOSE	3
#define OS9_READLN	4
#define OS9_WRITLN	5
#define OS9_SEEK	6
#define OS9_GETSTT	7
#define OS9_SETSTT	8
#define OS9_DELETE	9
#define OS9_READ	10
#define OS9_MAKDIR	11
#define OS9_CHGDIR	12
#define OS9_MEM		13
#define OS9_FORK	14
#define OS9_WAIT	15

#define OS9_FAILED(r)	((r)->cc & 1)

/* every register 0, before a call sets those it uses: OS-9 may read
   others (with what was on the stack in A and Y, I$MakDir gave a new
   directory nearly all of a disk) */
#define OS9_CLEAR(r)	((r)->cc = (r)->a = (r)->b = (r)->dp = 0, \
			 (r)->x = (r)->y = (r)->u = 0)

/* OS-9's error codes */
#define E_BPNUM	0xc9		/* bad path number */
#define E_BMODE	0xcb		/* bad mode */
#define E_EOF	0xd3		/* end of file */
#define E_FNA	0xd6		/* file not accessible */
#define E_PNNF	0xd8		/* path name not found */
#define E_CEF	0xda		/* creating an existing file */
#define E_MEMFUL 0xcf		/* memory full */

/* I$GetStt and I$SetStt codes */
#define SS_OPT	0		/* path options (32 bytes at X) */
#define SS_SIZE	2		/* file size (X:U) */
#define SS_POS	5		/* file position (X:U) */
