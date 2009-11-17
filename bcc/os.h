/* os.h - source/target operating system dependencies for bcc */

/* Copyright (C) 1992 Bruce Evans */

/*
  must have unix-near-compatible creat, open, read, write and close

  source O/S's supported:
    default:
      *IX
    special:
      EDOS		(#define SOS_EDOS if required)
      MSDOS		(#define SOS_MSDOS)
  target O/S's supported:
    default:
      *IX
      MSDOS
    special:
      EDOS		(#define TOS_EDOS)
*/

/* defaults */

#define CREATPERMS 0666		/* permissions for creat */
#define EOL 10			/* source newline */
#define EOLTO 10		/* target newline */
#define DIRCHAR '/'
#define DIRSTRING "/"
#define isabspath(fnameptr, tempcptr) \
	((*(tempcptr) = *(fnameptr)) == DIRCHAR)

/* special */



/* don't let names dealt with here affect anything outside this file */

#undef SOS_EDOS
#undef SOS_MSDOS
