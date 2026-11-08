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

# crt0.o: start-up code, linked first (not part of libc.a)
# bcc: the run-time helpers the compiler calls
# stdlib: exit
# string: string and memory functions; string.c holds one function for
#	each of STRING_OBJS, compiled with -DL_name
STRING_OBJS = string/strlen.o string/strcat.o string/strcpy.o \
	  string/strcmp.o string/strncat.o string/strncpy.o \
	  string/strncmp.o string/strchr.o string/strrchr.o \
	  string/memccpy.o string/memchr.o string/memset.o \
	  string/memcmp.o string/memmove.o
OBJS	= bcc/imul.o bcc/idiv.o bcc/ishift.o \
	  bcc/laddsub.o bcc/llogic.o bcc/lcmp.o bcc/lunary.o \
	  bcc/lincdec.o bcc/lshift.o bcc/lmul.o bcc/ldiv.o \
	  stdlib/exit.o \
	  string/memcpy.o $(STRING_OBJS) \
	  string/strcspn.o string/strpbrk.o string/strsep.o \
	  string/strspn.o string/strstr.o string/strtok.o

HEADERS	= include/features.h include/stddef.h include/string.h \
	  include/sys/types.h

all: crt0.o libc.a

libc.a: $(OBJS)
	rm -f $@
	$(AR09) rc $@ $(OBJS)

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

.SUFFIXES: .s .c .o
.s.o:
	$(AS09) -w -o $@ $<
.c.o:
	$(BCC) $(BCCFLAGS) -c -o $@ $<

$(OBJS): .bcc/stamp $(HEADERS)

install: crt0.o libc.a
	install -d $(LIBDIR) $(LIBDIR)/include/sys
	install -m 644 crt0.o libc.a $(LIBDIR)
	install -m 644 include/*.h $(LIBDIR)/include
	install -m 644 include/sys/*.h $(LIBDIR)/include/sys

clean realclean clobber:
	rm -f crt0.o libc.a $(OBJS)
	rm -rf .bcc

.PHONY: all install clean realclean clobber
