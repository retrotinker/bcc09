# libc for bcc09: built with this tree's compiler, assembler and
# librarian, and installed where bcc09 looks for it ($(PREFIX)/lib/bcc09,
# and the headers in $(PREFIX)/lib/bcc09/include)

PREFIX	=/usr/local/bcc09
LIBDIR	=$(PREFIX)/lib/bcc09

# (TOP, this directory, also when OS-9's libc is built in os9obj)
TOP	?=$(CURDIR)
AS09	=$(TOP)/../as/as09
AR09	=$(TOP)/../ar/ar09

# bcc09 finds its passes under BCC_PREFIX: .bcc has links to this tree's
BCC	=BCC_PREFIX=$(TOP)/.bcc $(TOP)/../bcc/bcc09
BCCFLAGS=-O -I$(TOP)/include

# libc.a holds what is the same for every target.  Each target has its
# own start-up code, which bcc09 links first (ld09 -C<name>: crt<name>.o),
# and a library of what differs (_exit, read, write), selected by bcc09's
# -M option:
#   sa:  the default (-Ms): crt0.o and libsa.a, which return to the
#        program's loader; no I/O
#   cb:  Color BASIC (-Me, a program run with EXEC): crt0.o and libcb.a,
#        with I/O through the ROM
#   sim: sim6809 (-Mi): crtsim.o and libsim.a
#   flex: FLEX (-Mf, a .CMD command): crtflex.o and libflex.a, with I/O
#        through FLEX's DOS
#   os9: OS-9 (-Mo): crtos9.o and libos9.a, which is all of libc built
#        again with -Mo (position-independent, data through U) in os9obj,
#        with os9/'s sbrk, hooks and system functions
#
# bcc: the run-time helpers the compiler calls
# ctype: character classes
# stdlib: stdlib.h's functions, and errno
# string: string and memory functions
# math: math.h, from Sun's fdlibm (math/README)
# malloc: malloc, free, calloc and realloc (sbrk and brk are in stdlib)
# stdio: the FILE functions (stdio.c, dev86's) and the printf and scanf
#        families (their floating point in fpfmt.c and scanfp.c, linked
#        through xfpcvt.s and xfptvc.s only where it is used)
# Some sources hold several functions, each compiled separately with
# -DL_name: string.c (STRING_OBJS), malloc.c, stdio.c, getdelim.c, printf.c, scanf.c, abs.c,
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
SCANF_OBJS = stdio/__vscan.o stdio/vfscanf.o stdio/vscanf.o \
	  stdio/vsscanf.o stdio/scanf.o stdio/fscanf.o stdio/sscanf.o
MATH_OBJS = math/e_acos.o math/e_asin.o math/s_atan.o math/e_atan2.o \
	  math/s_ceil.o math/s_cos.o math/e_cosh.o math/e_exp.o math/s_fabs.o \
	  math/s_floor.o math/e_fmod.o math/s_frexp.o math/s_ldexp.o \
	  math/e_log.o math/e_log10.o math/s_modf.o math/e_pow.o math/s_sin.o \
	  math/e_sinh.o math/e_sqrt.o math/s_tan.o math/s_tanh.o math/k_sin.o \
	  math/k_cos.o math/k_tan.o math/e_rem_pio2.o math/k_rem_pio2.o \
	  math/s_expm1.o math/s_scalbn.o math/s_copysign.o math/s_finite.o \
	  math/huge.o
