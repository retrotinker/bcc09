# libc for bcc09: built with this tree's assembler and librarian, and
# installed where bcc09 looks for it ($(PREFIX)/lib/bcc09)

PREFIX	=/usr/local/bcc09
LIBDIR	=$(PREFIX)/lib/bcc09

AS09	=../as/as09
AR09	=../ar/ar09

# crt0.o: start-up code, linked first (not part of libc.a)
# bcc: the run-time helpers the compiler calls
# stdlib: exit
# string: string and memory functions
OBJS	= bcc/imul.o bcc/idiv.o bcc/ishift.o \
	  bcc/laddsub.o bcc/llogic.o bcc/lcmp.o bcc/lunary.o \
	  bcc/lincdec.o bcc/lshift.o bcc/lmul.o bcc/ldiv.o \
	  stdlib/exit.o \
	  string/memcpy.o

all: crt0.o libc.a

libc.a: $(OBJS)
	rm -f $@
	$(AR09) rc $@ $(OBJS)

.SUFFIXES: .s .o
.s.o:
	$(AS09) -w -o $@ $<

install: crt0.o libc.a
	install -d $(LIBDIR)
	install -m 644 crt0.o libc.a $(LIBDIR)

clean realclean clobber:
	rm -f crt0.o libc.a $(OBJS)

.PHONY: all install clean realclean clobber
