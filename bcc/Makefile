#
# bcc Makefile
# $Id$
#

PREFIX=/usr

CFLAGS	=-O -fno-builtin-exp2 -DNOFLOAT -DNOLONG
LDFLAGS	=-s
BINDIR	=$(PREFIX)/bin
LIBEXECDIR	=$(PREFIX)/libexec/bcc09
BCCDEFS	=-DLOCALPREFIX=$(PREFIX) -DBINDIR=$(BINDIR)

BCFLAGS=$(ANSI) $(CFLAGS) $(LDFLAGS)

OBJS = cc1.o codefrag.o dbnode.o declare.o express.o exptree.o floatop.o \
	function.o gencode.o genloads.o glogcode.o hardop.o input.o label.o \
	loadexp.o longop.o output.o preproc.o preserve.o scan.o softop.o \
	state.o table.o type.o assign.o hashcmd.o debug.o dbprintf.o

all:	bcc09 cc1

install: all
	install -d $(BINDIR)
	install -m 755 bcc09 $(BINDIR)/bcc09
	install -d $(LIBEXECDIR)
	install -m 755 cc1 $(LIBEXECDIR)/cc1

bcc09: bcc.c
	$(CC) $(BCFLAGS) $(BCCDEFS) bcc.c -o $@

cc1: $(OBJS)
	$(CC) $(BCCARCH) $(LDFLAGS) $(OBJS) -o cc1

debug.o: debug.c debug.h
	$(CC) $(ANSI) $(BCCARCH) $(CFLAGS) -c debug.c

dbprintf.o: dbprintf.c
	$(CC) $(ANSI) $(BCCARCH) $(CFLAGS) -c dbprintf.c

clean realclean:
	rm -f bcc09 cc1 bcc.o $(OBJS)


$(OBJS):  bcc.h align.h const.h types.h \
          byteord.h condcode.h gencode.h \
	  input.h label.h os.h output.h \
	  parse.h proto.h reg.h sc.h scan.h \
	  sizes.h table.h type.h

.c.o:
	$(CC) $(BCCARCH) $(CFLAGS) -c $<
