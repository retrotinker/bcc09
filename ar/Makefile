# Copyright (c) 1999 Greg Haerr <greg@censoft.com>
# This file is part of the Linux-8086 Development environment and is
# distributed under the GNU General Public License.

LIBDIR	=$(PREFIX)/bin
# CFLAGS and LDFLAGS may come from the environment (rpmbuild's)
CFLAGS	?=-O
LDFLAGS	?=
ALL_CFLAGS=-std=gnu89 $(CFLAGS)
DEFS	=
OBJS= ar.o

all: ar09

ar09: $(OBJS)
	$(CC) $(ALL_CFLAGS) $(LDFLAGS) $(OBJS) -o $@

install: ar09
	install -d $(DESTDIR)$(LIBDIR)
	install -m 755 ar09 $(DESTDIR)$(LIBDIR)

clean realclean clobber:
	rm -f *.o ar09 ar

.c.o:
	$(CC) $(ALL_CFLAGS) $(DEFS) -c $< -o $@
