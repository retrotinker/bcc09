
copt: copt.c
	$(CC) $(ANSI) $(CFLAGS) $(LDFLAGS) -o $@ copt.c

install: copt
	install -d $(LIBEXECDIR)
	install -m 755 copt $(LIBEXECDIR)/copt

realclean clean:
	rm -f *.o copt

