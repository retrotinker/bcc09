#
# bcc Makefile
# $Id$
#

PREFIX=/usr/local

# CFLAGS and LDFLAGS may come from the environment (rpmbuild's)
CFLAGS	?=-O
LDFLAGS	?=
# the version -v prints (VERSION, from the top-level Makefile)
VERDEF=$(if $(VERSION),-DVERSION='"$(VERSION)"')
ALL_CFLAGS=-std=gnu89 -fno-builtin-exp2 $(VERDEF) $(CFLAGS)
BINDIR	=$(PREFIX)/bin
LIBEXECDIR	=$(PREFIX)/libexec/bcc09
BCCDEFS	=-DLOCALPREFIX=$(PREFIX) -DBINDIR=$(BINDIR)

BCFLAGS=$(ANSI) $(ALL_CFLAGS) $(LDFLAGS)

OBJS = cc1.o codefrag.o dbnode.o declare.o express.o exptree.o floatop.o \
	function.o gencode.o genloads.o glogcode.o hardop.o input.o label.o \
	loadexp.o longop.o output.o preproc.o preserve.o scan.o softop.o \
	state.o table.o type.o assign.o hashcmd.o debug.o dbprintf.o

all:	bcc09 cc1

install: all
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 bcc09 $(DESTDIR)$(BINDIR)/bcc09
	install -d $(DESTDIR)$(LIBEXECDIR)
	install -m 755 cc1 $(DESTDIR)$(LIBEXECDIR)/cc1

# (../Makefile sets VERSION)
bcc09: bcc.c ../Makefile
	$(CC) $(BCFLAGS) $(BCCDEFS) bcc.c -o $@

cc1: $(OBJS)
	$(CC) $(BCCARCH) $(ALL_CFLAGS) $(LDFLAGS) $(OBJS) -o cc1

debug.o: debug.c debug.h
	$(CC) $(ANSI) $(BCCARCH) $(ALL_CFLAGS) -c debug.c

dbprintf.o: dbprintf.c
	$(CC) $(ANSI) $(BCCARCH) $(ALL_CFLAGS) -c dbprintf.c

clean realclean:
	rm -f bcc09 cc1 bcc.o $(OBJS)


$(OBJS):  bcc.h align.h const.h types.h \
          byteord.h condcode.h gencode.h \
	  input.h label.h os.h output.h \
	  parse.h proto.h reg.h sc.h scan.h \
	  sizes.h table.h type.h

.c.o:
	$(CC) $(BCCARCH) $(ALL_CFLAGS) -c $<
