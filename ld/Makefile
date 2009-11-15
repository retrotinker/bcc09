
LIBDIR	=/usr/bin
CFLAGS	=-O
LDFLAGS	=

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
      writex86.o writebin.o writeemu.o

all: ld09 objchop catimage objdump09

ld09: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

objdump09: objdump86.c
	$(CC) $(LDFLAGS) $< -o $@

install: ld09
	install -d $(LIBDIR)
	install -m 755 ld09 $(LIBDIR)

clean realclean clobber:
	rm -f *.o ld09 objchop catimage objdump09

$(OBJS): align.h bindef.h byteord.h config.h const.h globvar.h obj.h \
	 syshead.h type.h x86_aout.h

writebin.o: writebin.c
	$(CC) $(CFLAGS) $(DEFS) $(NATIVE) -c $<

writerel.o: writebin.c

.c.o:
	$(CC) $(CFLAGS) $(DEFS) -c $< -o $@
