/* trun prog [args...]: runs the module prog on NitrOS-9 with the
   arguments, through F$Fork (it gets trun's standard paths, as the
   startup script redirected them) and F$Wait, and writes its exit status
   to prog.rc, as tests/run.sh writes sim6809's to tests/ref/prog.run.rc,
   since the startup script can't see it (see run.sh) */

#include <stdio.h>
#include <string.h>
#include "../../libc/os9/os9.h"

int main(argc, argv)
int argc;
char **argv;
{
	struct os9regs r;
	char params[256], rcname[40];
	int i, n = 0, status;
	FILE *fp;

	if (argc < 2)
		return 1;
	for (i = 2; i < argc; i++) {
		if (n + strlen(argv[i]) + 2 > sizeof(params))
			return 1;
		if (i > 2)
			params[n++] = ' ';
		strcpy(params + n, argv[i]);
		n += strlen(argv[i]);
	}
	params[n++] = '\r';	/* (the parameters end with a CR) */

	OS9_CLEAR(&r);
	r.a = 0x11;		/* a 6809 program */
	r.x = (unsigned) argv[1];
	r.y = n;
	r.u = (unsigned) params;
	__os9call(&r, OS9_FORK);
	if (OS9_FAILED(&r))
		status = 1000 + r.b;	/* (F$Fork's error) */
	else {
		OS9_CLEAR(&r);
		__os9call(&r, OS9_WAIT);
		status = OS9_FAILED(&r) ? 2000 + r.b : r.b;
	}

	sprintf(rcname, "%s.rc", argv[1]);
	if ((fp = fopen(rcname, "w")) == 0)
		return 1;
	fprintf(fp, "%d\n", status);
	fclose(fp);
	return 0;
}
