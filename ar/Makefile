# Copyright (c) 1999 Greg Haerr <greg@censoft.com>
# This file is part of the Linux-8086 Development environment and is
# distributed under the GNU General Public License.

LIBDIR	=$(PREFIX)/bin
# CFLAGS and LDFLAGS may come from the environment (rpmbuild's)
CFLAGS	?=-O
LDFLAGS	?=
ALL_CFLAGS=-std=gnu89 $(CFLAGS)
DEFS	=
OBJS= ar.o alloca.o

all: ar09

ar09: $(OBJS)
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) $(OBJS) -o $@

install: ar09
	install -d $(DESTDIR)$(LIBDIR)
	install -m 755 ar09 $(DESTDIR)$(LIBDIR)

clean realclean clobber:
	rm -f *.o ar09 ar rel_aout.h

$(OBJS): rel_aout.h

rel_aout.h:
	test -f rel_aout.h || \
	{ rm -f rel_aout.h ; ln -s ../ld/rel_aout.h . ; } || \
	ln ../ld/rel_aout.h .

.c.o:
	$(CC) $(ALL_CFLAGS) $(DEFS) -c $< -o $@
