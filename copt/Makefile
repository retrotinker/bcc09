
copt: copt.c
	$(CC) $(ANSI) $(CFLAGS) $(LDFLAGS) -o $@ copt.c

install: copt
	install -d $(DESTDIR)$(LIBEXECDIR)
	install -m 755 copt $(DESTDIR)$(LIBEXECDIR)/copt
	install -m 644 rules.6809 $(DESTDIR)$(LIBEXECDIR)/rules.6809

realclean clean:
	rm -f *.o copt

