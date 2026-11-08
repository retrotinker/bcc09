# libc for bcc09: built with this tree's assembler and librarian, and
# installed where bcc09 looks for it ($(PREFIX)/lib/bcc09)

PREFIX	=/usr/local/bcc09
LIBDIR	=$(PREFIX)/lib/bcc09

AS09	=../as/as09
AR09	=../ar/ar09

# bcc: the run-time helpers the compiler calls
# string: string and memory functions
OBJS	= bcc/imul.o bcc/idiv.o bcc/ishift.o \
	  string/memcpy.o

all: libc.a

libc.a: $(OBJS)
	rm -f $@
	$(AR09) rc $@ $(OBJS)

.SUFFIXES: .s .o
.s.o:
	$(AS09) -w -o $@ $<

install: libc.a
	install -d $(LIBDIR)
	install -m 644 libc.a $(LIBDIR)

clean realclean clobber:
	rm -f libc.a $(OBJS)

.PHONY: all install clean realclean clobber
