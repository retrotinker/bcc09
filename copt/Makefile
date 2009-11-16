
copt09: copt.c
	$(CC) $(ANSI) $(CFLAGS) $(LDFLAGS) -o $@ copt.c

install: copt09
	install -d $(LIBDIR)
	install -m 755 copt09 $(LIBDIR)/copt09

realclean clean:
	rm -f *.o copt09