ABS_OBJS = stdlib/abs.o stdlib/labs.o
STRTOL_OBJS = stdlib/strtol.o stdlib/strtoul.o
RAND_OBJS = stdlib/rand.o stdlib/srand.o
GETDELIM_OBJS = stdio/getdelim.o stdio/getline.o
OBJS	= bcc/imul.o bcc/idiv.o bcc/ishift.o \
	  bcc/laddsub.o bcc/llogic.o bcc/lcmp.o bcc/lunary.o \
	  bcc/lincdec.o bcc/lshift.o bcc/lmul.o bcc/ldiv.o \
	  bcc/fpcore.o bcc/fpops.o bcc/fparith.o bcc/fpcmp.o bcc/fppush.o \
	  bcc/fpconv.o bcc/fpincdec.o \
	  ctype/ctype.o ctype/ctypefn.o \
	  $(MALLOC_OBJS) $(STDIO_OBJS) $(GETDELIM_OBJS) \
	  $(PRINTF_OBJS) stdio/fpfmt.o stdio/xfpcvt.o \
	  $(SCANF_OBJS) stdio/scanfp.o stdio/xfptvc.o stdio/remove.o \
	  stdlib/exit.o stdlib/atexit.o stdlib/errno.o stdlib/bignum.o \
	  stdlib/strtod.o stdlib/atof.o \
	  stdlib/sbrk.o \
	  stdlib/atoi.o stdlib/atol.o $(STRTOL_OBJS) $(ABS_OBJS) \
	  stdlib/itoa.o stdlib/ltoa.o stdlib/ltostr.o \
	  stdlib/qsort.o stdlib/bsearch.o $(RAND_OBJS) \
	  string/memcpy.o $(STRING_OBJS) \
	  string/strcspn.o string/strpbrk.o string/strsep.o \
	  string/strspn.o string/strstr.o string/strtok.o \
	  string/strcasecmp.o string/strncasecmp.o $(MATH_OBJS)

HEADERS	= include/ctype.h include/errno.h include/fcntl.h \
	  include/features.h include/stdio.h include/math.h \
	  include/stdint.h include/stdbool.h include/dirent.h \
	  include/limits.h include/malloc.h include/stdarg.h include/stddef.h \
	  include/stdlib.h include/string.h include/sys/types.h include/sys/stat.h \
	  include/unistd.h

SA_OBJS	= sa/_exit.o
CB_SYS_OBJS = cb/write.o cb/read.o cb/isatty.o cb/lseek.o cb/close.o \
	  cb/__cb_files.o
CB_OBJS	= sa/_exit.o cb/rom.o cb/disk.o cb/dskcon.o $(CB_SYS_OBJS)
FLEX_SYS_OBJS = flex/write.o flex/read.o flex/isatty.o flex/lseek.o \
	  flex/close.o flex/__flex_files.o
FLEX_OBJS = flex/flex.o flex/start.o flex/file.o $(FLEX_SYS_OBJS)
SIM_SYS_OBJS = sim/isatty.o sim/lseek.o sim/close.o sim/open.o
SIM_OBJS = sim/_exit.o sim/read.o sim/write.o $(SIM_SYS_OBJS)

OS9_SYS_OBJS = os9/__os9errno.o os9/_exit.o os9/write.o os9/read.o \
	  os9/open.o os9/close.o os9/lseek.o os9/isatty.o os9/unlink.o \
	  os9/mkdir.o os9/chdir.o os9/opendir.o os9/readdir.o \
	  os9/rewinddir.o os9/closedir.o
OS9_OBJS = $(filter-out stdlib/sbrk.o stdio/xfpcvt.o stdio/xfptvc.o,$(OBJS)) \
	  os9/call.o os9/start.o os9/sbrk.o os9/xfpcvt.o os9/xfptvc.o \
	  $(OS9_SYS_OBJS)
OS9_DIRS = bcc ctype malloc stdio stdlib string math os9

TARGETS	= crt0.o libsa.a libcb.a crtsim.o libsim.a crtos9.o libos9.a \
	  crtflex.o libflex.a

all: libc.a $(TARGETS)

libc.a: $(OBJS)
	rm -f $@
	$(AR09) rc $@ $(OBJS)

crt0.o: sa/crt0.o
	cp $< $@
libsa.a: $(SA_OBJS)
	rm -f $@
	$(AR09) rc $@ $(SA_OBJS)

crtsim.o: sim/crtsim.o
	cp $< $@
libsim.a: $(SIM_OBJS)
	rm -f $@
	$(AR09) rc $@ $(SIM_OBJS)

crtflex.o: flex/crt0.o
	cp $< $@
libflex.a: $(FLEX_OBJS)
	rm -f $@
	$(AR09) rc $@ $(FLEX_OBJS)

libcb.a: $(CB_OBJS)
	rm -f $@
	$(AR09) rc $@ $(CB_OBJS)

ifdef SUBOS9
# (in os9obj, finding the sources in TOP: not with VPATH, which would
# find the other build's objects there too)
vpath %.c $(TOP)
vpath %.s $(TOP)
vpath %.h $(TOP)
vpath %stamp $(TOP)
libos9.a: $(OS9_OBJS)
	rm -f $@
	$(AR09) rc $@ $(OS9_OBJS)
