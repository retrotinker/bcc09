
copt: copt.c
	$(CC) $(ANSI) $(CFLAGS) $(LDFLAGS) -o $@ copt.c

install: copt
	install -d $(LIBEXECDIR)
	install -m 755 copt $(LIBEXECDIR)/copt
	install -m 755 rules.6809 $(LIBEXECDIR)/rules.6809

realclean clean:
	rm -f *.o copt

