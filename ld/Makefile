
LIBDIR	=$(PREFIX)/bin
# CFLAGS and LDFLAGS may come from the environment (rpmbuild's)
CFLAGS	?=-O
LDFLAGS	?=
# the version -v prints (VERSION, from the top-level Makefile)
VERDEF=$(if $(VERSION),-DVERSION='"$(VERSION)"')
ALL_CFLAGS=-std=gnu89 -DDATASEGS $(VERDEF) $(CFLAGS)

# Will need some of these if you want native executables on non-Linux/i386
# -DDETECTAOUT			# Turn on detection.
# -DV7_A_OUT			# a.out.h is like V7
# -DBSD_A_OUT			# a.out.h is like BSD
# -DSTANDARD_GNU_A_OUT		# a.out.h is like GNU normal.
#
# -DREL_OUTPUT -DBUGCOMPAT	# -r Produces weird *.o files.
#
DEFS	=-DREL_OUTPUT

# An alternative file for a non-standard a.out.h (eg i386 linux on an Alpha)
#
# NATIVE=-DA_OUT_INCL='"a_out_local.h"' 

OBJS= dumps.o io.o ld.o readobj.o table.o typeconv.o linksyms.o mkar.o \
      writex86.o

all: ld09 objchop catimage objdump09 objcopy09

ld09: $(OBJS)
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) $(OBJS) -o $@

objdump09: objdump86.c
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) $< -o $@

objchop: objchop.c
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) $< -o $@

catimage: catimage.c
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) $< -o $@

objcopy09: objcopy.c srec.c srec.h
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) objcopy.c srec.c -o $@

install: ld09 objdump09 objcopy09
	install -d $(DESTDIR)$(LIBDIR)
	install -m 755 ld09 $(DESTDIR)$(LIBDIR)
	install -m 755 objdump09 $(DESTDIR)$(LIBDIR)
	ln -f $(DESTDIR)$(LIBDIR)/objdump09 $(DESTDIR)$(LIBDIR)/nm09
	ln -f $(DESTDIR)$(LIBDIR)/objdump09 $(DESTDIR)$(LIBDIR)/size09
	install -m 755 objcopy09 $(DESTDIR)$(LIBDIR)

clean realclean clobber:
	rm -f *.o ld09 objchop catimage objdump09 objcopy09

$(OBJS): align.h bindef.h byteord.h config.h const.h globvar.h obj.h \
	 syshead.h type.h x86_aout.h

.c.o:
	$(CC) $(ALL_CFLAGS) $(DEFS) -c $< -o $@

# (VERSION is set there)
io.o: ../Makefile