crtos9.o: os9/crt0.o
	cp $< $@
$(OS9_SYS_OBJS): os9/%.o: os9/sys.c os9/os9.h $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
os9/start.o os9/sbrk.o: $(HEADERS) .bcc/stamp $(TOOLS)
else
libos9.a crtos9.o: os9build
	cmp -s os9obj/$@ $@ || cp os9obj/$@ $@
os9build: .bcc/stamp
	mkdir -p $(addprefix os9obj/,$(OS9_DIRS))
	$(MAKE) -C os9obj -f $(TOP)/Makefile TOP=$(TOP) SUBOS9=1 \
		BCCFLAGS="-O -Mo -I$(TOP)/include" libos9.a crtos9.o
.PHONY: os9build
endif

.bcc/stamp:
	rm -rf .bcc
	mkdir -p .bcc/bin .bcc/libexec/bcc09
	ln -s $(TOP)/../as/as09 $(TOP)/../ld/ld09 .bcc/bin/
	ln -s $(TOP)/../cpp/cpp $(TOP)/../bcc/cc1 \
	      $(TOP)/../copt/copt $(TOP)/../copt/rules.6809 \
	      $(TOP)/../unproto/unproto .bcc/libexec/bcc09/
	touch $@

$(STRING_OBJS): string/%.o: string/string.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(STDIO_OBJS): stdio/%.o: stdio/stdio.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(PRINTF_OBJS): stdio/%.o: stdio/printf.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(SCANF_OBJS): stdio/%.o: stdio/scanf.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(CB_SYS_OBJS): cb/%.o: cb/sys.c cb/cb.h $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(FLEX_SYS_OBJS): flex/%.o: flex/sys.c flex/flex.h $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(SIM_SYS_OBJS): sim/%.o: sim/sys.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(MALLOC_OBJS): malloc/%.o: malloc/malloc.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(ABS_OBJS): stdlib/%.o: stdlib/abs.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(STRTOL_OBJS): stdlib/%.o: stdlib/strtol.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(RAND_OBJS): stdlib/%.o: stdlib/rand.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<
$(GETDELIM_OBJS): stdio/%.o: stdio/getdelim.c $(HEADERS) .bcc/stamp
	$(BCC) $(BCCFLAGS) -DL_$* -c -o $@ $<

.SUFFIXES: .s .c .o
.s.o:
	$(AS09) -w -o $@ $<
.c.o:
	$(BCC) $(BCCFLAGS) -c -o $@ $<

$(OBJS): .bcc/stamp $(HEADERS)
# libc's own headers
$(SCANF_OBJS) stdio/scanfp.o: stdio/scan.h
stdio/fpfmt.o stdlib/bignum.o stdlib/strtod.o: stdlib/bignum.h
$(MATH_OBJS): math/fdlibm.h
cb/disk.o: cb/cb.h $(HEADERS) .bcc/stamp
flex/file.o: flex/flex.h $(HEADERS) .bcc/stamp

# everything is built again when the tools change, the optimizer's rules
# too (libc is built with -O)
TOOLS	= $(TOP)/../bcc/bcc09 $(TOP)/../bcc/cc1 $(TOP)/../cpp/cpp \
	  $(TOP)/../unproto/unproto $(TOP)/../copt/copt \
	  $(TOP)/../copt/rules.6809 $(AS09)
$(OBJS) $(SA_OBJS) $(CB_OBJS) $(SIM_OBJS) $(FLEX_OBJS) sa/crt0.o \
	sim/crtsim.o flex/crt0.o: $(TOOLS)

install: libc.a $(TARGETS)
	install -d $(LIBDIR) $(LIBDIR)/include/sys
	install -m 644 libc.a $(TARGETS) $(LIBDIR)
	install -m 644 include/*.h $(LIBDIR)/include
	install -m 644 include/sys/*.h $(LIBDIR)/include/sys

clean realclean clobber:
	rm -f libc.a $(OBJS) $(TARGETS) sa/*.o cb/*.o sim/*.o flex/*.o \
	      stdio/*.o
	rm -rf .bcc os9obj

.PHONY: all install clean realclean clobber
