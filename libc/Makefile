# libc for bcc09: built with this tree's compiler, assembler and
# librarian, and installed where bcc09 looks for it ($(PREFIX)/lib/bcc09,
# and the headers in $(PREFIX)/lib/bcc09/include)

PREFIX	=/usr/local/bcc09
LIBDIR	=$(PREFIX)/lib/bcc09

AS09	=../as/as09
AR09	=../ar/ar09

# bcc09 finds its passes under BCC_PREFIX: .bcc has links to this tree's
BCC	=BCC_PREFIX=$(CURDIR)/.bcc ../bcc/bcc09
BCCFLAGS=-O -Iinclude

# libc.a holds what is the same for every target.  Each target has its
# own start-up code, which bcc09 links first (ld09 -C<name>: crt<name>.o),
# and a library of what differs (_exit, read, write), selected by bcc09's
# -M option:
#   sa:  the default (-Ms, -Me): crt0.o and libsa.a, which return to the
#        program's loader; no I/O
#   sim: sim6809 (-Mi): crtsim.o and libsim.a
#
# bcc: the run-time helpers the compiler calls
# ctype: character classes
# stdlib: stdlib.h's functions, and errno
# string: string and memory functions
# malloc: malloc, free, calloc and realloc (sbrk and brk are in stdlib)
# stdio: the FILE functions (stdio.c, dev86's) and the printf family
# Some sources hold several functions, each compiled separately with
# -DL_name: string.c (STRING_OBJS), malloc.c, stdio.c, printf.c, abs.c,
# strtol.c and rand.c, and sim/sys.c
STRING_OBJS = string/strlen.o string/strcat.o string/strcpy.o \
	  string/strcmp.o string/strncat.o string/strncpy.o \
	  string/strncmp.o string/strchr.o string/strrchr.o string/strdup.o \
	  string/memccpy.o string/memchr.o string/memset.o \
	  string/memcmp.o string/memmove.o
MALLOC_OBJS = malloc/malloc.o malloc/free.o malloc/calloc.o \
	  malloc/realloc.o
STDIO_OBJS = stdio/_stdio_init.o stdio/fputc.o stdio/fgetc.o \
	  stdio/fflush.o stdio/fgets.o stdio/gets.o stdio/fputs.o \
	  stdio/puts.o stdio/fread.o stdio/fwrite.o stdio/fopen.o \
	  stdio/fdopen.o stdio/freopen.o stdio/__fopen.o stdio/fclose.o \
	  stdio/fseek.o stdio/rewind.o stdio/ftell.o stdio/setbuffer.o \
	  stdio/setvbuf.o stdio/ungetc.o
PRINTF_OBJS = stdio/__vformat.o stdio/vfprintf.o stdio/vprintf.o \
	  stdio/printf.o stdio/fprintf.o stdio/vsnprintf.o \
	  stdio/vsprintf.o stdio/sprintf.o stdio/snprintf.o
ABS_OBJS = stdlib/abs.o stdlib/labs.o
STRTOL_OBJS = stdlib/strtol.o stdlib/strtoul.o
RAND_OBJS = stdlib/rand.o stdlib/srand.o
OBJS	= bcc/imul.o bcc/idiv.o bcc/ishift.o \
	  bcc/laddsub.o bcc/llogic.o bcc/lcmp.o bcc/lunary.o \
	  bcc/lincdec.o bcc/lshift.o bcc/lmul.o bcc/ldiv.o \
	  ctype/ctype.o ctype/ctypefn.o \
	  $(MALLOC_OBJS) $(STDIO_OBJS) $(PRINTF_OBJS) \
	  stdlib/exit.o stdlib/atexit.o stdlib/errno.o \
	  stdlib/sbrk.o \
	  stdlib/atoi.o stdlib/atol.o $(STRTOL_OBJS) $(ABS_OBJS) \
	  stdlib/itoa.o stdlib/ltoa.o stdlib/ltostr.o \
	  stdlib/qsort.o stdlib/bsearch.o $(RAND_OBJS) \
	  string/memcpy.o $(STRING_OBJS) \
	  string/strcspn.o string/strpbrk.o string/strsep.o \
	  string/strspn.o string/strstr.o string/strtok.o \
	  string/strcasecmp.o string/strncasecmp.o

HEADERS	= include/ctype.h include/errno.h include/fcntl.h \
	  include/features.h include/stdio.h \
	  include/limits.h include/malloc.h include/stdarg.h include/stddef.h \
	  include/stdlib.h include/string.h include/sys/types.h \
	  include/unistd.h

SA_OBJS	= sa/_exit.o
SIM_SYS_OBJS = sim/isatty.o sim/lseek.o sim/close.o sim/open.o
SIM_OBJS = sim/_exit.o sim/read.o sim/write.o $(SIM_SYS_OBJS)

TARGETS	= crt0.o libsa.a crtsim.o libsim.a

all: libc.a $(TARGETS)

libc.a: $(OBJS)
	rm -f $@
	$(AR09) rc $@ $(OBJS)

crt0.o: sa/crt0.o
	cp sa/crt0.o $@
libsa.a: $(SA_OBJS)
	rm -f $@
	$(AR09) rc $@ $(SA_OBJS)

crtsim.o: sim/crtsim.o
	cp sim/crtsim.o $@
libsim.a: $(SIM_OBJS)
	rm -f $@
	$(AR09) rc $@ $(SIM_OBJS)

.bcc/stamp:
	rm -rf .bcc
	mkdir -p .bcc/bin .bcc/libexec/bcc09
	ln -s $(CURDIR)/../as/as09 $(CURDIR)/../ld/ld09 .bcc/bin/
	ln -s $(CURDIR)/../cpp/cpp $(CURDIR)/../bcc/cc1 \
	      $(CURDIR)/../copt/copt $(CURDIR)/../copt/rules.6809 \
	      $(CURDIR)/../unproto/unproto .bcc/libexec/bcc09/
	touch $@

$(STRING_OBJS): string/%.o: string/string.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ string/string.c
$(STDIO_OBJS): stdio/%.o: stdio/stdio.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ stdio/stdio.c
$(PRINTF_OBJS): stdio/%.o: stdio/printf.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ stdio/printf.c
$(SIM_SYS_OBJS): sim/%.o: sim/sys.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ sim/sys.c
$(MALLOC_OBJS): malloc/%.o: malloc/malloc.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ malloc/malloc.c
$(ABS_OBJS): stdlib/%.o: stdlib/abs.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ stdlib/abs.c
$(STRTOL_OBJS): stdlib/%.o: stdlib/strtol.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ stdlib/strtol.c
$(RAND_OBJS): stdlib/%.o: stdlib/rand.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ stdlib/rand.c

.SUFFIXES: .s .c .o
.s.o:
	$(AS09) -w -o $@ $<
.c.o:
	$(BCC) $(BCCFLAGS) -c -o $@ $<

$(OBJS): .bcc/stamp $(HEADERS)

install: libc.a $(TARGETS)
	install -d $(LIBDIR) $(LIBDIR)/include/sys
	install -m 644 libc.a $(TARGETS) $(LIBDIR)
	install -m 644 include/*.h $(LIBDIR)/include
	install -m 644 include/sys/*.h $(LIBDIR)/include/sys

clean realclean clobber:
	rm -f libc.a $(OBJS) $(TARGETS) sa/*.o sim/*.o stdio/*.o
	rm -rf .bcc

.PHONY: all install clean realclean clobber
